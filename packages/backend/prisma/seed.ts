import { PrismaClient } from '@prisma/client';
import * as argon2 from 'argon2';

const prisma = new PrismaClient();

async function main() {
  // Create roles
  const roles = ['client', 'provider', 'courier', 'seller', 'admin', 'super_admin'];
  for (const name of roles) {
    await prisma.role.upsert({
      where: { name },
      update: {},
      create: { name, description: `${name} role` },
    });
  }

  // Create permissions
  const resources = ['user', 'order', 'product', 'service', 'payment', 'chat', 'kyc', 'analytics', 'system'];
  const actions = ['create', 'read', 'update', 'delete', 'manage', 'moderate'];
  for (const resource of resources) {
    for (const action of actions) {
      await prisma.permission.upsert({
        where: { resource_action: { resource, action } },
        update: {},
        create: { resource, action },
      });
    }
  }

  // Create admin user
  const passwordHash = await argon2.hash('Admin123!');
  const admin = await prisma.user.upsert({
    where: { phone: '+998901234567' },
    update: {},
    create: {
      phone: '+998901234567',
      passwordHash,
      fullName: 'Super Admin',
      language: 'uz',
    },
  });

  // Assign super_admin role
  const superAdminRole = await prisma.role.findUnique({ where: { name: 'super_admin' } });
  if (superAdminRole) {
    await prisma.userRole.upsert({
      where: { userId_roleId: { userId: admin.id, roleId: superAdminRole.id } },
      update: {},
      create: { userId: admin.id, roleId: superAdminRole.id },
    });
  }

  console.log('Seed completed');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
