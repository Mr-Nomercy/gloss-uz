import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/users_provider.dart';
import '../utils/string_utils.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _searchController = TextEditingController();
  String? _activeRoleFilter;

  static final _mockUsers = [
    const AppUser(
      id: '1', fullName: 'Aziz Karimov', phone: '+998901234567',
      email: 'aziz@mail.uz', roles: ['client'],
      isBlocked: false, totalOrders: 42, totalSpent: 3250000,
    ),
    const AppUser(
      id: '2', fullName: 'Dilnoza Rahimova', phone: '+998931112233',
      roles: ['client'], isBlocked: false, totalOrders: 28, totalSpent: 2150000,
    ),
    const AppUser(
      id: '3', fullName: 'Jamshid Aliyev', phone: '+998945556677',
      email: 'jamshid@mail.uz', roles: ['client'],
      isBlocked: false, totalOrders: 15, totalSpent: 980000,
    ),
    const AppUser(
      id: '4', fullName: 'Botir Ergashev', phone: '+998971234567',
      roles: ['courier'], isBlocked: false, totalOrders: 320, totalSpent: 0,
    ),
    const AppUser(
      id: '5', fullName: 'Anvar Soliyev', phone: '+998901112233',
      email: 'anvar@mail.uz', roles: ['courier'],
      isBlocked: true, totalOrders: 180, totalSpent: 0,
    ),
    const AppUser(
      id: '6', fullName: 'Madina Umarova', phone: '+998931112244',
      roles: ['provider'], isBlocked: false, totalOrders: 860, totalSpent: 0,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final users = _activeRoleFilter == null
        ? _mockUsers
        : _mockUsers.where((u) => u.roles.contains(_activeRoleFilter)).toList();

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: 'Foydalanuvchilar'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: GlossTextField(
              controller: _searchController,
              hint: 'Qidirish...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.hint, size: 20),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _roleChip('Barchasi', 'all', theme),
                _roleChip('Mijozlar', 'client', theme),
                _roleChip('Provayderlar', 'provider', theme),
                _roleChip('Kuryerlar', 'courier', theme),
                _roleChip('Adminlar', 'admin', theme),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: users.length,
              itemBuilder: (_, i) {
                final user = users[i];
                return _buildUserCard(theme, user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String label, String role, GlossTheme theme) {
    final isSelected = role == 'all'
        ? _activeRoleFilter == null
        : _activeRoleFilter == role;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _activeRoleFilter = role == 'all' ? null : role;
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        checkmarkColor: theme.green,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? theme.green : theme.hint,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: isSelected ? theme.green : theme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildUserCard(GlossTheme theme, AppUser user) {
    final color = user.isBlocked ? theme.red : (user.roles.contains('provider') ? theme.green : (user.roles.contains('courier') ? theme.orange : GlossColors.catBlue));
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlossCard(
        accentColor: color,
        padding: const EdgeInsets.all(14),
        onTap: () => context.push('/users/${user.id}'),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Center(
                child: Text(
                  safeFirstChar(user.fullName),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: GlossColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.phone,
                    style: TextStyle(fontSize: 13, color: theme.hint),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GlossBadge(
                  label: user.roleLabel,
                  variant: BadgeVariant.neutral,
                  fontSize: 11,
                ),
                const SizedBox(height: 4),
                if (user.isBlocked)
                  GlossBadge(
                    label: 'Bloklangan',
                    variant: BadgeVariant.error,
                    fontSize: 11,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
