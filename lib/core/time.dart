class TimeUtils {
  static int nowUtcMs() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }
  
  static int minutesSince(int utcMs) {
    final now = nowUtcMs();
    final diff = now - utcMs;
    return (diff / (1000 * 60)).floor();
  }
  
  static double minutesSinceDouble(int utcMs) {
    final now = nowUtcMs();
    final diff = now - utcMs;
    return diff / (1000 * 60);
  }
}

