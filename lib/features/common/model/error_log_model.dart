class ErrorLogEntry {
  final String username;
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final String userAction;
  final String? errorCode;
  final String errorMessage;
  final String? stackTrace;

  ErrorLogEntry({
    required this.username,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.userAction,
    this.errorCode,
    required this.errorMessage,
    this.stackTrace,
  });

  Map<String, dynamic> toSupabaseJson() => {
    'username': username,
    'device_model': deviceModel,
    'os_version': osVersion,
    'app_version': appVersion,
    'error_code': errorCode,

    'error_details': {
      'user_action': userAction,
      'error_message': errorMessage,
      'stack_trace': stackTrace,
    },
  };
}
