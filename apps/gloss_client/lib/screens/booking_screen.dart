import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'address_search_screen.dart';

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final String subcategoryName;

  const BookingScreen({
    super.key,
    this.serviceName = '',
    this.subcategoryName = '',
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedTariff = 0;
  DateTime _selectedDate = DateTime.now();
  AddressResult? _addressResult;
  String _paymentMethod = 'Naqt';
  final _timeController = TextEditingController(text: '10:00');
  final _notesController = TextEditingController();
  final _promoController = TextEditingController();
  int? _discountPercent;
  String? _appliedPromo;

  static const _tariffs = [
    {'name': 'Iqtisod', 'price': '35 000 so\'m', 'duration': '2 soat', 'raw_price': 35000},
    {'name': 'Standart', 'price': '50 000 so\'m', 'duration': '3 soat', 'raw_price': 50000},
    {'name': 'Premium', 'price': '85 000 so\'m', 'duration': '4 soat', 'raw_price': 85000},
  ];

  static const quickTimes = [
    '08:00', '09:00', '10:00', '11:00', '12:00',
    '14:00', '16:00', '18:00', '20:00',
  ];

  int get _rawPrice => _tariffs[_selectedTariff]['raw_price'] as int;

  int get _discountedPrice {
    if (_discountPercent == null) return _rawPrice;
    return _rawPrice - (_rawPrice * _discountPercent! ~/ 100);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _notesController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _discountPercent = 10;
      _appliedPromo = code;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Promo kod qabul qilindi! 10% chegirma'), backgroundColor: GlossColors.green, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }

  void _removePromo() {
    setState(() { _discountPercent = null; _appliedPromo = null; _promoController.clear(); });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: GlossColors.green, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) setState(() => _selectedDate = picked);
  }

  Future<void> _pickAddress() async {
    final result = await Navigator.push<AddressResult>(
      context,
      MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
    );
    if (result != null && mounted) setState(() => _addressResult = result);
  }

  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: GlossColors.border, borderRadius: BorderRadius.circular(2))),
            const Text("To'lov usulini tanlang", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
            const SizedBox(height: 16),
            _paymentOption('Naqt', Icons.money_rounded, "To'lovni naqd pulda amalga oshiring"),
            const SizedBox(height: 8),
            _paymentOption('Plastik karta', Icons.credit_card_rounded, 'Visa, Mastercard, UzCard'),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(String name, IconData icon, String desc) {
    final selected = _paymentMethod == name;
    return GestureDetector(
      onTap: () { setState(() => _paymentMethod = name); Navigator.pop(context); },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? GlossColors.green.withAlpha(10) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? GlossColors.green : GlossColors.grayLight),
        ),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: GlossColors.green.withAlpha(20), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: GlossColors.green, size: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
                  Text(desc, style: const TextStyle(fontSize: 13, color: GlossColors.hint)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, color: GlossColors.green, size: 24),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime d) {
    return '${d.day}.${d.month}.${d.year}';
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
        title: Text(widget.serviceName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldRow(Icons.calendar_today_rounded, GestureDetector(
                        onTap: _pickDate,
                        child: Row(
                          children: [
                            Text(formatDate(_selectedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: GlossColors.text)),
                            const Spacer(),
                            const Icon(Icons.chevron_right_rounded, color: GlossColors.grayMedium, size: 20),
                          ],
                        ),
                      )),
                      const SizedBox(height: 24),
                      _fieldRow(Icons.access_time_rounded, Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _timeController,
                            keyboardType: TextInputType.datetime,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: GlossColors.text),
                            decoration: const InputDecoration(hintText: 'HH:MM', border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 32,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: quickTimes.length,
                              separatorBuilder: (ctx, i) => const SizedBox(width: 6),
                              itemBuilder: (context, i) {
                                final t = quickTimes[i];
                                final selected = _timeController.text == t;
                                return GestureDetector(
                                  onTap: () => _timeController.text = t,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: selected ? GlossColors.green : GlossColors.bg,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : GlossColors.hint)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 24),
                      _fieldRow(Icons.location_on_rounded, GestureDetector(
                        onTap: _pickAddress,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _addressResult?.address ?? 'Manzilni tanlang',
                                style: TextStyle(fontSize: 15, fontWeight: _addressResult != null ? FontWeight.w600 : FontWeight.w400, color: _addressResult != null ? GlossColors.text : GlossColors.hint),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: GlossColors.grayMedium, size: 20),
                          ],
                        ),
                      )),
                      const SizedBox(height: 24),
                      _fieldRow(Icons.note_add_rounded, TextField(
                        controller: _notesController,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 15, color: GlossColors.text),
                        decoration: const InputDecoration(
                          hintText: "Qo'shimcha ma'lumot...",
                          hintStyle: TextStyle(color: GlossColors.hint, fontSize: 15),
                          border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true,
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Tarifni tanlang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                const SizedBox(height: 14),
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tariffs.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final tariff = _tariffs[i];
                      final selected = i == _selectedTariff;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTariff = i),
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected ? GlossColors.greenText : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tariff['name'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: selected ? Colors.white : GlossColors.text)),
                              const SizedBox(height: 8),
                              Text(tariff['price'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: selected ? Colors.white : GlossColors.greenText)),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.access_time_rounded, size: 14, color: selected ? Colors.white70 : GlossColors.hint),
                                  const SizedBox(width: 4),
                                  Text(tariff['duration'] as String, style: TextStyle(fontSize: 12, color: selected ? Colors.white70 : GlossColors.hint)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                const Text("To'lov", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _showPaymentPicker,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: GlossColors.green.withAlpha(20), borderRadius: BorderRadius.circular(12)),
                          child: Icon(_paymentMethod == 'Naqt' ? Icons.money_rounded : Icons.credit_card_rounded, color: GlossColors.green, size: 24)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("To'lov usuli", style: TextStyle(fontSize: 13, color: GlossColors.hint)),
                              Text(_paymentMethod, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: GlossColors.text)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: GlossColors.grayMedium, size: 22),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Promo kod', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _appliedPromo != null ? GlossColors.green : GlossColors.grayLight),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: TextField(
                          controller: _promoController,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text),
                          decoration: InputDecoration(
                            hintText: 'Kodni kiriting',
                            hintStyle: const TextStyle(color: GlossColors.disabled, fontWeight: FontWeight.w400),
                            border: InputBorder.none,
                            suffixIcon: _appliedPromo != null
                                ? IconButton(icon: const Icon(Icons.close_rounded, size: 18, color: Colors.red), onPressed: _removePromo)
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _appliedPromo == null ? _applyPromo : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _appliedPromo != null ? GlossColors.greenBgPale : GlossColors.green,
                          foregroundColor: _appliedPromo != null ? GlossColors.green : Colors.white,
                          disabledBackgroundColor: GlossColors.disabled,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(_appliedPromo != null ? '$_discountPercent%' : 'Tekshirish', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text('Hisob', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      _priceRow('Xizmat narxi', _tariffs[_selectedTariff]['price'] as String),
                      if (_discountPercent != null) ...[
                        const SizedBox(height: 8),
                        _priceRow('Chegirma ($_discountPercent%)', '-${_rawPrice - _discountedPrice} so\'m', color: GlossColors.red),
                      ],
                      const SizedBox(height: 12),
                      _priceRow('Yetib kelish', 'Bepul'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: GlossColors.divider),
                      ),
                      _priceRow('Jami', '$_discountedPrice so\'m', bold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Buyurtma berish — $_discountedPrice so\'m', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldRow(IconData icon, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.only(top: 2), child: Icon(icon, size: 20, color: GlossColors.green)),
        const SizedBox(width: 14),
        Expanded(child: child),
      ],
    );
  }

  Widget _priceRow(String label, String value, {Color? color, bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: color ?? GlossColors.hint, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        Text(value, style: TextStyle(fontSize: 14, color: color ?? GlossColors.text, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
      ],
    );
  }
}
