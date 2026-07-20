import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.gloss.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.gloss.bg,
        centerTitle: true,
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
        title: Text(
          'Bildirishnomalar',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.gloss.text),
        ),
      ),
      body: Center(
        child: GlossEmptyState.notifications(),
      ),
    );
  }
}