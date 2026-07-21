import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AddressResult {
  final String address;
  final double lat;
  final double lng;

  const AddressResult(this.address, this.lat, this.lng);
}

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  List<Map<String, String>> _suggestions = [];
  String? _resolvedAddress;

  static const _mockResults = [
    {'title': 'Amir Temur shoh ko\'chasi, 100', 'subtitle': 'Chilonzor tumani, Toshkent'},
    {'title': 'Bodomzor ko\'chasi, 25', 'subtitle': 'Mirzo Ulug\'bek tumani, Toshkent'},
    {'title': 'Navoiy ko\'chasi, 50', 'subtitle': 'Yunusobod tumani, Toshkent'},
    {'title': 'Buyuk Turon ko\'chasi, 15', 'subtitle': 'Shayxontohur tumani, Toshkent'},
    {'title': 'Osiyo ko\'chasi, 7', 'subtitle': 'Sergeli tumani, Toshkent'},
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final text = _searchCtrl.text.trim();
    if (text.isEmpty) {
      setState(() { _suggestions = []; });
      return;
    }
    setState(() {
      _suggestions = _mockResults.where((r) =>
        r['title']!.toLowerCase().contains(text.toLowerCase())
      ).toList();
    });
  }

  void _onSelectSuggestion(Map<String, String> item) {
    _focusNode.unfocus();
    _searchCtrl.text = item['title']!;
    setState(() {
      _resolvedAddress = item['title']!;
      _suggestions = [];
    });
  }

  void _confirm() {
    if (_resolvedAddress == null) return;
    Navigator.pop(
      context,
      AddressResult(_resolvedAddress!, 41.2995, 69.2401),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
        title: const Text('Manzilni tanlang', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: Stack(
        children: [
          Container(color: GlossColors.bg),
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                _searchField(),
                if (_suggestions.isNotEmpty) _suggestionsList(),
              ],
            ),
          ),
          if (_resolvedAddress != null) _bottomPanel(),
        ],
      ),
    );
  }

  Widget _searchField() {
    return GlossTextField(
      hint: "Ko'cha nomi, manzil...",
      controller: _searchCtrl,
      focusNode: _focusNode,
      prefixIcon: const Icon(Icons.search_rounded, color: GlossColors.hint),
      suffixIcon: _searchCtrl.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear_rounded, size: 20),
              onPressed: () {
                _searchCtrl.clear();
                _focusNode.unfocus();
              },
            )
          : null,
    );
  }

  Widget _suggestionsList() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      constraints: const BoxConstraints(maxHeight: 280),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _suggestions.length,
        separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, i) {
          final item = _suggestions[i];
          return ListTile(
            dense: true,
            leading: const Icon(Icons.location_on_rounded, color: GlossColors.green, size: 20),
            title: Text(item['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(item['subtitle']!, style: const TextStyle(fontSize: 12, color: GlossColors.hint), maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => _onSelectSuggestion(item),
          );
        },
      ),
    );
  }

  Widget _bottomPanel() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_resolvedAddress != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: GlossColors.green.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.location_on_rounded, color: GlossColors.green, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanlangan manzil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GlossColors.text)),
                          const SizedBox(height: 4),
                          Text(
                            _resolvedAddress ?? '',
                            style: const TextStyle(fontSize: 13, color: GlossColors.hint),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: _resolvedAddress != null ? 16 : 0),
              GlossButton(
                label: 'Tasdiqlash',
                onPressed: _resolvedAddress != null ? _confirm : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
