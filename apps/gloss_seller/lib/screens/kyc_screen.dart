import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  String? _selectedDocType;

  final _docTypes = ['Passport', 'Selfie', 'Bank kartasi', 'INN', 'Litsenziya', 'Sertifikat'];

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
          GlossCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.orangeBgLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.verified_user, color: theme.orange, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tasdiqlanmagan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.orange, height: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  "Do'koningizni faollashtirish uchun shaxsingizni tasdiqlang",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: theme.hint, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hujjat turi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text, height: 1.4),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedDocType,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.green, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            hint: Text('Hujjat turini tanlang', style: TextStyle(color: theme.hint)),
            items: _docTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(color: theme.text)))).toList(),
            onChanged: (v) => setState(() => _selectedDocType = v),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.greenBgPale,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.greenBorderLight, width: 1.5),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFFBDBDBD)),
                  SizedBox(height: 8),
                  Text('Hujjat rasmini yuklash', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              child: const Text('Yuborish'),
            ),
          ),
        ],
      ),
    );
  }
}
