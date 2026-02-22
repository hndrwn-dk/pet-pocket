import 'dart:developer' as developer;

class Logger {
  static void debug(String message) {
    developer.log(message, name: 'PetPocket');
  }
  
  static void info(String message) {
    developer.log(message, name: 'PetPocket', level: 800);
  }
  
  static void warning(String message) {
    developer.log(message, name: 'PetPocket', level: 900);
  }
  
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'PetPocket',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

