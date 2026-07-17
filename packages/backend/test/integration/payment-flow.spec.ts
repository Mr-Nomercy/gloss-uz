import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { PrismaService } from '../../src/prisma/prisma.service';
import { AppModule } from '../../src/app.module';
import { JwtService } from '@nestjs/jwt';

describe('Payment Flow Integration Tests', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let jwtService: JwtService;

  let clientToken: string;
  let adminToken: string;
  let clientId: string;
  let orderId: string;
  let paymentId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    prisma = moduleFixture.get<PrismaService>(PrismaService);
    jwtService = moduleFixture.get<JwtService>(JwtService);

    // Create test users
    const client = await prisma.user.create({
      data: {
        phone: '+998901112233',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Test Client',
        roles: { create: { role: { connect: { name: 'client' } } } },
      },
    });
    clientId = client.id;
    clientToken = jwtService.sign({ sub: clientId, roles: ['client'] });

    const admin = await prisma.user.create({
      data: {
        phone: '+998909998877',
        passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
        fullName: 'Admin User',
        roles: { create: { role: { connect: { name: 'admin' } } } },
      },
    });
    adminToken = jwtService.sign({ sub: admin.id, roles: ['admin'] });
  });

  afterAll(async () => {
    await prisma.user.deleteMany({
      where: { phone: { in: ['+998901112233', '+998909998877'] } },
    });
    await app.close();
  });

  describe('Click Payment Flow', () => {
    it('should create order and initiate Click payment', async () => {
      const address = await prisma.address.create({
        data: {
          userId: clientId,
          lat: 41.2995,
          lng: 69.2401,
          addressLine: 'Test Address',
        },
      });

      const service = await prisma.service.create({
        data: {
          serviceTypeId: (await prisma.serviceType.findFirst())!.id,
          name: 'Test Service',
          basePrice: 50000,
          durationMinutes: 60,
        },
      });

      const orderResponse = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'service',
          addressId: address.id,
          items: [{ serviceId: service.id, quantity: 1 }],
        })
        .expect(201);

      orderId = orderResponse.body.id;

      const paymentResponse = await request(app.getHttpServer())
        .post('/api/v1/payments/initiate')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          orderId,
          method: 'click',
        })
        .expect(201);

      expect(paymentResponse.body.paymentId).toBeDefined();
      expect(paymentResponse.body.redirectUrl).toContain('click.uz');
      paymentId = paymentResponse.body.paymentId;
    });

    it('should handle Click callback (prepare)', async () => {
      const payment = await prisma.payment.findUnique({ where: { id: paymentId } });
      
      const callbackData = {
        click_trans_id: '123456',
        service_id: '123',
        click_paydoc_id: '789',
        merchant_trans_id: paymentId,
        amount: payment!.amount.toString(),
        action: '0',
        sign_time: new Date().toISOString(),
        sign_string: '',
      };

      // Generate valid signature
      const secretKey = 'test_secret_key';
      const signString = `${callbackData.click_trans_id}${callbackData.service_id}${callbackData.click_paydoc_id}${secretKey}${callbackData.merchant_trans_id}${callbackData.amount}${callbackData.action}${callbackData.sign_time}`;
      const crypto = require('crypto');
      callbackData.sign_string = crypto.createHash('md5').update(signString).digest('hex');

      const response = await request(app.getHttpServer())
        .post('/api/v1/payments/click/callback')
        .send(callbackData)
        .expect(200);

      expect(response.body.error).toBe(0);
    });

    it('should handle Click callback (complete)', async () => {
      const callbackData = {
        click_trans_id: '123456',
        service_id: '123',
        click_paydoc_id: '789',
        merchant_trans_id: paymentId,
        amount: '50000',
        action: '1',
        error: '0',
        sign_time: new Date().toISOString(),
        sign_string: '',
      };

      const secretKey = 'test_secret_key';
      const signString = `${callbackData.click_trans_id}${callbackData.service_id}${callbackData.click_paydoc_id}${secretKey}${callbackData.merchant_trans_id}${callbackData.amount}${callbackData.action}${callbackData.sign_time}`;
      const crypto = require('crypto');
      callbackData.sign_string = crypto.createHash('md5').update(signString).digest('hex');

      const response = await request(app.getHttpServer())
        .post('/api/v1/payments/click/callback')
        .send(callbackData)
        .expect(200);

      expect(response.body.error).toBe(0);

      const payment = await prisma.payment.findUnique({ where: { id: paymentId } });
      expect(payment!.status).toBe('success');
    });

    it('should update order status to confirmed after payment', async () => {
      const order = await prisma.order.findUnique({ where: { id: orderId } });
      expect(order!.paymentStatus).toBe('paid');
      expect(order!.status).toBe('confirmed');
    });
  });

  describe('Payme Payment Flow', () => {
    let paymeOrderId: string;
    let paymePaymentId: string;

    it('should create order and initiate Payme payment', async () => {
      const address = await prisma.address.create({
        data: {
          userId: clientId,
          lat: 41.2995,
          lng: 69.2401,
          addressLine: 'Test Address 2',
        },
      });

      const product = await prisma.product.create({
        data: {
          sellerId: clientId,
          categoryId: (await prisma.category.findFirst())!.id,
          name: 'Test Product',
          slug: 'test-product',
          basePrice: 30000,
          stockQty: 10,
        },
      });

      const orderResponse = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'product',
          addressId: address.id,
          items: [{ productId: product.id, quantity: 1, sellerId: clientId }],
        })
        .expect(201);

      paymeOrderId = orderResponse.body.id;

      const paymentResponse = await request(app.getHttpServer())
        .post('/api/v1/payments/initiate')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          orderId: paymeOrderId,
          method: 'payme',
        })
        .expect(201);

      expect(paymentResponse.body.redirectUrl).toContain('payme.uz');
      paymePaymentId = paymentResponse.body.paymentId;
    });

    it('should handle Payme CheckPerformTransaction', async () => {
      const payment = await prisma.payment.findUnique({ where: { id: paymePaymentId } });
      
      const response = await request(app.getHttpServer())
        .post('/api/v1/payments/payme/callback')
        .set('Authorization', `Basic ${Buffer.from(`Paycom:${process.env.PAYME_SECRET_KEY || 'test_secret'}`).toString('base64')}`)
        .send({
          method: 'CheckPerformTransaction',
          params: {
            account: { order_id: paymePaymentId },
            amount: Number(payment!.amount) * 100,
          },
        })
        .expect(200);

      expect(response.body.result).toBeDefined();
      expect(response.body.result.allow).toBe(true);
    });

    it('should handle Payme CreateTransaction', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/payments/payme/callback')
        .set('Authorization', `Basic ${Buffer.from(`Paycom:${process.env.PAYME_SECRET_KEY || 'test_secret'}`).toString('base64')}`)
        .send({
          method: 'CreateTransaction',
          params: {
            id: 'test-transaction-id',
            account: { order_id: paymePaymentId },
            amount: 5000000,
            time: Date.now(),
          },
        })
        .expect(200);

      expect(response.body.result).toBeDefined();
      expect(response.body.result.state).toBe(1);
    });

    it('should handle Payme PerformTransaction', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/payments/payme/callback')
        .set('Authorization', `Basic ${Buffer.from(`Paycom:${process.env.PAYME_SECRET_KEY || 'test_secret'}`).toString('base64')}`)
        .send({
          method: 'PerformTransaction',
          params: {
            id: 'test-transaction-id',
          },
        })
        .expect(200);

      expect(response.body.result).toBeDefined();
      expect(response.body.result.state).toBe(2);
    });
  });

  describe('Cash Payment Flow', () => {
    it('should handle cash on delivery', async () => {
      const address = await prisma.address.create({
        data: {
          userId: clientId,
          lat: 41.2995,
          lng: 69.2401,
          addressLine: 'Test Address 3',
        },
      });

      const orderResponse = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'product',
          addressId: address.id,
          items: [{ productId: (await prisma.product.findFirst())!.id, quantity: 1, sellerId: clientId }],
        })
        .expect(201);

      const orderId = orderResponse.body.id;

      // Initiate cash payment
      const paymentResponse = await request(app.getHttpServer())
        .post('/api/v1/payments/initiate')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          orderId,
          method: 'cash',
        })
        .expect(201);

      expect(paymentResponse.body.redirectUrl).toBeNull();

      // Simulate courier marking as paid on delivery
      const courier = await prisma.user.create({
        data: {
          phone: '+998901234567',
          passwordHash: '$argon2id$v=19$m=65536,t=3,p=4$test',
          fullName: 'Test Courier',
          roles: { create: { role: { connect: { name: 'courier' } } } },
        },
      });

      const courierToken = jwtService.sign({ sub: courier.id, roles: ['courier'] });

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/accept-courier`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/picked-up`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .post(`/api/v1/orders/${orderId}/courier/delivered`)
        .set('Authorization', `Bearer ${courierToken}`)
        .send({
          deliveredPhoto: 'https://example.com/photo.jpg',
        })
        .expect(200);

      // Mark cash payment as collected
      await request(app.getHttpServer())
        .post(`/api/v1/payments/${paymentResponse.body.paymentId}/complete-delivery`)
        .set('Authorization', `Bearer ${courierToken}`)
        .expect(200);

      const payment = await prisma.payment.findUnique({ where: { id: paymentResponse.body.paymentId } });
      expect(payment!.status).toBe('success');
    });
  });

  describe('Refund Flow', () => {
    it('should process refund for paid order', async () => {
      const order = await prisma.order.findUnique({ where: { id: orderId } });
      const payment = await prisma.payment.findFirst({ where: { orderId: order!.id } });

      const refundResponse = await request(app.getHttpServer())
        .post('/api/v1/payments/refund')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          paymentId: payment!.id,
          amount: Number(payment!.amount),
          reason: 'Customer request',
        })
        .expect(201);

      expect(refundResponse.body.amount).toBe(Number(payment!.amount));

      const refundedPayment = await prisma.payment.findUnique({ where: { id: payment!.id } });
      expect(refundedPayment!.status).toBe('refunded');
    });

    it('should process partial refund', async () => {
      const address = await prisma.address.create({
        data: {
          userId: clientId,
          lat: 41.2995,
          lng: 69.2401,
          addressLine: 'Test Address 4',
        },
      });

      const orderResponse = await request(app.getHttpServer())
        .post('/api/v1/orders')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          type: 'service',
          addressId: address.id,
          items: [{ serviceId: (await prisma.service.findFirst())!.id, quantity: 1 }],
        })
        .expect(201);

      const payment = await prisma.payment.findFirst({ where: { orderId: orderResponse.body.id } });

      const refundResponse = await request(app.getHttpServer())
        .post('/api/v1/payments/refund')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          paymentId: payment!.id,
          amount: Number(payment!.amount) / 2,
          reason: 'Partial refund',
        })
        .expect(201);

      expect(refundResponse.body.amount).toBe(Number(payment!.amount) / 2);

      const refundedPayment = await prisma.payment.findUnique({ where: { id: payment!.id } });
      expect(refundedPayment!.status).toBe('partially_refunded');
    });
  });
});