import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'gloss_button.dart';

class GlossEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final double iconSize;

  const GlossEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconSize = 64,
  });

  factory GlossEmptyState.orders({VoidCallback? onAction}) {
    return GlossEmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'Buyurtmalar yo\'q',
      subtitle: 'Hozircha hech qanday buyurtma yo\'q',
      action: onAction != null
          ? GlossButton(label: 'Buyurtma berish', onPressed: onAction)
          : null,
    );
  }

  factory GlossEmptyState.notifications({VoidCallback? onAction}) {
    return GlossEmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'Bildirishnomalar yo\'q',
      subtitle: 'Yangi bildirishnomalar kelganda bu yerda ko\'rinadi',
      action: null,
    );
  }

  factory GlossEmptyState.favorites({VoidCallback? onAction}) {
    return GlossEmptyState(
      icon: Icons.favorite_border_rounded,
      title: 'Sevimlilar bo\'sh',
      subtitle: 'Yoqtirgan mahsulotlaringizni saqlang',
      action: null,
    );
  }

  factory GlossEmptyState.addresses({VoidCallback? onAction}) {
    return GlossEmptyState(
      icon: Icons.location_on_outlined,
      title: 'Manzillar yo\'q',
      subtitle: 'Tezroq buyurtma uchun manzil qo\'shing',
      action: onAction != null
          ? GlossButton(label: 'Manzil qo\'shish', onPressed: onAction)
          : null,
    );
  }

  factory GlossEmptyState.cart({VoidCallback? onAction}) {
    return GlossEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Savat bo\'sh',
      subtitle: 'Mahsulotlar qo\'shib xaridni boshlang',
      action: onAction != null
          ? GlossButton(label: 'Marketga o\'tish', onPressed: onAction)
          : null,
    );
  }

  factory GlossEmptyState.search({String? query}) {
    return GlossEmptyState(
      icon: Icons.search_off_rounded,
      title: query != null ? '"$query" topilmadi' : 'Hech narsa topilmadi',
      subtitle: 'Boshqa so\'z bilan qidirib ko\'ring',
      action: null,
    );
  }

  factory GlossEmptyState.error({String? message, VoidCallback? onRetry}) {
    return GlossEmptyState(
      icon: Icons.error_outline_rounded,
      title: 'Xatolik yuz berdi',
      subtitle: message ?? "Noma'lum xatolik",
      iconSize: 64,
      action: onRetry != null
          ? GlossButton(
              label: 'Qayta urinish',
              onPressed: onRetry,
              fitWidth: false,
            )
          : null,
    );
  }

  factory GlossEmptyState.offline({VoidCallback? onRetry}) {
    return GlossEmptyState(
      icon: Icons.wifi_off_rounded,
      title: 'Internetga ulanishda xatolik',
      subtitle: null,
      action: onRetry != null
          ? GlossButton(
              label: 'Qayta urinish',
              onPressed: onRetry,
              fitWidth: false,
            )
          : null,
    );
  }

  factory GlossEmptyState.serverError({VoidCallback? onRetry}) {
    return GlossEmptyState(
      icon: Icons.dns_outlined,
      title: 'Serverda xatolik',
      subtitle: null,
      action: onRetry != null
          ? GlossButton(
              label: 'Qayta urinish',
              onPressed: onRetry,
              fitWidth: false,
            )
          : null,
    );
  }

  factory GlossEmptyState.noResults({String? query}) {
    return GlossEmptyState(
      icon: Icons.search_off_rounded,
      title: 'Hech narsa topilmadi',
      subtitle: query != null ? '"$query" bo\'yicha natija topilmadi' : 'Boshqa so\'z bilan qidirib ko\'ring',
      action: null,
    );
  }

  factory GlossEmptyState.comingSoon() {
    return GlossEmptyState(
      icon: Icons.schedule_rounded,
      title: 'Tez orada',
      subtitle: null,
      action: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: GlossColors.grayLight,
                borderRadius: BorderRadius.circular(iconSize / 2),
              ),
              child: Icon(icon, size: iconSize * 0.5, color: GlossColors.hint),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: GlossColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(fontSize: 14, color: GlossColors.hint),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              SizedBox(width: 200, child: action!),
            ],
          ],
        ),
      ),
    );
  }
}