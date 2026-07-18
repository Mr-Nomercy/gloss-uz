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
      GlossSnackBar.showError(context, 'Iltimos, barcha baholashlarni belgilang');
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
      backgroundColor: context.gloss.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.gloss.bg,
        title: const Text('Baholash'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.gloss.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: context.gloss.text, size: 18),
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
                            backgroundColor: context.gloss.greenBgPale,
                            child: Icon(Icons.group_rounded, size: 32, color: context.gloss.green),
                          ),
                          const SizedBox(height: 12),
                          Text(widget.teamName!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.gloss.text)),
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
                  Text('Izoh (ixtiyoriy)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.gloss.text)),
                  const SizedBox(height: 8),
                  GlossTextField(
                    hint: "Tajribangizni baham ko'ring...",
                    controller: _commentController,
                    maxLines: 4,
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
                    backgroundColor: context.gloss.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: context.gloss.disabled,
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
        color: context.gloss.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.gloss.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.gloss.text)),
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
                    color: isSelected ? context.gloss.star : context.gloss.disabled,
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