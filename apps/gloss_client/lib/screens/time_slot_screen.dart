import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class TimeSlotScreen extends StatefulWidget {
  final String serviceId;
  final DateTime? initialDate;

  const TimeSlotScreen({super.key, this.serviceId = '', this.initialDate});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  late DateTime _selectedDate;
  String? _selectedSlotId;

  final _slots = [
    {'id': '1', 'time': '08:00', 'available': true},
    {'id': '2', 'time': '09:00', 'available': true},
    {'id': '3', 'time': '10:00', 'available': true},
    {'id': '4', 'time': '11:00', 'available': false},
    {'id': '5', 'time': '12:00', 'available': true},
    {'id': '6', 'time': '14:00', 'available': true},
    {'id': '7', 'time': '16:00', 'available': true},
    {'id': '8', 'time': '18:00', 'available': false},
    {'id': '9', 'time': '20:00', 'available': true},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && mounted) setState(() => _selectedDate = picked);
  }

  void _confirm() {
    if (_selectedSlotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, vaqt tanlang'), backgroundColor: Colors.red),
      );
      return;
    }
    final selected = _slots.firstWhere((s) => s['id'] == _selectedSlotId);
    Navigator.pop(context, {
      'date': _selectedDate,
      'startTime': selected['time'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlossColors.bg,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
        title: const Text('Vaqtni tanlang', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_rounded, size: 18),
                    label: Text('${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: GlossColors.text,
                      side: const BorderSide(color: GlossColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: _slots.length,
              itemBuilder: (context, idx) {
                final slot = _slots[idx];
                final isSelected = _selectedSlotId == slot['id'];
                final isAvailable = slot['available'] as bool;
                return InkWell(
                  onTap: isAvailable ? () => setState(() => _selectedSlotId = slot['id'] as String?) : null,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? GlossColors.green
                          : isAvailable
                              ? GlossColors.card
                              : GlossColors.divider,
                      border: Border.all(
                        color: isSelected
                            ? GlossColors.green
                            : isAvailable
                                ? GlossColors.border
                                : GlossColors.divider,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      slot['time'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : isAvailable
                                ? GlossColors.text
                                : GlossColors.disabled,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tasdiqlash', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
