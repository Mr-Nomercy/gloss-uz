# Mobile App Crash Rate Runbook

## Overview
Handles spikes in mobile app crash rates across Client, Provider, Courier, and Seller apps.

## Alert Thresholds
- **Warning**: Crash-free users < 99.5% for 10 min
- **Critical**: Crash-free users < 99% or > 50 crashes/min
- **Page**: Crash-free users < 95% or new crash type > 10/min

## Quick Diagnostics (0-2 minutes)

```bash
# Check Sentry for recent crashes
# Visit: https://sentry.gloss.uz/gloss/<app>/issues/

# Check Crashlytics (if configured)
# Firebase Console > Crashlytics > Crash-free users

# Check Play Console / App Store Connect
# Pre-launch reports, crash reports
```

## Common Issues & Resolutions

### 1. New Release Regression
**Symptoms**: Crash spike immediately after deploy
**Causes**: 
- New code path with unhandled exception
- Dependency version conflict
- Native module issue (iOS/Android)

**Resolution**:
```bash
# 1. Check recent releases
kubectl rollout history deployment/gloss-client-app -n gloss-prod

# 2. Rollback if recent deploy
flutter build apk --release
# Or rollback via Play Console / App Store Connect

# 2. Check crash grouping in Sentry
# Filter by release version, platform, device

# 3. Check native crashes (Android NDK / iOS)
# Sentry > Issues > Filter: "type: native"

# 4. Hotfix cycle
# - Fix bug
# - Build hotfix
# - Fast-track review (Play Store / TestFlight)
```

### 2. OOM (Out of Memory) Crashes
**Symptoms**: `OutOfMemoryError`, `OOMKilled`, silent app kills
**Causes**:
- Memory leaks (listeners not removed, large images cached)
- Large image processing
- Memory fragmentation

**Resolution**:
```bash
# Check device distribution
# Sentry > Crash > Filter: "type: oom" or "reason: oom"

# Check memory usage patterns
# - Large image loading (use cached_network_image with size limits)
# - ListView without ListView.builder
# - Unclosed streams/listeners
# - Large video/audio in memory

# Mitigation
# - Add `dispose()` for all controllers
# - Use `Image.memory` with decode limits
# - Implement `AutomaticKeepAliveClientMixin` carefully
```

### 3. Network/Timeout Crashes
**Symptoms**: `SocketException`, `TimeoutException`, `HttpException`
**Causes**:
- Backend API down/slow
- Network switching (WiFi -> Cellular)
- Certificate pinning failure

**Resolution**:
```bash
# Check API health
curl -s https://api.gloss.uz/api/v1/health

# Check certificate pinning
# monitor-dashboard.sh --open --env=production
# Check Sentry for "Certificate pinning" errors

# Check network switching handling
# App should retry with exponential backoff
# Implement connectivity_plus listener
```

### 4. Native Module Crashes
**Symptoms**: Crash in `libflutter.so`, `libmain.so`, platform channel errors
**Causes**:
- Plugin version mismatch
- Native code bug (Kotlin/Swift/Objective-C)
- Android/iOS version incompatibility

**Resolution**:
```bash
# Check Flutter version vs plugin compatibility
flutter doctor -v

# Check plugin versions in pubspec.yaml
# Update problematic plugins

# For iOS: Check Xcode crash logs
# Xcode > Devices > View Device Logs

# For Android: Check logcat
adb logcat | grep -i crash
```

### 5. Uncaught Dart Exceptions
**Symptoms**: `UnhandledException`, `AssertionError`, `TypeError`
**Resolution**:
```dart
// Add global error handler in main.dart
void main() {
  FlutterError.onError = (details) {
    Sentry.captureException(details.exception, stackTrace: details.stack);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    Sentry.captureException(error, stackTrace: stack);
    return true;
  };
  
  runApp(MyApp());
}

// Wrap async code
Future<void> safeAsync(Function fn) async {
  try { await fn(); } 
  catch (e, s) { Sentry.captureException(e, stackTrace: s); }
}
```

## Platform-Specific

### Android
```bash
# Check ANR (Application Not Responding)
# Play Console > Android Vitals > ANR rate

# Check native crashes
# Play Console > Android Vitals > Crash rate > Native

# Check by device/OS version
# Sentry > Issues > Filter: "os: Android" + "version: 14"
```

### iOS
```bash
# Check crash rate
# App Store Connect > App Analytics > Crashes

# Check by iOS version
# Sentry > Issues > Filter: "os: iOS" + "version: 17.x"

# Check symbols
# Upload dSYM to Sentry automatically in CI/CD
```

## Recovery Actions

### Immediate (0-5 min)
1. Check Sentry for new crash groups
2. Identify if regression from recent release
3. If regression: rollback release immediately

### Short-term (5-30 min)
1. Hotfix if simple fix
2. Disable feature flag if feature-caused
3. Communicate to users via in-app banner

### Long-term (30+ min)
1. Root cause analysis
2. Fix & test thoroughly
4. Staged rollout (1% -> 10% -> 100%)
5. Monitor crash-free users

## Prevention

### Pre-Launch
- Run `flutter test` + integration tests
- Run `flutter drive` / Patrol tests
- Test on low-end devices
- Test network conditions (slow, offline, switching)

### Post-Launch Monitoring
- Sentry alerts for new crash groups
- Crashlytics daily digest
- Play Console / App Store Connect alerts

---

**Last Updated**: 2024-01-15  
**Owner**: Mobile Team  
**Next Review**: 2024-04-15