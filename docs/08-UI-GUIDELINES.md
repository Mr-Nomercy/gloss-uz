# UI/UX Guidelines — Dizayn qoidalari

Gloss platformasi uchun umumiy dizayn qoidalari va komponentlar.

## 1. Dizayn tizimi

### Asosiy ranglar

| Rang | Kod | Foydalanish |
|------|-----|-------------|
| Primary Green | #00AA13 | Asosiy tugmalar, header, toggle |
| Dark Green | #004A00 | Qorong'i variant |
| Background | #F5F5F5 | Scaffold foni |
| Card | #FFFFFF | Kartochka foni |
| Text Primary | #1A1A1A | Asosiy matn |
| Text Secondary | #757575 | Yordamchi matn |
| Error | #E53935 | Xatolik, bekor qilish |
| Warning | #E65100 | Ogohlantirish |
| Star | #FFB300 | Reyting yulduzlari |

### Gradient

```dart
// Balans kartochkalari uchun
LinearGradient(
  colors: [Color(0xFF00AA13), Color(0xFF007A0E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

### Border radius

| Element | Radius |
|---------|--------|
| Kartochkalar | 12px |
| Tugmalar | 12px |
| Maydonlar | 12px |
| Rasm | 8px |

### Shadow

```dart
BoxShadow(
  color: Colors.black.withOpacity(0.05),
  blurRadius: 10,
  offset: Offset(0, 2),
)
```

## 2. Komponentlar

### GlossButton

```dart
GlossButton(
  label: "Buyurtma berish",      // Tugma matni
  onPressed: () {},              // bosilganda
  isLoading: false,              // loading holati
  isOutlined: false,             // primary yoki outlined
)
```

**Qoidalari:**
- Primary tugma: to'liq kenglik, 52px balandlik, 12px radius
- Loading holatida: CircularProgressIndicator ko'rinadi
- Disabled holatda: opacity 0.5

### GlossCard

```dart
GlossCard(
  child: Text("Ichki kontent"),  // Kontent
  padding: EdgeInsets.all(16),   // Padding (default: 16)
  onTap: () {},                  // optional bosish
)
```

**Qoidalari:**
- Oq fon, 12px radius, 1 elevation
- Barcha kartochkalar bir xil formatda

### GlossTextField

```dart
GlossTextField(
  label: "Telefon raqam",        // Label
  hint: "+998 90 123 45 67",    // Hint
  controller: TextEditingController(),
  obscureText: false,           // Parol uchun
  validator: (value) {},        // Validation
  keyboardType: TextInputType.phone,
)
```

**Qoidalari:**
- Label yuqorida, hint ichida
- Xatolikda: qizil border + xatolik matni

## 3. Navigatsiya

### Bottom Navigation Bar (Seller, Deliver)

```dart
NavigationBar(
  selectedIndex: _currentIndex,
  destinations: [
    NavigationDestination(icon: Icon(Icons.inventory), label: "Mahsulotlar"),
    NavigationDestination(icon: Icon(Icons.shopping_bag), label: "Buyurtmalar"),
    NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
  ],
)
```

### Back button (barcha app'lar)

```dart
// Custom back button — barcha app'larda bir xil
Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Icon(Icons.arrow_back_ios_new, size: 20),
)
```

### AppBar pattern

```dart
AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: _buildBackButton(context),
  title: Text("Sarlavha", style: context.gloss.headlineMedium),
  centerTitle: true,
)
```

## 4. Status badge'lari

### Buyurtma holatlari

| Holat | Rang | Matn |
|-------|------|------|
| Yangi | Yashil (och) | "Yangi" |
| Jarayonda | Orange | "Jarayonda" |
| Yetkazilgan | Yashil | "Yetkazilgan" |
| Bekor qilingan | Qizil | "Bekor qilingan" |
| Faol | Yashil | "Faol" |
| Nofaol | Kulrang | "Nofaol" |

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
    color: statusColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12)),
)
```

## 5. Narx formatlash

```dart
// O'zbekcha formatlash: 25 000 so'm
String formatPrice(double price) {
  final formatted = price.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (int i = 0; i < formatted.length; i++) {
    if (i > 0 && (formatted.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(formatted[i]);
  }
  return '${buffer.toString()} so\'m';
}
```

## 6. Bo'sh holatlar (Empty states)

Har bir bo'sh ekran uchun:
```
┌─────────────────────┐
│                     │
│     [Icon]          │  ← 64x64, kulrang
│                     │
│   "Matn yo'q"       │  ← BodyLarge, kulrang
│                     │
│   [Tugma]           │  ← optional
│                     │
└─────────────────────┘
```

Misol:
- Buyurtmalar: "Buyurtmalar yo'q"
- Bildirishnomalar: "Bildirishnomalar yo'q"
- Sevimlilar: "Sevimlilar bo'sh"
- Manzillar: "Manzillar yo'q"

## 7. Loading holatlari

### Sahifa loading
```dart
Center(
  child: CircularProgressIndicator(
    color: Color(0xFF00AA13),
  ),
)
```

### Tugma loading
```dart
SizedBox(
  width: 20,
  height: 20,
  child: CircularProgressIndicator(
    strokeWidth: 2,
    color: Colors.white,
  ),
)
```

## 8. Dialog pattern

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    title: Text("Sarlavha"),
    content: Text("Matn"),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Bekor qilish"),
      ),
      ElevatedButton(
        onPressed: () {},
        child: Text("Tasdiqlash"),
      ),
    ],
  ),
);
```

## 9. SnackBar pattern

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Xabar matni"),
    backgroundColor: Color(0xFF00AA13),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
```

## 10. Form validation

Barcha formalar uchun:
- Bo'sh maydon: "Maydon to'ldirilishi shart"
- Telefon: "To'g'ri telefon raqamini kiriting"
- Parol: "Kamida 6 ta belgi"
- Narx: "Manfiy bo'lishi mumkin emas"

## 11. Responsive design

| O'lcham |断点 |
|---------|-----|
| Mobile | < 600px |
| Tablet | 600px - 1024px |
| Desktop | > 1024px |

Hozirgi vaqtda faqat mobile qo'llab-quvvatlanadi.
