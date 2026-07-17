import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final Map<int, _DaySchedule> _schedule = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final days = ['Dushanba', 'Seshanba', 'Chorshanba', 'Payshanba', 'Juma', 'Shanba', 'Yakshanba'];
    for (int i = 0; i < 7; i++) {
      final day = now.add(Duration(days: i));
      final weekday = day.weekday;
      _schedule[weekday] = _DaySchedule(
        date: '${day.day} ${_monthName(day.month)}',
        label: days[weekday - 1],
        isAvailable: weekday < 6,
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 18, minute: 0),
      );
    }
  }

  String _monthName(int m) {
    const months = [
      'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun',
      'Iyul', 'Avgust', 'Sentabr', 'Oktabr', 'Noyabr', 'Dekabr'
    ];
    return months[m - 1];
  }

  Future<void> _pickTime(BuildContext context, bool isStart, int weekday) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? _schedule[weekday]!.startTime : _schedule[weekday]!.endTime,
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _schedule[weekday]!.startTime = time;
        } else {
          _schedule[weekday]!.endTime = time;
        }
      });
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
          'Vaqtlarim',
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _schedule.entries.map((entry) {
                final weekday = entry.key;
                final schedule = entry.value;
                return _buildDayCard(theme, weekday, schedule);
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.card,
              boxShadow: [
                BoxShadow(
                  color: theme.blackTint10,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Vaqtlar saqlandi'),
                        backgroundColor: theme.green,
                        behavior: SnackBarBehavior.floating,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Saqlash'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(GlossTheme theme, int weekday, _DaySchedule schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlossCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        schedule.date,
                        style: TextStyle(fontSize: 13, color: theme.hint),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: schedule.isAvailable,
                  activeTrackColor: theme.green,
                  onChanged: (v) => setState(() => schedule.isAvailable = v),
                ),
              ],
            ),
            if (schedule.isAvailable) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(context, true, weekday),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                          color: theme.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Boshlash',
                              style: TextStyle(fontSize: 13, color: theme.hint),
                            ),
                            Text(
                              schedule.startTime.format(context),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 20,
                      height: 1.5,
                      color: theme.grayMedium,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(context, false, weekday),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                          color: theme.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tugash',
                              style: TextStyle(fontSize: 13, color: theme.hint),
                            ),
                            Text(
                              schedule.endTime.format(context),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DaySchedule {
  final String date;
  final String label;
  bool isAvailable;
  TimeOfDay startTime;
  TimeOfDay endTime;

  _DaySchedule({
    required this.date,
    required this.label,
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
  });
}
