# Contributing to Gloss

## Branch Strategy

We use **GitHub Flow**:

```
main (protected, production-ready)
  ├── feature/<app>-<description>
  ├── fix/<app>-<description>
  ├── refactor/<app>-<description>
  └── chore/<description>
```

### Naming Convention

| Prefix     | Usage                     | Example                          |
|------------|---------------------------|----------------------------------|
| `feature/` | New feature               | `feature/client-booking-screen`  |
| `fix/`     | Bug fix                   | `fix/provider-order-crash`       |
| `refactor/`| Code refactoring          | `refactor/ui-kit-button`         |
| `chore/`   | Config, tooling, deps     | `chore/eslint-upgrade`           |
| `hotfix/`  | Production critical fix   | `hotfix/payment-timeout`         |

## Commit Conventions

We follow **Conventional Commits**:

```
<type>(<scope>): <description>

feat(client): add booking confirmation screen
fix(provider): fix order status timeline
refactor(deliver): extract delivery tile widget
chore(admin): configure eslint flat config
```

### Allowed Types

- `feat` — new feature
- `fix` — bug fix
- `refactor` — code change without functional change
- `chore` — build, tooling, dependencies
- `style` — formatting only
- `docs` — documentation

Scope examples: `client`, `provider`, `deliver`, `seller`, `admin`, `ui-kit`, `backend`

## Pull Request Process

1. Create a feature branch from `main`
2. Make atomic commits with conventional messages
3. Push and open a PR to `main`
4. Fill the PR template completely
5. Ensure CI checks pass (flutter analyze, eslint, tsc)
6. Request review from at least 1 maintainer
7. Squash merge when approved
8. Delete the branch after merge

### PR Title Format

```
<type>(<scope>): <short description>
```

### PR Rules

- No direct pushes to `main`
- PR must have a clear description (what, why, how tested)
- At least 1 approval required
- Stale reviews are dismissed on new commits
- All CI checks must pass

## Branch Protection (main)

The following rules are enforced on `main`:

- ✅ Require pull request before merging
- ✅ Require 1 approval
- ✅ Dismiss stale reviews
- ✅ Require status checks
- ✅ Do not allow bypass

## Code Quality

Before pushing, run:

```bash
# Flutter apps (client, provider, deliver, seller)
flutter analyze

# Admin (React)
npm run lint
npm run build
```
