class Constants {
  static const String appName = 'Pet Pocket';
  
  // Stat decay rates per minute
  static const double hungerDecayPerMin = -0.10;
  static const double energyDecayPerMin = -0.0833;
  static const double cleanDecayPerMin = -0.0666;
  static const double happyDecayBaselinePerMin = -0.03;
  static const double happyDecayExtraPerMin = -0.05;
  
  // Stat thresholds for extra decay
  static const double hungerThreshold = 25.0;
  static const double cleanThreshold = 25.0;
  static const double energyThreshold = 20.0;
  
  // Action values
  static const double feedHungerGain = 30.0;
  static const double feedCleanLoss = -5.0;
  static const int feedXpGain = 5;
  static const int feedCoinsGain = 2;
  
  static const double cleanGain = 40.0;
  static const int cleanXpGain = 3;
  static const int cleanCoinsGain = 1;
  
  static const double playHappyGain = 25.0;
  static const double playEnergyLoss = -15.0;
  static const double playHungerLoss = -10.0;
  static const int playXpGain = 8;
  static const int playCoinsGain = 3;
  
  static const double sleepEnergyGain = 50.0;
  static const double sleepHungerLoss = -5.0;
  static const int sleepXpGain = 10;
  
  // Progression
  static const int baseXpRequired = 20;
  static const int xpPerLevel = 10;
  static const int levelUpHappyGain = 5;
  static const int levelUpCoinsGain = 5;
  
  // Skin suggestions by level
  static const int ninjaSkinLevel = 7;
  static const int goldSkinLevel = 12;
  
  // Notification thresholds
  static const double hungerNotificationThreshold = 25.0;
  static const double cleanNotificationThreshold = 25.0;
  
  // Stat bounds
  static const double minStat = 0.0;
  static const double maxStat = 100.0;
}

