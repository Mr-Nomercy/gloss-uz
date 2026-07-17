import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function safeDelete(model: any, args?: any) {
  try {
    if (args) {
      await model.deleteMany(args);
    } else {
      await model.deleteMany({});
    }
  } catch (e: any) {
    // Table might not exist in test database
    if (!e.message?.includes('does not exist')) {
      console.warn(`Cleanup warning for ${model.name}:`, e.message);
    }
  }
}

beforeAll(async () => {
  await prisma.$connect();
  
  // Clean test database
  await safeDelete(prisma.message, { where: { fromUserId: { not: 'system' } } });
  await safeDelete(prisma.chatParticipant);
  await safeDelete(prisma.chat);
  await safeDelete(prisma.tracking);
  await safeDelete(prisma.locationPoint);
  await safeDelete(prisma.courierAssignmentItem);
  await safeDelete(prisma.courierAssignment);
  await safeDelete(prisma.providerAssignment);
  await safeDelete(prisma.orderStatusHistory);
  await safeDelete(prisma.orderItem);
  await safeDelete(prisma.orderPromoCode);
  await safeDelete(prisma.payment);
  await safeDelete(prisma.refund);
  await safeDelete(prisma.order);
  await safeDelete(prisma.cartItem);
  await safeDelete(prisma.cart);
  await safeDelete(prisma.notification);
  await safeDelete(prisma.dispute);
  await safeDelete(prisma.payout);
  await safeDelete(prisma.payoutBatch);
  await safeDelete(prisma.insuranceClaim);
  await safeDelete(prisma.review);
  await safeDelete(prisma.auditLog);
  
  // Keep users, addresses, products, services for test data
});

afterAll(async () => {
  await prisma.$disconnect();
});

export { prisma };