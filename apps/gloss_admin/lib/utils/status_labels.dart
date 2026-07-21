String orderStatusLabel(String status) {
  return switch (status) {
    'pending' => 'Kutilmoqda',
    'confirmed' => 'Tasdiqlangan',
    'in_progress' => 'Jarayonda',
    'completed' => 'Yakunlangan',
    'cancelled' => 'Bekor qilingan',
    _ => status,
  };
}

String paymentStatusLabel(String status) {
  return switch (status) {
    'paid' => "To'langan",
    'pending' => 'Kutilmoqda',
    'failed' => 'Xatolik',
    'refunded' => 'Qaytarilgan',
    _ => status,
  };
}

String payoutStatusLabel(String status) {
  return switch (status) {
    'pending' => 'Kutilmoqda',
    'approved' => 'Tasdiqlangan',
    'rejected' => 'Rad etilgan',
    _ => status,
  };
}
