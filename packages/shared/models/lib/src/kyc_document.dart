import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_document.freezed.dart';
part 'kyc_document.g.dart';

@freezed
class KycDocument with _$KycDocument {
  const factory KycDocument({
    required String id,
    required String userId,
    String? sellerId,
    required String type,
    required String fileUrl,
    @Default('pending') String status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? rejectionReason,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _KycDocument;

  factory KycDocument.fromJson(Map<String, dynamic> json) => _$KycDocumentFromJson(json);
}
