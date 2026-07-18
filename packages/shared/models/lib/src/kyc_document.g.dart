// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KycDocumentImpl _$$KycDocumentImplFromJson(Map<String, dynamic> json) =>
    _$KycDocumentImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sellerId: json['seller_id'] as String?,
      type: json['type'] as String,
      fileUrl: json['file_url'] as String,
      status: json['status'] as String? ?? 'pending',
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$KycDocumentImplToJson(_$KycDocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'seller_id': instance.sellerId,
      'type': instance.type,
      'file_url': instance.fileUrl,
      'status': instance.status,
      'reviewed_by': instance.reviewedBy,
      'reviewed_at': instance.reviewedAt?.toIso8601String(),
      'rejection_reason': instance.rejectionReason,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
