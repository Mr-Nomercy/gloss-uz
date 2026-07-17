import { Controller, Get, Patch, Post, Body, UseGuards, ValidationPipe } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  getProfile(@CurrentUser('id') id: string) {
    return this.usersService.findById(id);
  }

  @Patch('me')
  updateProfile(
    @CurrentUser('id') id: string,
    @Body(new ValidationPipe()) body: UpdateProfileDto,
  ) {
    return this.usersService.update(id, body);
  }

  @Get('me/avatar')
  getAvatar(@CurrentUser('id') id: string) {
    return this.usersService.findById(id).then(user => ({ avatar: user.avatar }));
  }

  @Post('me/avatar')
  uploadAvatar(
    @CurrentUser('id') id: string,
    @Body('url') url: string,
  ) {
    return this.usersService.uploadAvatar(id, url);
  }
}
