import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with TickerProviderStateMixin {
  final List<bool> _expanded = [false, false, false, false];
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;

  final List<Map<String, String>> _faqItems = const [
    {
      'question': 'Qanday buyurtma qabul qilaman?',
      'answer':
          'Yangi buyurtmalar sizning asosiy ekranda "Yangi takliflar" bo\'limida paydo bo\'ladi. Online rejimda bo\'lganingizda ularni ko\'rishingiz va 15 soniya ichida qabul qilishingiz yoki rad etishingiz mumkin. Qabul qilgandan so\'ng buyurtma tarixi bo\'limida ko\'rinadi.',
    },
    {
      'question': "To'lov qachon keladi?",
      'answer':
          'To\'lovlar buyurtma tugatilgandan so\'ng 24-48 soat ichida hamyoningizga tushadi. Siz to\'plangan balansni istalgan vaqtda plastik kartangizga yechib olishingiz mumkin. Minimal yechish summasi 100 000 so\'m.',
    },
    {
      'question': 'Vaqtimni qanday o\'zgartiraman?',
      'answer':
          '"Vaqtlarim" bo\'limiga o\'ting. U yerda haftaning har bir kuni uchun ish vaqtingizni sozlashingiz mumkin. Har bir kun uchun alohida boshlanish va tugash vaqtini belgilang. O\'zgarishlarni "Saqlash" tugmasi orqali tasdiqlang.',
    },
    {
      'question': 'Hisobimni o\'chirish',
      'answer':
          'Hisobingizni o\'chirish uchun qo\'llab-quvvatlash xizmatiga murojaat qiling. Biz sizning so\'rovingizni ko\'rib chiqamiz va 3 ish kuni ichida javob beramiz. Hisob o\'chirilganda barcha ma\'lumotlaringiz o\'chiriladi.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
        title: Text(
          'Yordam',
          style: TextStyle(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: theme.text, size: 18),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StaggeredItem(
                      index: 0,
                      controller: _fadeController,
                      child: _buildFaqSection(theme),
                    ),
                    const SizedBox(height: 16),
                    _StaggeredItem(
                      index: 1,
                      controller: _fadeController,
                      child: _buildContactCard(theme),
                    ),
                    const SizedBox(height: 16),
                    _StaggeredItem(
                      index: 2,
                      controller: _fadeController,
                      child: _buildMessageButton(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFaqSection(GlossTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Ko'p beriladigan savollar",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.text,
            ),
          ),
        ),
        ..._faqItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _FaqAccordionItem(
            question: item['question']!,
            answer: item['answer']!,
            isExpanded: _expanded[index],
            onTap: () => setState(() => _expanded[index] = !_expanded[index]),
            theme: theme,
            index: index,
          );
        }),
      ],
    );
  }

  Widget _buildContactCard(GlossTheme theme) {
    return _TapCard(
      child: GlossCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.headset_mic_rounded, color: theme.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Bog'lanish",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _contactRow(Icons.phone_outlined, '+998 71 200 00 01', theme),
            const SizedBox(height: 12),
            _contactRow(Icons.email_outlined, 'support@gloss.com.uz', theme),
            const SizedBox(height: 12),
            _contactRow(Icons.access_time, 'Ish vaqti: 09:00-21:00', theme),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(IconData icon, String text, GlossTheme theme) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.greenBgLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.green, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: TextStyle(fontSize: 14, color: theme.text)),
        ),
      ],
    );
  }

  Widget _buildMessageButton(BuildContext context) {
    return _TapButton(
      onTap: () {
        GlossSnackBar.showSuccess(
            context, 'Xabar yuborish funksiyasi tez orada ishga tushadi');
      },
      builder: (scale) {
        return AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          child: const GlossButton(
            label: 'Xabar yuborish',
            icon: Icons.chat_outlined,
            onPressed: null,
          ),
        );
      },
    );
  }
}

class _FaqAccordionItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;
  final GlossTheme theme;
  final int index;

  const _FaqAccordionItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
    required this.theme,
    required this.index,
  });

  @override
  State<_FaqAccordionItem> createState() => _FaqAccordionItemState();
}

class _FaqAccordionItemState extends State<_FaqAccordionItem> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.isExpanded
                ? [
                    BoxShadow(
                      color: theme.green.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: GlossCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  decoration: widget.isExpanded
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.greenBgLight,
                              theme.greenBgSoft,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                        )
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.question,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: widget.isExpanded
                                  ? theme.green
                                  : theme.text,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: widget.isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: widget.isExpanded
                                ? theme.green
                                : theme.hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      widget.answer,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.hint,
                        height: 1.6,
                      ),
                    ),
                  ),
                  crossFadeState: widget.isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StaggeredItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const _StaggeredItem({
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final begin = (index * 0.12).clamp(0.0, 0.88);
    final end = (index * 0.12 + 0.12).clamp(0.12, 1.0);
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _TapCard extends StatefulWidget {
  final Widget child;

  const _TapCard({required this.child});

  @override
  State<_TapCard> createState() => _TapCardState();
}

class _TapCardState extends State<_TapCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

class _TapButton extends StatefulWidget {
  final Widget Function(double scale) builder;
  final VoidCallback onTap;

  const _TapButton({required this.builder, required this.onTap});

  @override
  State<_TapButton> createState() => _TapButtonState();
}

class _TapButtonState extends State<_TapButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: widget.builder(_scale),
    );
  }
}
