import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<bool> _expanded = [false, false, false, false];

  final List<Map<String, String>> _faqItems = const [
    {
      'question': 'Qanday buyurtma qabul qilaman?',
      'answer': 'Yangi buyurtmalar sizning asosiy ekranda "Yangi takliflar" bo\'limida paydo '
          'bo\'ladi. Online rejimda bo\'lganingizda ularni ko\'rishingiz va 15 soniya ichida '
          'qabul qilishingiz yoki rad etishingiz mumkin. Qabul qilgandan so\'ng buyurtma '
          'tarixi bo\'limida ko\'rinadi.',
    },
    {
      'question': "To'lov qachon keladi?",
      'answer': 'To\'lovlar buyurtma tugatilgandan so\'ng 24-48 soat ichida hamyoningizga '
          'tushadi. Siz to\'plangan balansni istalgan vaqtda plastik kartangizga yechib '
          'olishingiz mumkin. Minimal yechish summasi 100 000 so\'m.',
    },
    {
      'question': 'Vaqtimni qanday o\'zgartiraman?',
      'answer': '"Vaqtlarim" bo\'limiga o\'ting. U yerda haftaning har bir kuni uchun '
          'ish vaqtingizni sozlashingiz mumkin. Har bir kun uchun alohida boshlanish '
          'va tugash vaqtini belgilang. O\'zgarishlarni "Saqlash" tugmasi orqali tasdiqlang.',
    },
    {
      'question': 'Hisobimni o\'chirish',
      'answer': 'Hisobingizni o\'chirish uchun qo\'llab-quvvatlash xizmatiga murojaat qiling. '
          'Biz sizning so\'rovingizni ko\'rib chiqamiz va 3 ish kuni ichida javob beramiz. '
          'Hisob o\'chirilganda barcha ma\'lumotlaringiz o\'chiriladi.',
    },
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFaqSection(theme),
            const SizedBox(height: 16),
            _buildContactCard(theme),
            const SizedBox(height: 16),
            _buildMessageButton(context),
            const SizedBox(height: 24),
          ],
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
        ),
        ..._faqItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GlossCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _expanded[index] = !_expanded[index]),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['question']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.text,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: _expanded[index] ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(Icons.keyboard_arrow_down, color: theme.hint),
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
                        item['answer']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.hint,
                          height: 1.6,
                        ),
                      ),
                    ),
                    crossFadeState: _expanded[index] ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildContactCard(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bog'lanish",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
          const SizedBox(height: 16),
          _contactRow(Icons.phone_outlined, '+998 71 200 00 01', theme),
          const SizedBox(height: 12),
          _contactRow(Icons.email_outlined, 'support@gloss.com.uz', theme),
          const SizedBox(height: 12),
          _contactRow(Icons.access_time, 'Ish vaqti: 09:00-21:00', theme),
        ],
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
        Text(text, style: TextStyle(fontSize: 14, color: theme.text)),
      ],
    );
  }

  Widget _buildMessageButton(BuildContext context) {
    return GlossButton(
      label: 'Xabar yuborish',
      icon: Icons.chat_outlined,
      onPressed: () {
        GlossSnackBar.showSuccess(context, 'Xabar yuborish funksiyasi tez orada ishga tushadi');
      },
    );
  }
}