export const ENCRYPTED_FIELDS = {
  User: [
    'phone',
    'email',
    'fullName',
    'resetOtp',
  ],
  Address: [
    'addressLine',
    'building',
    'entrance',
    'floor',
    'apartment',
    'doorCode',
    'comment',
  ],
  PayoutAccount: [
    'details',
  ],
  KYCDocument: [
    'fileUrl',
  ],
  Payment: [
    'metadata',
  ],
  WalletTransaction: [
    'description',
  ],
  ChatParticipant: [],
  Message: [
    'content',
    'metadata',
  ],
  Notification: [
    'title',
    'body',
    'data',
  ],
} as const;

export const BLIND_INDEX_FIELDS = {
  User: ['phone', 'email'],
  Address: [],
  PayoutAccount: [],
  KYCDocument: [],
  Payment: [],
  WalletTransaction: [],
  ChatParticipant: [],
  Message: [],
  Notification: [],
} as const;

export type EncryptedModel = keyof typeof ENCRYPTED_FIELDS;
export type EncryptedField<M extends EncryptedModel> = (typeof ENCRYPTED_FIELDS)[M][number];