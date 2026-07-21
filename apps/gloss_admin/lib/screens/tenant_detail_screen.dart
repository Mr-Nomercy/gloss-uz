import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/tenants_provider.dart';
import '../utils/string_utils.dart';
import '../widgets/section_title.dart';

class TenantDetailScreen extends ConsumerStatefulWidget {
  final String tenantId;
  const TenantDetailScreen({super.key, required this.tenantId});

  @override
  ConsumerState<TenantDetailScreen> createState() =>
      _TenantDetailScreenState();
}

class _TenantDetailScreenState extends ConsumerState<TenantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final detail = _mockDetail();

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: GlossAppBar(title: detail.tenant.companyName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlossCard(
              accentColor: theme.green,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        safeFirstChar(detail.tenant.companyName),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: theme.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    detail.tenant.companyName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlossColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail.tenant.phone,
                    style: TextStyle(fontSize: 14, color: theme.hint),
                  ),
                  if (detail.tenant.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      detail.tenant.email!,
                      style: TextStyle(fontSize: 13, color: theme.hint),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlossBadge(
                        label: detail.tenant.isActive ? 'Aktiv' : 'Bloklangan',
                        variant: detail.tenant.isActive
                            ? BadgeVariant.success
                            : BadgeVariant.error,
                      ),
                      const SizedBox(width: 8),
                      GlossBadge(
                        label: detail.tenant.isVerified
                            ? 'Tasdiqlangan'
                            : 'Tekshirilmagan',
                        variant: detail.tenant.isVerified
                            ? BadgeVariant.success
                            : BadgeVariant.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlossStatCard(
                    label: 'Balans',
                    value: formatPrice(detail.balance.toInt()),
                    icon: Icons.account_balance_wallet_rounded,
                    valueFontSize: 13,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlossStatCard(
                    label: 'Umumiy daromad',
                    value: formatPrice(detail.totalEarnings.toInt()),
                    icon: Icons.trending_up_rounded,
                    valueFontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GlossStatCard(
                    label: 'Reyting',
                    value: detail.tenant.rating.toString(),
                    icon: Icons.star_rounded,
                    valueFontSize: 13,
                    color: GlossColors.star,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlossStatCard(
                    label: 'Buyurtmalar',
                    value: '${detail.tenant.totalOrders}',
                    icon: Icons.shopping_bag_rounded,
                    valueFontSize: 13,
                    color: GlossColors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GlossStatCard(
                    label: 'Ishchilar',
                    value: '${detail.tenant.totalWorkers}',
                    icon: Icons.people_rounded,
                    valueFontSize: 13,
                    color: GlossColors.darkGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlossStatCard(
                    label: 'Komissiya',
                    value: '${(detail.tenant.commissionRate * 100).toInt()}%',
                    icon: Icons.percent_rounded,
                    valueFontSize: 13,
                    color: GlossColors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlossSectionTitle(title: 'Ishchilar (${detail.workers.length})'),
            const SizedBox(height: 10),
            if (detail.workers.isEmpty)
              const GlossEmptyState(
                icon: Icons.people_outline_rounded,
                title: "Ishchilar yo'q",
              )
            else
              ...detail.workers.map((w) => _buildWorkerItem(theme, w)),
            const SizedBox(height: 24),
            GlossSectionTitle(title: "So'nggi buyurtmalar"),
            const SizedBox(height: 10),
            if (detail.orders.isEmpty)
              const GlossEmptyState(
                icon: Icons.receipt_long_rounded,
                title: "Buyurtmalar yo'q",
              )
            else
              ...detail.orders.map((o) => _buildOrderItem(theme, o)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GlossButton(
                    label: detail.tenant.isActive
                        ? 'Bloklash'
                        : 'Aktivlashtirish',
                    isOutlined: true,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerItem(GlossTheme theme, TenantWorker worker) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlossCard(
        accentColor: worker.isActive ? theme.green : theme.grayMedium,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: worker.isActive
                    ? Colors.white
                    : theme.grayLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  safeFirstChar(worker.fullName),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: worker.isActive ? theme.green : theme.hint,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.fullName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: GlossColors.text,
                    ),
                  ),
                  Text(
                    worker.phone,
                    style: TextStyle(fontSize: 12, color: theme.hint),
                  ),
                ],
              ),
            ),
            GlossBadge(
              label: worker.isActive ? 'Aktiv' : 'Nofaol',
              variant: worker.isActive
                  ? BadgeVariant.success
                  : BadgeVariant.neutral,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(GlossTheme theme, TenantOrder order) {
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
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: GlossColors.text,
                    ),
                  ),
                  Text(
                    order.createdAt.toString().substring(0, 16),
                    style: TextStyle(fontSize: 12, color: theme.hint),
                  ),
                ],
              ),
            ),
            Text(
              formatPrice(order.amount.toInt()),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.green,
              ),
            ),
            const SizedBox(width: 8),
            GlossBadge.status(order.status),
          ],
        ),
      ),
    );
  }

  TenantDetail _mockDetail() {
    return TenantDetail(
      tenant: const Tenant(
        id: '1',
        companyName: 'Gloss Clean Pro',
        phone: '+998901234567',
        email: 'pro@gloss.uz',
        rating: 4.8,
        totalOrders: 1250,
        totalWorkers: 24,
        commissionRate: 0.15,
        isActive: true,
        isVerified: true,
      ),
      balance: 12500000,
      totalEarnings: 85600000,
      workers: [
        const TenantWorker(
          id: 'w1',
          fullName: 'Alisher Valiyev',
          phone: '+998901110011',
          isActive: true,
        ),
        const TenantWorker(
          id: 'w2',
          fullName: 'Dilshod Karimov',
          phone: '+998901110022',
          isActive: true,
        ),
        const TenantWorker(
          id: 'w3',
          fullName: 'Sarvar Akbarov',
          phone: '+998901110033',
          isActive: false,
        ),
      ],
      orders: [
        TenantOrder(
          id: 'o1',
          orderNumber: 'GL-0042',
          status: 'completed',
          amount: 85000,
          createdAt: _today,
        ),
        TenantOrder(
          id: 'o2',
          orderNumber: 'GL-0038',
          status: 'completed',
          amount: 120000,
          createdAt: _today,
        ),
      ],
    );
  }

  static DateTime get _today => DateTime.now();
}
