import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'animations.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  String? _selectedDocType;
  int _selectedDocIndex = -1;
  double _uploadProgress = 0;
  bool _isUploading = false;
  bool _submitted = false;

  final _docTypesWithIcons = const [
    _DocType('Passport', Icons.credit_card, 'Passport yoki ID karta'),
    _DocType('Selfie', Icons.face, 'Passport bilan selfie'),
    _DocType('Bank kartasi', Icons.account_balance, 'Bank kartasi rasmi'),
    _DocType('INN', Icons.assignment, 'INN guvohnomasi'),
    _DocType('Litsenziya', Icons.verified, 'Faoliyat litsenziyasi'),
    _DocType('Sertifikat', Icons.workspace_premium, 'Sifat sertifikati'),
  ];

  void _startUpload() {
    if (_selectedDocType == null) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    _simulateUpload();
  }

  void _simulateUpload() async {
    for (var i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _uploadProgress = i / 10;
          if (i == 10) {
            _isUploading = false;
            _submitted = true;
          }
        });
      }
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
        title: Text(
          'KYC tekshiruvi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FadeSlideOnMount(
            child: GlossCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey(_submitted),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: _submitted ? theme.greenBgLight : theme.orangeBgLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _submitted ? Icons.check_circle : Icons.verified_user,
                        color: _submitted ? theme.green : theme.orange,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _submitted
                        ? const GlossBadge(label: 'Tekshiruvga yuborildi', variant: BadgeVariant.success)
                        : const GlossBadge(label: 'Tasdiqlanmagan', variant: BadgeVariant.warning),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _submitted
                        ? 'Hujjatlaringiz tekshiruvga yuborildi. 24-48 soat ichida natija beriladi.'
                        : 'Do\'koningizni faollashtirish uchun shaxsingizni tasdiqlang',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: theme.hint,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Hujjat turi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
              ),
            ),
          ),
          ..._docTypesWithIcons.asMap().entries.map((entry) {
            final i = entry.key;
            final doc = entry.value;
            final isSelected = _selectedDocIndex == i;
            return FadeSlideOnMount(
              delay: Duration(milliseconds: 150 + i * 60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ScaleTap(
                  onTap: () => setState(() {
                    _selectedDocIndex = i;
                    _selectedDocType = doc.label;
                  }),
                  child: GlossCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.green.withValues(alpha: 0.1)
                                : theme.grayLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            doc.icon,
                            color: isSelected ? theme.green : theme.hint,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.label,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? theme.green : theme.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                doc.description,
                                style: TextStyle(fontSize: 12, color: theme.hint),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? theme.green : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? theme.green : theme.border,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 300),
            child: DashedBorder(
              color: _isUploading || _uploadProgress > 0 ? theme.green : theme.greenBorderLight,
              strokeWidth: 2,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: theme.greenBgPale,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _selectedDocType == null || _isUploading
                        ? null
                        : _startUpload,
                    child: Center(
                      child: _isUploading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CircularProgressIndicator(
                                        value: _uploadProgress,
                                        strokeWidth: 4,
                                        color: theme.green,
                                        backgroundColor: theme.greenBgLight,
                                      ),
                                      Center(
                                        child: Text(
                                          '${(_uploadProgress * 100).round()}%',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: theme.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Yuklanmoqda...',
                                  style: TextStyle(color: theme.green, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : _uploadProgress == 1.0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: theme.greenBgLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.check, color: theme.green, size: 28),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Yuklandi',
                                      style: TextStyle(color: theme.green, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: theme.green.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.cloud_upload_outlined, size: 28, color: theme.hint),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Hujjat rasmini yuklash',
                                      style: TextStyle(color: theme.hint, fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'PDF, JPG, PNG (max 10MB)',
                                      style: TextStyle(color: theme.disabled, fontSize: 12),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 400),
            child: GlossButton(
              label: _submitted ? 'Qayta yuborish' : 'Yuborish',
              isLoading: _isUploading,
              onPressed: _isUploading
                  ? null
                  : _uploadProgress == 1.0
                      ? () => setState(() {
                            _submitted = true;
                            _uploadProgress = 0;
                          })
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocType {
  final String label;
  final IconData icon;
  final String description;
  const _DocType(this.label, this.icon, this.description);
}
