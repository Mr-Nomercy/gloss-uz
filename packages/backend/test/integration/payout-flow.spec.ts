import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { PrismaService } from '../../src/prisma/prisma.service';
import { AppModule } from '../../src/app.module';
import { JwtService } from '@nestjs/jwt';

describe('Payout Flow Integration Tests', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let jwtService: JwtService;

  let adminToken: string;
  let providerId: string;
  let providerToken: string;
  let courierId: string;
  let courierToken: string;
  let sellerId: string;
  let sellerToken: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    prisma = moduleFixture.get<PrismaService>(PrismaService);
    jwtService = moduleFixture.get<JwtService>(JwtService);

    // Create admin
    const admin = await prisma.user.create({
      data: {
        phone: '+998909998877',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Admin',
        roles: { create: { role: { connect: { name: 'admin' } } } },
      },
    });
    adminToken = jwtService.sign({ sub: admin.id, roles: ['admin'] });

    // Create provider
    const provider = await prisma.user.create({
      data: {
        phone: '+998901111111',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Provider',
        roles: { create: { role: { connect: { name: 'provider' } } } },
        providerProfile: { create: { isVerified: true } },
      },
    });
    providerId = provider.id;
    providerToken = jwtService.sign({ sub: providerId, roles: ['provider'] });

    // Create courier
    const courier = await prisma.user.create({
      data: {
        phone: '+998902222222',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Courier',
        roles: { create: { role: { connect: { name: 'courier' } } } },
        courierProfile: { create: { isVerified: true } },
      },
    });
    courierId = courier.id;
    courierToken = jwtService.sign({ sub: courierId, roles: ['courier'] });

    // Create seller
    const seller = await prisma.user.create({
      data: {
        phone: '+998903333333',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Seller',
        roles: { create: { role: { connect: { name: 'seller' } } } },
        sellerProfile: { create: { shopName: 'Test Shop', shopSlug: 'test-shop', isActive: true, isVerified: true } },
      },
    });
    sellerId = seller.id;
    sellerToken = jwtService.sign({ sub: sellerId, roles: ['seller'] });
  });

  afterAll(async () => {
    await prisma.user.deleteMany({
      where: { phone: { in: ['+998909998877', '+998901111111', '+998902222222', '+998903333333'] } },
    });
    await app.close();
  });

  describe('Payout Account Setup', () => {
    it('should add bank card payout account for provider', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/payouts/account')
        .set('Authorization', `Bearer ${providerToken}`)
        .send({
          type: 'bank_card',
          details: {
            bank: 'UzCard',
            cardNumber: '8600123456789012',
            cardHolder: 'Test Provider',
          },
        })
        .expect(201);

      expect(response.body.id).toBeDefined();
      expect(response.body.type).toBe('bank_card');
      expect(response.body.isDefault).toBe(true);
    });

    it('should add bank account payout account for courier', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/payouts/account')
        .set('Authorization', `Bearer ${courierToken}`)
        .send({
          type: 'bank_account',
          details: {
            bank: 'Kapital Bank',
            accountNumber: '20210000123456789012',
            accountHolder: 'Test Courier',
          },
        })
        .expect(201);

      expect(response.body.type).toBe('bank_account');
    });

    it('should add ewallet payout account for seller', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/payouts/account')
        .set('Authorization', `Bearer ${sellerToken}`)
        .send({
          type: 'ewallet',
          details: {
            ewalletName: 'Payme',
            phone: '+998903333333',
          },
        })
        .expect(201);

      expect(response.body.type).toBe('ewallet');
    });

    it('should list payout accounts', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/account')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
      expect(response.body.length).toBeGreaterThan(0);
    });
  });

  describe('Earnings and Payout Creation', () => {
    let providerOrderId: string;
    let courierOrderId: string;
    let sellerOrderId: string;

    beforeAll(async () => {
      // Create completed orders for each role
      const address = await prisma.address.create({
        data: {
          userId: providerId,
          lat: 41.2995,
          lng: 69.2401,
          addressLine: 'Test Address',
        },
      });

      const service = await prisma.service.create({
        data: {
          serviceTypeId: (await prisma.serviceType.findFirst())!.id,
          name: 'Payout Test Service',
          basePrice: 100000,
          durationMinutes: 60,
        },
      });

      // Provider order
      const providerOrder = await prisma.order.create({
        data: {
          orderNumber: 'GLS-20260712-0001',
          clientId: providerId,
          type: 'service',
          status: 'completed',
          subtotal: 100000,
          discount: 0,
          deliveryFee: 0,
          platformFee: 20000,
          total: 80000,
          paymentStatus: 'paid',
          completedAt: new Date(),
          addressId: address.id,
          providerAssignments: {
            create: { providerId, status: 'accepted', acceptedAt: new Date() },
          },
        },
      });
      providerOrderId = providerOrder.id;

      // Courier order
      const courierOrder = await prisma.order.create({
        data: {
          orderNumber: 'GLS-20260712-0002',
          clientId: providerId,
          type: 'product',
          status: 'completed',
          subtotal: 50000,
          discount: 0,
          deliveryFee: 15000,
          platformFee: 7500,
          total: 57500,
          paymentStatus: 'paid',
          completedAt: new Date(),
          addressId: address.id,
          courierAssignments: {
            create: { courierId, status: 'accepted', acceptedAt: new Date() },
          },
        },
      });
      courierOrderId = courierOrder.id;

      // Seller order
      const category = await prisma.category.findFirst();
      const sellerProfile = await prisma.sellerProfile.findUnique({ where: { userId: sellerId } });
      
      const product = await prisma.product.create({
        data: {
          sellerId: sellerProfile!.id,
          categoryId: category!.id,
          name: 'Payout Test Product',
          slug: 'payout-test-product',
          basePrice: 30000,
          stockQty: 10,
        },
      });

      const sellerOrder = await prisma.order.create({
        data: {
          orderNumber: 'GLS-20260712-0003',
          clientId: providerId,
          type: 'product',
          status: 'completed',
          subtotal: 30000,
          discount: 0,
          deliveryFee: 15000,
          platformFee: 4500,
          total: 40500,
          paymentStatus: 'paid',
          completedAt: new Date(),
          addressId: address.id,
          items: {
            create: { productId: product.id, sellerId: sellerProfile!.id, quantity: 1, unitPrice: 30000, totalPrice: 30000 },
          },
        },
      });
      sellerOrderId = sellerOrder.id;
    });

    it('should calculate provider earnings', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/earnings')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('totalEarnings');
      expect(response.body).toHaveProperty('availableForPayout');
      expect(response.body).toHaveProperty('pendingPayout');
      expect(response.body.totalEarnings).toBeGreaterThan(0);
    });

    it('should calculate courier earnings', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/earnings')
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      expect(response.body.totalEarnings).toBeGreaterThan(0);
    });

    it('should calculate seller earnings', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/earnings')
        .set('Authorization', `Bearer ${sellerToken}`)
        .expect(200);

      expect(response.body.totalEarnings).toBeGreaterThan(0);
    });
  });

  describe('Payout Batch Processing', () => {
    let batchId: string;

    it('should create payout batch for providers (weekly Tuesday)', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/admin/payouts/batch')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          role: 'provider',
          periodStart: new Date('2026-07-08'),
          periodEnd: new Date('2026-07-14'),
        })
        .expect(201);

      expect(response.body.id).toBeDefined();
      expect(response.body.status).toBe('pending');
      batchId = response.body.id;
    });

    it('should process payout batch', async () => {
      const response = await request(app.getHttpServer())
        .post(`/api/v1/admin/payouts/batch/${batchId}/process`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(response.body.status).toBe('processing');
    });

    it('should complete payout batch', async () => {
      // Simulate processing completion
      await prisma.payoutBatch.update({
        where: { id: batchId },
        data: { status: 'completed', processedAt: new Date() },
      });

      const batch = await prisma.payoutBatch.findUnique({ where: { id: batchId } });
      expect(batch!.status).toBe('completed');
    });

    it('should create individual payouts', async () => {
      const payouts = await prisma.payout.findMany({
        where: { payoutBatchId: batchId },
      });

      expect(payouts.length).toBeGreaterThan(0);
for (const payout of payouts) {
        expect(payout.amount).toBeGreaterThan(0);
        
        const amount = Number(payout.amount);
        const commission = Number(payout.commission);
        expect(commission).toBeGreaterThanOrEqual(0);
        expect(Number(payout.netAmount)).toBe(amount - commission);
        expect(payout.status).toBe('completed');
      }
    });
  });

  describe('Payout Schedule Configuration', () => {
    it('should return provider payout schedule', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/schedule')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('schedule');
      expect(response.body).toHaveProperty('minimumAmount');
      expect(response.body.minimumAmount).toBe(100000); // 100,000 UZS for providers
    });

    it('should return courier payout schedule', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/schedule')
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      expect(response.body.minimumAmount).toBe(50000); // 50,000 UZS for couriers
    });

    it('should return seller payout schedule', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts/schedule')
        .set('Authorization', `Bearer ${sellerToken}`)
        .expect(200);

      expect(response.body.minimumAmount).toBe(50000); // 50,000 UZS for sellers
    });
  });

  describe('Payout History', () => {
    it('should list provider payouts', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
      expect(response.body.length).toBeGreaterThan(0);
      
      for (const payout of response.body) {
        expect(payout).toHaveProperty('id');
        expect(payout).toHaveProperty('amount');
        expect(payout).toHaveProperty('netAmount');
        expect(payout).toHaveProperty('status');
        expect(payout).toHaveProperty('periodStart');
        expect(payout).toHaveProperty('periodEnd');
      }
    });

    it('should filter payouts by status', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts?status=completed')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      for (const payout of response.body) {
        expect(payout.status).toBe('completed');
      }
    });

    it('should paginate payouts', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/payouts?page=1&limit=5')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body.length).toBeLessThanOrEqual(5);
    });
  });

  describe('Payout Failure Handling', () => {
    it('should handle failed payout and retry', async () => {
      // Create a failed payout
      const failedPayout = await prisma.payout.create({
        data: {
          providerId,
          amount: 50000,
          commission: 7500,
          netAmount: 42500,
          status: 'failed',
          periodStart: new Date('2026-07-01'),
          periodEnd: new Date('2026-07-07'),
        },
      });

      // Admin retries failed payout
      const response = await request(app.getHttpServer())
        .post(`/api/v1/admin/payouts/${failedPayout.id}/retry`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(response.body.status).toBe('pending');

      // After processing
      await prisma.payout.update({
        where: { id: failedPayout.id },
        data: { status: 'completed', paidAt: new Date() },
      });

      const updated = await prisma.payout.findUnique({ where: { id: failedPayout.id } });
      expect(updated!.status).toBe('completed');
    });
  });
});