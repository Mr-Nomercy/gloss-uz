import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _languages = ["O'zbek", 'Русский', 'English'];
  int _selectedLang = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.cleaning_services,
      title: "Toza uy, toza hayot",
      description: "Professional tozalik xizmatlariga buyurtma bering",
    ),
    _OnboardingPage(
      icon: Icons.shopping_bag,
      title: "Mahsulotlar yetkazish",
      description: "Kerakli tozalik vositalarini uyingizga buyurtma qiling",
    ),
    _OnboardingPage(
      icon: Icons.location_on,
      title: "Real vaqtda kuzatish",
      description: "Buyurtmangizni real vaqtda kuzatib boring",
    ),
  ];

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (_currentPage == 0)
              _buildLanguageSelector(theme)
            else
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: Text(
                    "Skip",
                    style: TextStyle(color: theme.hint, fontSize: 14),
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length + 1,
                itemBuilder: (_, i) {
                  if (i < _pages.length) return _buildPage(_pages[i], theme);
                  return _buildPermissionsPage(theme);
                },
              ),
            ),
            if (_currentPage > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length + 1, (i) => _buildDot(i, theme)),
              ),
            const SizedBox(height: 24),
            if (_currentPage == 0)
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    child: const Text("Davom etish"),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _currentPage < _pages.length ? _nextPage : () => context.go('/auth/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        child: Text(_currentPage < _pages.length ? "Keyingi" : "Boshlash"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go('/auth/login'),
                      child: Text(
                        "Hisobingiz bormi? Kirish",
                        style: TextStyle(color: theme.green, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(GlossTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Tilni tanlang',
            style: TextStyle(fontSize: 14, color: theme.hint),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_languages.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(_languages[i]),
                  selected: _selectedLang == i,
                  selectedColor: theme.greenBgLight,
                  onSelected: (_) => setState(() => _selectedLang = i),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsPage(GlossTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_active, size: 80, color: theme.green),
          const SizedBox(height: 24),
          Text(
            "Xabarnoma va joylashuv",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: theme.text, height: 1.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Buyurtma holati haqida xabarnoma olish va yetkazib berish uchun joylashuv ruxsatini bering",
            style: TextStyle(fontSize: 15, color: theme.hint, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildPermissionTile(Icons.notifications, "Xabarnomalar", "Buyurtma holati, aksiyalar va muhim bildirishnomalar", theme),
          const SizedBox(height: 12),
          _buildPermissionTile(Icons.location_on, "Joylashuv", "Yetkazib berish manzilini aniqlash va kuryerni kuzatish", theme),
        ],
      ),
    );
  }

  Widget _buildPermissionTile(IconData icon, String title, String subtitle, GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.greenBgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: theme.hint)),
              ],
            ),
          ),
          Switch(value: true, onChanged: (_) {}, activeTrackColor: theme.green),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, GlossTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.greenBgLight,
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 80, color: theme.green),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: theme.text, height: 1.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: TextStyle(fontSize: 15, color: theme.hint, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, GlossTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? theme.green : theme.grayLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  _OnboardingPage({required this.icon, required this.title, required this.description});
}
