import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'animations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = true;
  int _currentStep = 0;
  String? _error;
  String? _phoneError;
  String? _nameError;
  String? _passwordError;

  static const _totalSteps = 3;

  final _stepTitles = ['Telefon', "Ma'lumotlar", 'Parol'];

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateStep() {
    setState(() {
      _phoneError = null;
      _nameError = null;
      _passwordError = null;
      _error = null;
    });

    switch (_currentStep) {
      case 0:
        if (_phoneController.text.trim().isEmpty) {
          _phoneError = 'Telefon raqamni kiriting';
          return false;
        }
        if (_phoneController.text.trim().length < 9) {
          _phoneError = 'Raqam noto\'g\'ri';
          return false;
        }
        return true;
      case 1:
        if (_nameController.text.trim().isEmpty) {
          _nameError = 'Ismingizni kiriting';
          return false;
        }
        return true;
      case 2:
        if (_passwordController.text.trim().isEmpty) {
          _passwordError = 'Parolni kiriting';
          return false;
        }
        if (_passwordController.text.trim().length < 4) {
          _passwordError = 'Parol kamida 4 ta belgi';
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (!_validateStep()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submit() {
    if (!_agreeToTerms) {
      setState(() => _error = 'Foydalanish shartlariga rozilik bildiring');
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: theme.text),
                onPressed: _prevStep,
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            FadeSlideOnMount(
              child: Text(
                _currentStep == _totalSteps - 1
                    ? 'Parol yarating'
                    : 'Hisob yaratish',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            FadeSlideOnMount(
              delay: const Duration(milliseconds: 100),
              child: Text(
                "Ma'lumotlaringizni kiriting",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: theme.hint,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            FadeSlideOnMount(
              delay: const Duration(milliseconds: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalSteps, (i) {
                  final isActive = i == _currentStep;
                  final isDone = i < _currentStep;
                  return Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 40 : 32,
                        height: isActive ? 40 : 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? theme.green
                              : isActive
                                  ? theme.green
                                  : theme.grayLight,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: theme.greenShadow.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : theme.hint,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                      if (i < _totalSteps - 1) ...[
                        const SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 24,
                          height: 2,
                          decoration: BoxDecoration(
                            color: i < _currentStep ? theme.green : theme.border,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _stepTitles.asMap().entries.map((e) {
                final isActive = e.key == _currentStep;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: e.key == 1 ? 20.0 : 0),
                  child: Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? theme.green : theme.hint,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildStepContent(theme, key: ValueKey(_currentStep)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 18, color: theme.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: theme.red, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_currentStep == _totalSteps - 1) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (v) => setState(() => _agreeToTerms = v ?? true),
                      activeColor: theme.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Foydalanish shartlari va maxfiylik siyosatiga roziman',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: theme.hint,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            GlossButton(
              label: _currentStep < _totalSteps - 1
                  ? 'Davom etish'
                  : "Ro'yxatdan o'tish",
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _nextStep,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/auth/login'),
              child: Text(
                'Hisobingiz bormi? Kirish',
                style: TextStyle(
                  color: theme.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(GlossTheme theme, {Key? key}) {
    return GlossCard(
      key: key,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: switch (_currentStep) {
          0 => [
              GlossTextField(
                label: 'Telefon raqam',
                hint: '+998 XX XXX XX XX',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                errorText: _phoneError,
                autofocus: true,
                onChanged: (_) {
                  if (_phoneError != null) setState(() => _phoneError = null);
                },
              ),
            ],
          1 => [
              GlossTextField(
                label: 'Ism familiya',
                hint: 'Ismingizni kiriting',
                controller: _nameController,
                errorText: _nameError,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
            ],
          2 => [
              GlossTextField(
                label: 'Parol',
                hint: 'Parolingizni kiriting',
                controller: _passwordController,
                obscureText: true,
                errorText: _passwordError,
                autofocus: true,
                onChanged: (_) {
                  if (_passwordError != null) setState(() => _passwordError = null);
                },
              ),
            ],
          _ => [],
        },
      ),
    );
  }
}
