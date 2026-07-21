import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/users_provider.dart';
import '../utils/string_utils.dart';
import '../widgets/section_title.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  final String userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  ConsumerState<UserDetailScreen> createState() =>
      _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  static final _mockDetail = UserDetail(
    user: const AppUser(
      id: '1',
      fullName: 'Aziz Karimov',
      phone: '+998901234567',
      email: 'aziz@mail.uz',
      roles: ['client'],
      isBlocked: false,
      totalOrders: 42,
      totalSpent: 3250000,
    ),
    recentOrders: [
      {'orderNumber': 'GL-0042', 'total': 85000, 'status': 'completed', 'date': '2026-07-20'},
      {'orderNumber': 'GL-0035', 'total': 120000, 'status': 'completed', 'date': '2026-07-18'},
      {'orderNumber': 'GL-0028', 'total': 65000, 'status': 'cancelled', 'date': '2026-07-15'},
    ],
    addresses: [
      {'addressLine': 'Toshkent, Yunusobod tumani, 12-mavze, 45-uy', 'isDefault': true},
      {'addressLine': 'Toshkent, Mirzo Ulug\'bek tumani, 8-mavze, 12-uy', 'isDefault': false},
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final user = _mockDetail.user;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: GlossAppBar(title: user.fullName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlossCard(
              accentColor: user.isBlocked ? theme.red : (user.roles.contains('provider') ? theme.green : (user.roles.contains('courier') ? theme.orange : GlossColors.catBlue)),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: user.isBlocked ? theme.red : (user.roles.contains('provider') ? theme.green : (user.roles.contains('courier') ? theme.orange : GlossColors.catBlue)),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: (user.isBlocked ? theme.red : (user.roles.contains('provider') ? theme.green : (user.roles.contains('courier') ? theme.orange : GlossColors.catBlue))).withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Center(
                      child: Text(
                        safeFirstChar(user.fullName),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlossColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: TextStyle(fontSize: 14, color: theme.hint),
                  ),
                  if (user.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.email!,
                      style: TextStyle(fontSize: 13, color: theme.hint),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlossBadge(label: user.roleLabel, variant: BadgeVariant.neutral),
                      if (user.isBlocked) ...[
                        const SizedBox(width: 8),
                        GlossBadge(
                          label: 'Bloklangan',
                          variant: BadgeVariant.error,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (user.roles.contains('client')) ...[
              Row(
                children: [
                  Expanded(
                    child: GlossStatCard(
                      label: 'Buyurtmalar',
                      value: '${user.totalOrders}',
                      icon: Icons.shopping_bag_rounded,
                      valueFontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlossStatCard(
                      label: 'Jami sarflangan',
                      value: formatPrice(user.totalSpent.toInt()),
                      icon: Icons.account_balance_wallet_rounded,
                      valueFontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GlossSectionTitle(title: "So'nggi buyurtmalar"),
              const SizedBox(height: 10),
              ..._mockDetail.recentOrders.map((o) => _buildOrderItem(theme, o)),
              const SizedBox(height: 24),
              GlossSectionTitle(title: 'Manzillar'),
              const SizedBox(height: 10),
              ..._mockDetail.addresses.map((a) => _buildAddressItem(theme, a)),
            ],
            if (user.roles.contains('courier') || user.roles.contains('provider'))
              Row(
                children: [
                  Expanded(
                    child: GlossStatCard(
                      label: 'Buyurtmalar',
                      value: '${user.totalOrders}',
                      icon: Icons.shopping_bag_rounded,
                      valueFontSize: 14,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            GlossButton(
              label: user.isBlocked ? 'Blokdan chiqarish' : 'Bloklash',
              isOutlined: !user.isBlocked,
              onPressed: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(GlossTheme theme, Map<String, dynamic> order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlossCard(
        accentColor: theme.green,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['orderNumber'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: GlossColors.text,
                    ),
                  ),
                  Text(
                    order['date'] as String,
                    style: TextStyle(fontSize: 12, color: theme.hint),
                  ),
                ],
              ),
            ),
            Text(
              formatPrice((order['total'] as num).toInt()),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.green,
              ),
            ),
            const SizedBox(width: 8),
            GlossBadge.status(order['status'] as String),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressItem(GlossTheme theme, Map<String, dynamic> address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlossCard(
        accentColor: theme.orange,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: theme.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                address['addressLine'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: GlossColors.text,
                ),
              ),
            ),
            if (address['isDefault'] == true)
              GlossBadge(
                label: 'Asosiy',
                variant: BadgeVariant.success,
                fontSize: 10,
              ),
          ],
        ),
      ),
    );
  }
}
