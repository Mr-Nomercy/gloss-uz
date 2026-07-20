import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<_Tx> _transactions = const [
    _Tx('15 Iyul 2026', 'Buyurtma #ORD-005', 100000, true),
    _Tx('14 Iyul 2026', 'Buyurtma #ORD-003', 150000, true),
    _Tx('12 Iyul 2026', 'Pul chiqarish', -500000, false),
    _Tx('10 Iyul 2026', 'Buyurtma #ORD-002', 80000, true),
    _Tx('08 Iyul 2026', 'Buyurtma #ORD-001', 120000, true),
  ];

  bool get _isEmpty => _transactions.isEmpty;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Hamyon',
          style: TextStyle(color: theme.text, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.text, size: 18),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.green,
        child: _isLoading
            ? ListView(
                children: const [
                  SizedBox(height: 200),
                  GlossLoadingView(message: 'Yuklanmoqda...'),
                ],
              )
            : _hasError
                ? ListView(
                    children: [
                      const SizedBox(height: 200),
                      GlossErrorView.connection(),
                    ],
                  )
                : _isEmpty
                    ? ListView(
                        children: [
                          _buildBalanceHeader(theme, context),
                          const SizedBox(height: 24),
                          const GlossEmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: "Tranzaksiyalar yo'q",
                            subtitle:
                                "Buyurtmalar qabul qilganda bu yerda ko'rinadi",
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildBalanceHeader(theme, context),
                          const SizedBox(height: 12),
                          _buildMinAmountHint(theme),
                          const SizedBox(height: 20),
                          _buildTransactionHistory(theme),
                          const SizedBox(height: 16),
                        ],
                      ),
      ),
    );
  }

  Widget _buildBalanceHeader(GlossTheme theme, BuildContext context) {
    return GlossBalanceCard(
      title: 'Joriy balans',
      balance: "2 450 000 so'm",
      actionLabel: 'Pul chiqarish',
      onAction: () {
        GlossSnackBar.showSuccess(context, "Pul chiqarish so'rovi yuborildi");
      },
    );
  }

  Widget _buildMinAmountHint(GlossTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        "Minimal summa: 100 000 so'm",
        style: TextStyle(fontSize: 13, color: theme.hint),
      ),
    );
  }

  Widget _buildTransactionHistory(GlossTheme theme) {
    final grouped = <String, List<_Tx>>{};
    for (final t in _transactions) {
      grouped.putIfAbsent(t.date, () => []).add(t);
    }
    final dates = grouped.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Tranzaksiyalar tarixi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
        ),
        for (int di = 0; di < dates.length; di++)
          ...grouped[dates[di]]!.asMap().entries.map((entry) {
            final ti = entry.key;
            final t = entry.value;
            final isFirstInGroup = ti == 0;
            final globalIndex = _transactions.indexOf(t);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isFirstInGroup) ...[
                    _DateDivider(theme: theme, date: t.date),
                    const SizedBox(height: 8),
                  ],
                  _TxSlideItem(theme: theme, tx: t, index: globalIndex),
                ],
              ),
            );
          }),
      ],
    );
  }
}

class _DateDivider extends StatelessWidget {
  final GlossTheme theme;
  final String date;

  const _DateDivider({required this.theme, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.divider)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              date,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: theme.hint),
            ),
          ),
          Expanded(child: Divider(color: theme.divider)),
        ],
      ),
    );
  }
}

class _TxSlideItem extends StatefulWidget {
  final GlossTheme theme;
  final _Tx tx;
  final int index;

  const _TxSlideItem({required this.theme, required this.tx, required this.index});

  @override
  State<_TxSlideItem> createState() => _TxSlideItemState();
}

class _TxSlideItemState extends State<_TxSlideItem> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    ));
    Future.delayed(Duration(milliseconds: 150 + widget.index * 80), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tx;
    final theme = widget.theme;
    final isIncome = t.positive;
    final iconBg = isIncome ? theme.greenBgLight : theme.red.withValues(alpha: 0.10);
    final iconColor = isIncome ? theme.green : theme.red;
    final arrow = isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    final amountColor = isIncome ? theme.greenText : theme.red;
    final sign = isIncome ? '+' : '';

    return SlideTransition(
      position: _slide,
      child: GlossCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(arrow, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t.desc,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.text),
              ),
            ),
            Text(
              '$sign${_fmtAmount(t.amount.abs())}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _fmtAmount(int value) {
  final str = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
    buf.write(str[i]);
  }
  return "${buf.toString()} so'm";
}

class _Tx {
  final String date;
  final String desc;
  final int amount;
  final bool positive;

  const _Tx(this.date, this.desc, this.amount, this.positive);
}
