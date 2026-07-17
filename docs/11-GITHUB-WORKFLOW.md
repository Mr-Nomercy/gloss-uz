# GitHub Workflow Rules — Ish Qoidalari

## Asosiy Qoida: GitHub Flow

```
main branch → branch ochish → PR yaratish → review → squash merge → branch o'chirish
```

**Hech qachon main'ga to'g'ridan-to'g'ri push qilinmaydi.**

---

## 1. Branch Nomi

```bash
# Format: <tur>/<tavsif>
# Tur: feat, fix, docs, refactor, chore

git checkout -b feat/order-flow
git checkout -b fix/auth-logic
git checkout -b docs/project-documentation
```

---

## 2. Ish Jarayoni

### 1-qadam: Branch ochish

```bash
git checkout main
git pull origin main
git checkout -b <tur>/<tavsif>
```

### 2-qadam: O'zgarishlar qilish

```bash
git add -A
git commit -m "feat: qisqa tavsif"
```

### 3-qadam: Push qilish

```bash
git push origin <branch-nomi>
```

### 4-qadam: PR ochish

```bash
gh pr create \
  --repo Mr-Nomercy/gloss-uz \
  --title "feat: qisqa tavsif" \
  --body "Batafsil tavsif" \
  --base main
```

### 5-qadam: Merge qilish

```bash
gh pr merge <PR-number> --repo Mr-Nomercy/gloss-uz --squash --delete-branch
```

---

## 3. Branch Protection (Main)

Main branch himoyalangan:

| Himoya | Holat |
|--------|-------|
| 1 ta tasdiqlash kerak | ✅ |
| Eski review'lar bekor qilinadi | ✅ |
| Linear history majburiy | ✅ |
| Force push taqiqlangan | ✅ |
| Branch o'chirish taqiqlangan | ✅ |
| Adminlar ham himoyalangan | ✅ |

### PR'ni merge qilish (approvalsiz)

Har bir sessionda `.gh_protect.json` yaratish kerak:

```json
{
  "required_status_checks": null,
  "restrictions": null,
  "enforce_admins": true,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "required_approving_review_count": 1
  }
}
```

Keyin:

```bash
# 1. Himoyani vaqtincha o'chirish
gh api repos/Mr-Nomercy/gloss-uz/branches/main/protection --method DELETE

# 2. PR'ni merge qilish
gh pr merge <PR-number> --repo Mr-Nomercy/gloss-uz --squash --delete-branch

# 3. Himoyani qayta yoqish
gh api repos/Mr-Nomercy/gloss-uz/branches/main/protection --method PUT --input .gh_protect.json

# 4. Faylni o'chirish
Remove-Item .gh_protect.json
```

---

## 4. Commit Format

```
<tur>: <tavsif>
```

| Tur | Qachon ishlatiladi |
|-----|-------------------|
| `feat` | Yangi feature |
| `fix` | Xato tuzatish |
| `docs` | Hujjatlar |
| `refactor` | Kodni qayta tuzish (funksiya o'zgarmaydi) |
| `chore` | CI/CD, config, dependency |
| `style` | Formatlash (kod mantiqi o'zgarmaydi) |
| `test` | Test qo'shish/tuzatish |

---

## 5. PR Format

**Title:** `<tur>: <qisqa tavsif>`

**Body:**
```markdown
## Qanday muammo?
<xatolik tavsifi>

## Qanday yechim?
<o'zgarishlar tavsifi>

## Test
<qanday tekshirildi>
```

---

## 6. PowerShell Diqqat

Windows'da PowerShell ishlatiladi:

```bash
# ✅ To'g'ri
gh pr merge 4 --repo Mr-Nomercy/gloss-uz --squash --delete-branch; if ($?) { git pull }

# ❌ Noto'g'ri (PowerShell && qo'llab-quvvatlamaydi)
gh pr merge 4 --repo Mr-Nomercy/gloss-uz --squash --delete-branch && git pull
```

---

## 7. Loyiha Tuzilishi

```
gloss-uz/
├── apps/
│   ├── gloss_client/       # Flutter - Client
│   ├── gloss_admin/        # React - Admin
│   ├── gloss_provider/     # Flutter - Provider
│   ├── gloss_seller/       # Flutter - Seller
│   └── gloss_deliver/      # Flutter - Deliver
├── packages/               # (bo'sh - kelajakda shared code)
├── docs/                   # Hujjatlar
├── melos.yaml              # Monorepo config
├── pubspec.yaml            # Root pubspec
└── .github/workflows/      # CI/CD
```

---

## 8. CI/CD

Har bir PR'da avtomatik tekshiriladi:

| Job | Qanday tekshiriladi |
|-----|---------------------|
| flutter-analyze × 4 | Har bir Flutter app |
| admin-lint | Admin panel ESLint + TypeScript |

**Barcha job'lar o'tishi shart.**

---

## 9. Debug/Logging Qoidalari

```dart
// ✅ Ruxsat etilgan
debugPrint('Order created: ${order.id}');
log('API response: ${response.data}', name: 'API');

// ❌ Taqiqlangan
print('Debug: ...');            // Production'da ko'rinadi
logger.d('Sensitive data');     // Logger aralashmasin
```

---

## 10. Xulosa

1. **Main'ga to'g'ridan push qilish taqiqlangan**
2. **Har bir o'zgarish PR orqali** — branch → PR → review → merge
3. **Squash merge** ishlatiladi — 1 commit = 1 PR
4. **Branch protection** har doim yoqilgan — approvalsiz merge qilish uchun vaqtincha o'chirish kerak
5. **PowerShell** ishlatiladi — `;` chain uchun, `&&` ishlatmang
