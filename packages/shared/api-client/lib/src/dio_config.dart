import 'package:dio/dio.dart';
import 'package:constants/constants.dart';

class DioConfig {
  static Dio create({
    String? accessToken,
    String? refreshToken,
    void Function(String, String)? onTokenRefreshed,
    void Function()? onLogout,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(AuthInterceptor(
      accessToken: accessToken,
      refreshToken: refreshToken,
      onTokenRefreshed: onTokenRefreshed,
      onLogout: onLogout,
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => print('[API] $o'),
    ));

    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  String? _accessToken;
  final String? refreshToken;
  final void Function(String, String)? onTokenRefreshed;
  final void Function()? onLogout;

  AuthInterceptor({
    String? accessToken,
    this.refreshToken,
    this.onTokenRefreshed,
    this.onLogout,
  }) : _accessToken = accessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && refreshToken != null) {
      try {
        final dio = Dio();
        final response = await dio.post(
          'http://localhost:3000/api/v1/auth/refresh' // will be /auth/refresh after removing /api/v1 prefix,
          data: {'refreshToken': refreshToken},
        );
        final newAccess = response.data['accessToken'] as String;
        final newRefresh = response.data['refreshToken'] as String;
        _accessToken = newAccess;
        onTokenRefreshed?.call(newAccess, newRefresh);

        err.requestOptions.headers['Authorization'] = 'Bearer $_accessToken';
        final retry = await Dio(BaseOptions(headers: err.requestOptions.headers))
            .request(err.requestOptions.path, options: Options(
              method: err.requestOptions.method,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            ));
        handler.resolve(retry);
        return;
      } catch (_) {
        onLogout?.call();
      }
    }
    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  RetryInterceptor({this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && (err.requestOptions.extra['retryCount'] ?? 0) < maxRetries) {
      err.requestOptions.extra['retryCount'] = (err.requestOptions.extra['retryCount'] ?? 0) + 1;
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {}
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
