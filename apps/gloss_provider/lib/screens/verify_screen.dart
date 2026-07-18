import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  const VerifyScreen({super.key, required this.phone});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _resendTimer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
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

  void _verify() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.sms_rounded, size: 64, color: theme.green),
              const SizedBox(height: 24),
              Text(
                'Kodni tasdiqlang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.text,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: theme.hint, height: 1.5),
                  children: [
                    const TextSpan(text: 'Biz '),
                    TextSpan(
                      text: widget.phone,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.text,
                      ),
                    ),
                    const TextSpan(text: ' raqamiga SMS kod jo\'natdik'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 56,
                    height: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.green, width: 2),
                        ),
                      ),
                      onChanged: (v) => _onChanged(index, v),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              _canResend
                  ? TextButton(
                      onPressed: _startResendTimer,
                      child: Text(
                        'Kodni qayta jo\'natish',
                        style: TextStyle(
                          color: theme.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: theme.hint),
                        children: [
                          const TextSpan(text: 'Qayta jo\'natish '),
                          TextSpan(
                            text: '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: theme.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' da mavjud'),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}