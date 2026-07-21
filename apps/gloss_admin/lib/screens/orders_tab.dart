import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});
  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  String _search = '';
  String _typeFilter = 'all';

  static const _statuses = [
    _TabFilter('all', 'Barchasi'),
    _TabFilter('pending', 'Yangi'),
    _TabFilter('in_progress', 'Jarayonda'),
    _TabFilter('completed', 'Yakunlangan'),
    _TabFilter('cancelled', 'Bekor'),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _statuses.length, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<_Order> get _filtered {
    var list = _orders;
    final s = _statuses[_tabCtrl.index].key;
    if (s != 'all') list = list.where((o) => o.status == s).toList();
    if (_typeFilter != 'all') list = list.where((o) => o.type == _typeFilter).toList();
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((o) => o.orderNumber.toLowerCase().contains(q) || o.clientName.toLowerCase().contains(q) || (o.partner?.toLowerCase().contains(q) ?? false)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final filtered = _filtered;

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: TextStyle(fontSize: 13, color: theme.text),
                  decoration: InputDecoration(
                    hintText: 'Raqam, ism...',
                    hintStyle: TextStyle(fontSize: 12, color: theme.hint),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: theme.hint),
                    filled: true, fillColor: const Color(0xFFF8F8F8),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _Chip(label: 'Xizmat', active: _typeFilter == 'Xizmat', onTap: () => setState(() => _typeFilter = _typeFilter == 'Xizmat' ? 'all' : 'Xizmat')),
            const SizedBox(width: 6),
            _Chip(label: 'Mahsulot', active: _typeFilter == 'Mahsulot', onTap: () => setState(() => _typeFilter = _typeFilter == 'Mahsulot' ? 'all' : 'Mahsulot')),
          ]),
        ),
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabCtrl,
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            labelColor: theme.green,
            unselectedLabelColor: theme.hint,
            indicatorColor: theme.green,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: _statuses.map((s) => Tab(text: s.label)).toList(),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const GlossEmptyState(icon: Icons.search_off_rounded, title: 'Buyurtma topilmadi')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _card(context, filtered[i]),
                ),
        ),
      ],
    );
  }

  Widget _card(BuildContext ctx, _Order o) {
    final t = ctx.gloss;
    final svc = o.type == 'Xizmat';
    final late = o.status == 'pending' && o.minutes > 15;
    final stuck = o.status == 'in_progress' && o.minutes > 60;
    final color = svc ? t.green : t.orange;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlossCard(
        accentColor: color,
        padding: EdgeInsets.zero,
        onTap: () => context.push('/orders/${o.id}'),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: color, 
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Icon(svc ? Icons.cleaning_services_rounded : Icons.shopping_bag_rounded, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(o.orderNumber, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.text)),
                    const SizedBox(width: 8),
                    GlossBadge(label: o.type, variant: svc ? BadgeVariant.info : BadgeVariant.warning, fontSize: 10),
                    if (late || stuck) ...[const SizedBox(width: 6), GlossBadge(label: late ? 'Kech' : 'Tiqilgan', variant: BadgeVariant.error, fontSize: 10)],
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.person_outline_rounded, size: 13, color: t.hint), const SizedBox(width: 3),
                    Text(o.clientName, style: TextStyle(fontSize: 12, color: t.hint)),
                    const SizedBox(width: 10),
                    Icon(Icons.access_time_rounded, size: 13, color: late || stuck ? t.red : t.hint), const SizedBox(width: 3),
                    Text('${o.minutes} daq', style: TextStyle(fontSize: 12, color: late || stuck ? t.red : t.hint)),
                  ]),
                ]),
              ),
            ]),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0x1A000000))),
            ),
            child: Row(children: [
              Expanded(
                child: o.partner != null
                    ? Row(children: [Icon(svc ? Icons.business_rounded : Icons.delivery_dining_rounded, size: 13, color: color), const SizedBox(width: 4), Flexible(child: Text(o.partner!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.text), overflow: TextOverflow.ellipsis))])
                    : Text('Biriktirilmagan', style: TextStyle(fontSize: 12, color: t.red, fontWeight: FontWeight.w500)),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(o.price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 3),
                GlossBadge.status(_label(o.status)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  String _label(String s) {
    switch (s) {
      case 'pending': return 'Yangi';
      case 'in_progress': return 'Jarayonda';
      case 'completed': return 'Yakunlangan';
      case 'cancelled': return 'Bekor';
      default: return s;
    }
  }

  static final _orders = [
    _Order('1', 'GL-0042', 'Aziz Karimov', 'Xizmat', 'Gloss Clean Pro', 'completed', '85 000 so\'m', 180),
    _Order('2', 'GL-0041', 'Dilnoza Rahimova', 'Xizmat', 'Clean Service', 'in_progress', '120 000 so\'m', 45),
    _Order('3', 'GL-0040', 'Jamshid Aliyev', 'Mahsulot', 'Botir Ergashev', 'pending', '45 000 so\'m', 22),
    _Order('4', 'GL-0039', 'Madina Umarova', 'Xizmat', null, 'pending', '65 000 so\'m', 5),
    _Order('5', 'GL-0038', 'Sherzod Yusupov', 'Mahsulot', 'Anvar Soliyev', 'completed', '95 000 so\'m', 320),
    _Order('6', 'GL-0037', 'Nodira Qodirova', 'Xizmat', 'Mega Clean', 'in_progress', '78 000 so\'m', 75),
    _Order('7', 'GL-0036', 'Bobur Toshmatov', 'Mahsulot', null, 'pending', '32 000 so\'m', 18),
    _Order('8', 'GL-0035', 'Sevara Aliyeva', 'Xizmat', 'Gloss Clean Pro', 'cancelled', '55 000 so\'m', 90),
  ];
}

class _Order {
  final String id, orderNumber, clientName, type, status, price;
  final String? partner;
  final int minutes;
  const _Order(this.id, this.orderNumber, this.clientName, this.type, this.partner, this.status, this.price, this.minutes);
}

class _TabFilter {
  final String key, label;
  const _TabFilter(this.key, this.label);
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.gloss;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: active ? t.green : Colors.transparent, borderRadius: BorderRadius.circular(8), border: Border.all(color: active ? t.green : t.border)),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? Colors.white : t.hint)),
      ),
    );
  }
}
