import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = true;
  bool _hasNewOffer = true;
  int _countdown = 15;
  Timer? _offerTimer;

  final String _userName = 'Jasur';

  @override
  void initState() {
    super.initState();
    _startOfferTimer();
  }

  void _startOfferTimer() {
    _offerTimer?.cancel();
    _offerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _hasNewOffer = false);
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _offerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 18, color: theme.text),
            children: [
              TextSpan(
                text: 'Assalom, ',
                style: TextStyle(color: theme.hint, fontWeight: FontWeight.normal, fontSize: 16),
              ),
              TextSpan(
                text: _userName,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ],
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: theme.text),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOnlineToggle(theme),
              const SizedBox(height: 16),
              _buildBalanceCard(theme),
              const SizedBox(height: 16),
              if (_isOnline && _hasNewOffer) ...[
                _buildNewOfferCard(theme),
                const SizedBox(height: 16),
              ],
              _buildQuickActions(theme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineToggle(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isOnline ? theme.greenBgLight : theme.red.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isOnline ? Icons.check_circle : Icons.cancel,
              color: _isOnline ? theme.green : theme.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline ? "Buyurtmalarni qabul qilyapsiz" : "Yangi buyurtmalar kelmaydi",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isOnline ? theme.green : theme.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isOnline ? "Online rejimdasiz" : "Offline rejim",
                  style: TextStyle(fontSize: 12, color: theme.hint),
                ),
              ],
            ),
          ),
          Switch(
            value: _isOnline,
            activeTrackColor: theme.green,
            onChanged: (v) => setState(() => _isOnline = v),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(GlossTheme theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.green, theme.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: Colors.white.withAlpha(200), size: 20),
              const SizedBox(width: 8),
              Text(
                'Mavjud balans',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "2 450 000 so'm",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () => context.push('/wallet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: theme.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                elevation: 0,
              ),
              child: const Text('Pul chiqarish'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewOfferCard(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.orangeBgLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: theme.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${_countdown}s',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Yangi',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.cleaning_services_rounded, color: theme.green, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Uy tozalash',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: theme.hint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Mirzo Ulug'bek tumani, Mustaqillik 45",
                            style: TextStyle(fontSize: 12, color: theme.hint),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "120 000 so'm",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.greenText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _hasNewOffer = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Buyurtma qabul qilindi'),
                          backgroundColor: Color(0xFF00AA13),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      elevation: 0,
                    ),
                    child: const Text('Qabul qilish'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _hasNewOffer = false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.red,
                      side: BorderSide(color: theme.red.withAlpha(75)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Rad etish'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(GlossTheme theme) {
    final actions = [
      {'icon': Icons.receipt_long_outlined, 'label': 'Buyurtmalar', 'route': '/orders'},
      {'icon': Icons.schedule_outlined, 'label': 'Vaqtlarim', 'route': '/availability'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Statistika', 'route': '/stats'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': 'Hamyon', 'route': '/wallet'},
      {'icon': Icons.person_outline, 'label': 'Profil', 'route': '/profile'},
      {'icon': Icons.help_outline, 'label': 'Yordam', 'route': '/support'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        return GlossCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          onTap: () => context.push(item['route'] as String),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: theme.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.text,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: theme.hint, size: 20),
            ],
          ),
        );
      },
    );
  }
}
