import { Controller, Get, Post, Param, Query, Body, UseGuards, ParseIntPipe } from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AdminController {
  constructor(private adminService: AdminService) {}

  @Get('users')
  @Roles('admin', 'super_admin')
  listUsers(
    @Query('page', new ParseIntPipe({ optional: true })) page = 1,
    @Query('limit', new ParseIntPipe({ optional: true })) limit = 20,
    @Query('search') search?: string,
    @Query('role') role?: string,
  ) {
    return this.adminService.listUsers(page, limit, search, role);
  }

  @Get('kyc')
  @Roles('admin', 'super_admin')
  getKycQueue() {
    return this.adminService.getKycQueue();
  }

  @Post('kyc/:id/moderate')
  @Roles('admin', 'super_admin')
  moderateKyc(
    @Param('id') id: string,
    @Body() body: { status: 'approved' | 'rejected'; rejectionReason?: string },
    @CurrentUser('id') adminId: string,
  ) {
    return this.adminService.moderateKyc(id, body.status, adminId, body.rejectionReason);
  }

  @Post('products/:id/moderate')
  @Roles('admin', 'super_admin')
  moderateProduct(
    @Param('id') id: string,
    @Body() body: { status: 'approved' | 'rejected'; rejectionReason?: string },
  ) {
    return this.adminService.moderateProduct(id, body.status, body.rejectionReason);
  }

  @Get('audit-logs')
  @Roles('admin', 'super_admin')
  getAuditLogs(
    @Query('page', new ParseIntPipe({ optional: true })) page = 1,
    @Query('limit', new ParseIntPipe({ optional: true })) limit = 50,
    @Query('role') role?: string,
    @Query('action') action?: string,
    @Query('entity') entity?: string,
    @Query('userId') userId?: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.adminService.getAuditLogs({ page, limit, role, action, entity, userId, startDate, endDate });
  }

  @Get('stats')
  @Roles('admin', 'super_admin')
  getStats() {
    return this.adminService.getStats();
  }
}
