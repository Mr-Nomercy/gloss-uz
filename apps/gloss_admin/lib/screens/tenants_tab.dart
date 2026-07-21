import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/tenants_provider.dart';
import '../utils/string_utils.dart';

class TenantsTab extends StatefulWidget {
  const TenantsTab({super.key});

  @override
  State<TenantsTab> createState() => _TenantsTabState();
}

class _TenantsTabState extends State<TenantsTab> {
  String _search = '';

  List<Tenant> get _filtered {
    if (_search.isEmpty) return _mockTenants;
    final q = _search.toLowerCase();
    return _mockTenants.where((t) {
      return t.companyName.toLowerCase().contains(q) ||
          t.phone.contains(q) ||
          (t.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final filtered = _filtered;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: SizedBox(
            height: 40,
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: TextStyle(fontSize: 13, color: theme.text),
              decoration: InputDecoration(
                hintText: 'Provayder qidirish...',
                hintStyle: TextStyle(fontSize: 12, color: theme.hint),
                prefixIcon: Icon(Icons.search_rounded, size: 18, color: theme.hint),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {},
            color: theme.green,
            child: filtered.isEmpty
                ? ListView(children: const [GlossEmptyState(icon: Icons.business_outlined, title: 'Provayder topilmadi')])
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _buildCard(theme, filtered[i]),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(GlossTheme theme, Tenant tenant) {
    final color = tenant.isActive ? (tenant.isVerified ? theme.green : theme.orange) : theme.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlossCard(
        accentColor: color,
        padding: const EdgeInsets.all(14),
        onTap: () => context.push('/tenants/${tenant.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]),
                  child: Center(child: Text(safeFirstChar(tenant.companyName), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tenant.companyName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: GlossColors.text)),
                      const SizedBox(height: 2),
                      Text(tenant.phone, style: TextStyle(fontSize: 13, color: theme.hint)),
                    ],
                  ),
                ),
                GlossBadge(
                  label: tenant.isActive ? (tenant.isVerified ? 'Aktiv' : 'Tekshirilmagan') : 'Bloklangan',
                  variant: tenant.isActive ? (tenant.isVerified ? BadgeVariant.success : BadgeVariant.warning) : BadgeVariant.error,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x1A000000))),
              ),
              child: Row(
                children: [
                  _stat(Icons.shopping_bag_rounded, '${tenant.totalOrders}', 'Buyurtmalar', theme),
                  _divider(theme),
                  _stat(Icons.star_rounded, tenant.rating.toString(), 'Reyting', theme, valueColor: theme.star),
                  _divider(theme),
                  _stat(Icons.people_rounded, '${tenant.totalWorkers}', 'Ishchilar', theme),
                  _divider(theme),
                  _stat(Icons.percent_rounded, '${(tenant.commissionRate * 100).toInt()}%', 'Komissiya', theme, valueColor: theme.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label, GlossTheme theme, {Color? valueColor}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: valueColor ?? theme.hint),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? theme.text)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: theme.hint)),
        ],
      ),
    );
  }

  Widget _divider(GlossTheme theme) {
    return Container(width: 1, height: 36, color: theme.divider);
  }

  static final _mockTenants = [
    const Tenant(id: '1', companyName: 'Gloss Clean Pro', phone: '+998901234567', email: 'pro@gloss.uz', rating: 4.8, totalOrders: 1250, totalWorkers: 24, commissionRate: 0.15, isActive: true, isVerified: true),
    const Tenant(id: '2', companyName: 'Clean Service Tashkent', phone: '+998931112233', email: 'info@cleanservice.uz', rating: 4.5, totalOrders: 860, totalWorkers: 18, commissionRate: 0.12, isActive: true, isVerified: true),
    const Tenant(id: '3', companyName: 'Mega Clean Group', phone: '+998945556677', rating: 4.2, totalOrders: 430, totalWorkers: 10, commissionRate: 0.15, isActive: true, isVerified: false),
    const Tenant(id: '4', companyName: 'Fast Cleaning', phone: '+998971234567', email: 'fast@clean.uz', rating: 3.9, totalOrders: 210, totalWorkers: 6, commissionRate: 0.10, isActive: false, isVerified: false),
  ];
}
