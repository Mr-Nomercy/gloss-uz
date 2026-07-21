import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gloss_worker/providers/auth_provider.dart';
import 'package:gloss_worker/widgets/staggered_item.dart';
import 'package:ui_kit/ui_kit.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String phone;
  const VerifyScreen({super.key, required this.phone});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _resendTimer;
  int _secondsRemaining = 30;
  bool _canResend = false;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _otpPulseController;
  late final Animation<double> _otpPulseAnimation;
  bool _isLoading = true;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    _otpPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _otpPulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
          parent: _otpPulseController, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
      }
    });
  }

  void _startResendTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    _fadeController.dispose();
    _otpPulseController.dispose();
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value[value.length - 1];
    }
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_allFilled) {
      _verify();
    }
  }

  bool get _allFilled => _controllers.every((c) => c.text.isNotEmpty);

  Future<void> _verify() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      setState(() => _isVerifying = true);
      final success = await ref
          .read(authProvider.notifier)
          .verifyOtp(widget.phone, otp);
      if (!mounted) return;
      setState(() => _isVerifying = false);
      if (success) {
        context.go('/');
      } else {
        final needsReg = ref.read(authProvider).needsRegistration;
        if (needsReg) {
          context.go('/auth/register');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: ''),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      GlossStaggeredItem(
                        index: 0,
                        controller: _fadeController,
                        child: AnimatedBuilder(
                          animation: _otpPulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _otpPulseAnimation.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.greenBgLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    theme.green.withValues(alpha: 0.15),
                                width: 2,
                              ),
                            ),
                            child: Icon(Icons.sms_rounded,
                                size: 36, color: theme.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GlossStaggeredItem(
                        index: 1,
                        controller: _fadeController,
                        child: Text(
                          'Kodni tasdiqlang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.text,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GlossStaggeredItem(
                        index: 2,
                        controller: _fadeController,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.hint,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: 'Biz '),
                              TextSpan(
                                text: widget.phone,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.text,
                                ),
                              ),
                              const TextSpan(
                                  text: ' raqamiga SMS kod jo\'natdik'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      GlossStaggeredItem(
                        index: 3,
                        controller: _fadeController,
                        child: _isVerifying
                            ? Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: theme.green,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tekshirilmoqda...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme.hint,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  return _OtpInput(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    onChanged: (v) =>
                                        _onChanged(index, v),
                                    theme: theme,
                                    index: index,
                                    filled: _controllers[index]
                                        .text
                                        .isNotEmpty,
                                  );
                                }),
                              ),
                      ),
                      const SizedBox(height: 32),
                      GlossStaggeredItem(
                        index: 4,
                        controller: _fadeController,
                        child: _canResend
                            ? _TapButton(
                                onTap: _startResendTimer,
                                builder: (scale) {
                                  return AnimatedScale(
                                    scale: scale,
                                    duration: const Duration(
                                        milliseconds: 100),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Kodni qayta jo\'natish',
                                        style: TextStyle(
                                          color: theme.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.hint,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text: 'Qayta jo\'natish '),
                                    TextSpan(
                                      text:
                                          '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: theme.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(
                                        text: ' da mavjud'),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _OtpInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final GlossTheme theme;
  final int index;
  final bool filled;

  const _OtpInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.theme,
    required this.index,
    required this.filled,
  });

  @override
  State<_OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<_OtpInput>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant _OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filled && !oldWidget.filled) {
      _pulseController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56,
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.filled ? theme.green : theme.border,
            width: widget.filled ? 2.0 : 1.0,
          ),
          boxShadow: widget.filled
              ? [
                  BoxShadow(
                    color: theme.green.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.text,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: theme.card,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: widget.onChanged,
        ),
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
