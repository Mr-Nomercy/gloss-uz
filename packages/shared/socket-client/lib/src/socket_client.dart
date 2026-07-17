class GlossSocketClient {
  static final GlossSocketClient _instance = GlossSocketClient._();
  factory GlossSocketClient() => _instance;
  GlossSocketClient._();

  bool _connected = false;
  String? _serverUrl;

  bool get isConnected => _connected;

  Future<void> connect(String serverUrl, {String? token}) async {
    _serverUrl = serverUrl;
    _connected = true;
  }

  void disconnect() {
    _connected = false;
  }

  void on(String event, Function(dynamic) callback) {}

  void emit(String event, [dynamic data]) {}

  void off(String event) {}
}
