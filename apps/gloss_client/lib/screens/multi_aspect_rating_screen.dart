import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class MultiAspectRatingScreen extends StatefulWidget {
  final String orderId;
  final String? teamName;

  const MultiAspectRatingScreen({
    super.key,
    this.orderId = '',
    this.teamName,
  });

  @override
  State<MultiAspectRatingScreen> createState() => _MultiAspectRatingScreenState();
}

class _MultiAspectRatingScreenState extends State<MultiAspectRatingScreen> {
  int _quality = 0;
  int _punctuality = 0;
  int _communication = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _quality > 0 && _punctuality > 0 && _communication > 0;

  void _submit() {
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, barcha baholashlarni belgilang'), backgroundColor: Colors.red),
      );
      return;
    }
    Navigator.pop(context, {
      'quality': _quality,
      'punctuality': _punctuality,
      'communication': _communication,
      'comment': _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlossColors.bg,
        title: const Text('Baholash'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.teamName != null && widget.teamName!.isNotEmpty) ...[
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: GlossColors.greenBgPale,
                            child: Icon(Icons.group_rounded, size: 32, color: GlossColors.green),
                          ),
                          const SizedBox(height: 12),
                          Text(widget.teamName!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                  _AspectRating(title: 'Tozalash sifati', rating: _quality, onChanged: (v) => setState(() => _quality = v)),
                  const SizedBox(height: 20),
                  _AspectRating(title: 'Vaqtida kelishi', rating: _punctuality, onChanged: (v) => setState(() => _punctuality = v)),
                  const SizedBox(height: 20),
                  _AspectRating(title: 'Muloqot', rating: _communication, onChanged: (v) => setState(() => _communication = v)),
                  const SizedBox(height: 24),
                  Text('Izoh (ixtiyoriy)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Tajribangizni baham ko'ring...",
                      hintStyle: TextStyle(color: GlossColors.hint),
                      filled: true,
                      fillColor: GlossColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: GlossColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: GlossColors.border),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GlossColors.disabled,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Yuborish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AspectRating extends StatelessWidget {
  final String title;
  final int rating;
  final ValueChanged<int> onChanged;

  const _AspectRating({required this.title, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlossColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GlossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (idx) {
              final starIndex = idx + 1;
              final isSelected = starIndex <= rating;
              return InkWell(
                onTap: () => onChanged(starIndex),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isSelected ? GlossColors.star : GlossColors.disabled,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
