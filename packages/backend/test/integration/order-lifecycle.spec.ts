import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../../src/app.module';
import { PrismaService } from '../../src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { prisma } from './setup';
import { Role } from '@prisma/client';

describe('Order Lifecycle Integration Tests', () => {
  let app: INestApplication;
  let prismaService: PrismaService;
  let jwtService: JwtService;
  
  let clientToken: string;
  let providerToken: string;
  let courierToken: string;
  let adminToken: string;
  
  let clientId: string;
  let providerId: string;
  let courierId: string;
  let adminId: string;
  
  let addressId: string;
  let serviceId: string;
  let productId: string;
  let sellerId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    prismaService = moduleFixture.get<PrismaService>(PrismaService);
    jwtService = moduleFixture.get<JwtService>(JwtService);

    // Create test users
    const client = await prisma.user.create({
      data: {
        phone: '+998901111111',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Client',
        roles: { create: { role: { connect: { name: 'client' } } } },
      },
      include: { roles: { include: { role: true } } },
    });
    clientId = client.id;
    clientToken = jwtService.sign({ sub: clientId, roles: ['client'] });

    const provider = await prisma.user.create({
      data: {
        phone: '+998902222222',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Provider',
        roles: { create: { role: { connect: { name: 'provider' } } } },
      },
      include: { roles: { include: { role: true } } },
    });
    providerId = provider.id;
    providerToken = jwtService.sign({ sub: providerId, roles: ['provider'] });

    const courier = await prisma.user.create({
      data: {
        phone: '+998903333333',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Courier',
        roles: { create: { role: { connect: { name: 'courier' } } } },
      },
      include: { roles: { include: { role: true } } },
    });
    courierId = courier.id;
    courierToken = jwtService.sign({ sub: courierId, roles: ['courier'] });

    const admin = await prisma.user.create({
      data: {
        phone: '+998904444444',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Admin',
        roles: { create: { role: { connect: { name: 'admin' } } } },
      },
      include: { roles: { include: { role: true } } },
    });
    adminId = admin.id;
    adminToken = jwtService.sign({ sub: adminId, roles: ['admin'] });

    // Create address
    const address = await prisma.address.create({
      data: {
        userId: clientId,
        lat: 41.2995,
        lng: 69.2401,
        addressLine: 'Test Address, Tashkent',
        isDefault: true,
      },
    });
    addressId = address.id;

    // Create service type and service
    const serviceType = await prisma.serviceType.create({
      data: {
        code: 'test_cleaning',
        name: 'Test Cleaning',
        nameRu: 'Тестовая уборка',
        nameEn: 'Test Cleaning',
        isActive: true,
      },
    });

    const service = await prisma.service.create({
      data: {
        serviceTypeId: serviceType.id,
        name: 'Standard Cleaning',
        nameRu: 'Стандартная уборка',
        nameEn: 'Standard Cleaning',
        durationMinutes: 120,
        basePrice: 50000,
        isActive: true,
      },
    });
    serviceId = service.id;

    // Create seller and product
    const seller = await prisma.user.create({
      data: {
        phone: '+998905555555',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Seller',
        roles: { create: { role: { connect: { name: 'seller' } } } },
      },
    });
    sellerId = seller.id;

    const sellerProfile = await prisma.sellerProfile.create({
      data: {
        userId: sellerId,
        shopName: 'Test Shop',
        shopSlug: 'test-shop',
        isActive: true,
        isVerified: true,
      },
    });

    const category = await prisma.category.create({
      data: {
        name: 'Test Category',
        slug: 'test-category',
        isActive: true,
      },
    });

    const product = await prisma.product.create({
      data: {
        sellerId: sellerProfile.id,
        categoryId: category.id,
        name: 'Test Product',
        nameRu: 'Тестовый товар',
        nameEn: 'Test Product',
        slug: 'test-product',
        basePrice: 25000,
        stockQty: 100,
        isActive: true,
        status: 'approved',
      },
    });
    productId = product.id;

    // Create provider profile
    await prisma.providerProfile.create({
      data: {
        userId: providerId,
        isAvailable: true,
        isVerified: true,
        serviceRadiusKm: 10,
        currentLat: 41.2995,
        currentLng: 69.2401,
        lastLocationAt: new Date(),
      },
    });

    // Create courier profile
    await prisma.courierProfile.create({
      data: {
        userId: courierId,
        isOnline: true,
        isAvailable: true,
        isVerified: true,
        currentLat: 41.2995,
        currentLng: 69.2401,
        lastLocationAt: new Date(),
        vehicleType: 'bike',
      },
    });
  });

  afterAll(async () => {
    await app.close();
  });

  describe('Service Order Lifecycle', () => {
    let orderId: string;

    it('should create a service order', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'service',
          addressId,
          items: [
            {
              serviceId,
              quantity: 1,
            },
          ],
        })
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body.type).toBe('service');
      expect(response.body.status).toBe('pending');
      expect(response.body.clientId).toBe(clientId);
      orderId = response.body.id;
    });

    it('should auto-assign provider', async () => {
      // Wait for assignment
      await new Promise(resolve => setTimeout(resolve, 1000));

      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: { providerAssignments: true },
      });

      expect(order).toBeDefined();
      expect(order!.providerAssignments.length).toBeGreaterThan(0);
      expect(order!.providerAssignments[0].status).toBe('pending');
    });

    it('should allow provider to accept order', async () => {
      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: { providerAssignments: true },
      });
      const assignment = order!.providerAssignments[0];

      const response = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/accept-provider`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body.status).toBe('accepted');
    });

    it('should update status to in_progress when provider starts', async () => {
      const response = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/provider/start`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body.toStatus).toBe('in_progress');
    });

    it('should complete work by provider', async () => {
      const response = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/provider/complete`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body.toStatus).toBe('completed');
    });

    it('should mark order as completed', async () => {
      const order = await prisma.order.findUnique({
        where: { id: orderId },
      });
      expect(order!.status).toBe('completed');
      expect(order!.completedAt).toBeDefined();
    });
  });

  describe('Product Order Lifecycle', () => {
    let orderId: string;

    it('should create a product order', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'product',
          addressId,
          items: [
            {
              productId,
              quantity: 2,
              sellerId: sellerId,
            },
          ],
        })
        .expect(201);

      expect(response.body.type).toBe('product');
      orderId = response.body.id;
    });

    it('should auto-assign courier', async () => {
      await new Promise(resolve => setTimeout(resolve, 1000));

      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: { courierAssignments: true },
      });

      expect(order!.courierAssignments.length).toBeGreaterThan(0);
    });

    it('should allow courier to accept delivery', async () => {
      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: { courierAssignments: true },
      });
      const assignment = order!.courierAssignments[0];

      const response = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/accept-courier`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      expect(response.body.status).toBe('accepted');
    });

    it('should progress through delivery statuses', async () => {
      // En route to pickup
      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/en-route-to-pickup`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      // Picked up
      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/picked-up`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      // En route to delivery
      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/en-route-to-delivery`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      // Delivered with proof
      const response = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/delivered`)
        .set('Authorization', `Bearer ${courierToken}`)
        .send({
          deliveredPhoto: 'https://example.com/photo.jpg',
          clientSignature: 'signature-data',
        })
        .expect(200);

      expect(response.body.toStatus).toBe('delivered');
    });

    it('should complete order after delivery', async () => {
      // For cash on delivery, mark as paid
      const payment = await prisma.payment.findFirst({
        where: { orderId },
      });

      if (payment) {
        await request(app.getHttpServer())
          .post(`/api/v1/payments/${payment.id}/complete-delivery`)
          .set('Authorization', `Bearer ${courierToken}`)
          .expect(200);
      }

      const order = await prisma.order.findUnique({
        where: { id: orderId },
      });

      expect(order!.status).toBe('completed');
    });
  });

  describe('Mixed Order Lifecycle', () => {
    let orderId: string;

    it('should create a mixed order (service + product)', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'mixed',
          addressId,
          items: [
            {
              serviceId,
              quantity: 1,
            },
            {
              productId,
              quantity: 1,
              sellerId,
            },
          ],
        })
        .expect(201);

      expect(response.body.type).toBe('mixed');
      orderId = response.body.id;
    });

    it('should assign single courier for mixed order', async () => {
      await new Promise(resolve => setTimeout(resolve, 1000));

      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: { courierAssignments: true },
      });

      expect(order!.courierAssignments.length).toBe(1);
      expect(order!.courierAssignments[0].isPrimary).toBe(true);
    });

    it('should track mixed order completion', async () => {
      // Provider completes service
      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/provider/start`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/provider/complete`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      // Courier delivers product
      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/accept-courier`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/en-route-to-pickup`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/picked-up`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/en-route-to-delivery`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/delivered`)
        .set('Authorization', `Bearer ${courierToken}`)
        .send({
          deliveredPhoto: 'https://example.com/photo.jpg',
          clientSignature: 'signature-data',
        })
        .expect(200);

      const order = await prisma.order.findUnique({
        where: { id: orderId },
      });

      expect(order!.status).toBe('completed');
    });
  });

  describe('Order Cancellation Flow', () => {
    it('should cancel order within 5 minutes for free', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'service',
          addressId,
          items: [{ serviceId, quantity: 1 }],
        })
        .expect(201);

      const orderId = response.body.id;

      const cancelResponse = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/cancel`)
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ reason: 'Changed mind' })
        .expect(200);

      expect(cancelResponse.body.cancellationFee).toBe(0);
      expect(cancelResponse.body.feeReason).toBe('free_within_5min');
    });

    it('should apply fee after provider accepted', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'service',
          addressId,
          items: [{ serviceId, quantity: 1 }],
        })
        .expect(201);

      const orderId = response.body.id;

      // Wait for provider assignment and acceptance
      await new Promise(resolve => setTimeout(resolve, 1000));

      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: { providerAssignments: true },
      });

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/accept-provider`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      const cancelResponse = await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/cancel`)
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ reason: 'No longer needed' })
        .expect(200);

      expect(cancelResponse.body.cancellationFee).toBe(15000);
      expect(cancelResponse.body.feeReason).toBe('provider_accepted_penalty_15k');
    });
  });
});