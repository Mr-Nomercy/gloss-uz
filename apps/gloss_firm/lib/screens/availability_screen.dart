import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen>
    with TickerProviderStateMixin {
  final Map<int, _DaySchedule> _schedule = {};
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      _initData();
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  void _initData() {
    final now = DateTime.now();
    final days = [
      'Dushanba', 'Seshanba', 'Chorshanba', 'Payshanba',
      'Juma', 'Shanba', 'Yakshanba',
    ];
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
    setState(() => _isLoading = false);
    _fadeController.forward();
  }

  String _monthName(int m) {
    const months = [
      'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun',
      'Iyul', 'Avgust', 'Sentabr', 'Oktabr', 'Noyabr', 'Dekabr',
    ];
    return months[m - 1];
  }

  Future<void> _pickTime(BuildContext context, bool isStart, int weekday) async {
    final time = await showTimePicker(
      context: context,
      initialTime:
          isStart ? _schedule[weekday]!.startTime : _schedule[weekday]!.endTime,
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
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
          style: TextStyle(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: theme.text, size: 18),
          ),
        ),
      ),
      body: _isLoading
          ? const GlossLoadingView(message: 'Yuklanmoqda...')
          : _hasError
              ? GlossErrorView.connection(onRetry: _loadData)
              : Column(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _schedule.length,
                      itemBuilder: (context, index) {
                        final weekday = _schedule.keys.elementAt(index);
                        final schedule = _schedule[weekday]!;
                        return _DayCardWidget(
                          key: ValueKey(weekday),
                          weekday: weekday,
                          schedule: schedule,
                          theme: theme,
                          onToggle: () =>
                              setState(() {}),
                          onPickStart: () =>
                              _pickTime(context, true, weekday),
                          onPickEnd: () =>
                              _pickTime(context, false, weekday),
                          index: index,
                        );
                      },
                    ),
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
                    child: GlossButton(
                      label: 'Saqlash',
                      onPressed: () {
                        GlossSnackBar.showSuccess(context, 'Vaqtlar saqlandi');
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DayCardWidget extends StatefulWidget {
  final int weekday;
  final _DaySchedule schedule;
  final GlossTheme theme;
  final VoidCallback onToggle;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final int index;

  const _DayCardWidget({
    super.key,
    required this.weekday,
    required this.schedule,
    required this.theme,
    required this.onToggle,
    required this.onPickStart,
    required this.onPickEnd,
    required this.index,
  });

  @override
  State<_DayCardWidget> createState() => _DayCardWidgetState();
}

class _DayCardWidgetState extends State<_DayCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  double _scaleValue = 1.0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    );
    if (widget.schedule.isAvailable) {
      _slideController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _DayCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.schedule.isAvailable && !oldWidget.schedule.isAvailable) {
      _slideController.forward();
    } else if (!widget.schedule.isAvailable &&
        oldWidget.schedule.isAvailable) {
      _slideController.reverse();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final schedule = widget.schedule;
    final isActive = schedule.isAvailable;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (widget.index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scaleValue = 0.97),
        onTapUp: (_) => setState(() => _scaleValue = 1.0),
        onTapCancel: () => setState(() => _scaleValue = 1.0),
        child: AnimatedScale(
          scale: _scaleValue,
          duration: const Duration(milliseconds: 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GlossCard(
              padding: EdgeInsets.zero,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: isActive
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            theme.green.withValues(alpha: 0.05),
                            theme.greenBgLight,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? theme.green
                                  : theme.grayMedium,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
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
                                  style: TextStyle(
                                      fontSize: 13, color: theme.hint),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => schedule.isAvailable = !schedule.isAvailable);
                              widget.onToggle();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 48,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: isActive
                                    ? theme.green
                                    : theme.grayMedium,
                              ),
                              child: AnimatedAlign(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                alignment: isActive
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizeTransition(
                        sizeFactor: _slideAnimation,
                        axis: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _TimeSlot(
                                    label: 'Boshlash',
                                    time: schedule.startTime.format(context),
                                    onTap: widget.onPickStart,
                                    theme: theme,
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
                                  child: _TimeSlot(
                                    label: 'Tugash',
                                    time: schedule.endTime.format(context),
                                    onTap: widget.onPickEnd,
                                    theme: theme,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlot extends StatefulWidget {
  final String label;
  final String time;
  final VoidCallback onTap;
  final GlossTheme theme;

  const _TimeSlot({
    required this.label,
    required this.time,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<_TimeSlot> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: widget.theme.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.theme.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(fontSize: 13, color: widget.theme.hint),
              ),
              Text(
                widget.time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.theme.green,
                ),
              ),
            ],
          ),
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
