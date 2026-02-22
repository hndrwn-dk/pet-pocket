import '../data/app_db.dart';

enum PetMood {
  happy,
  idle,
  hungry,
  sleepy,
  dirty,
  sad,
}

String moodLabel(PetMood mood) {
  return switch (mood) {
    PetMood.happy => 'Happy',
    PetMood.idle => 'Idle',
    PetMood.hungry => 'Hungry',
    PetMood.sleepy => 'Sleepy',
    PetMood.dirty => 'Dirty',
    PetMood.sad => 'Sad',
  };
}

PetMood moodFromStats(double hunger, double energy, double clean, double happy) {
  if (hunger < 25) return PetMood.hungry;
  if (clean < 25) return PetMood.dirty;
  if (energy < 20) return PetMood.sleepy;
  if (happy < 25) return PetMood.sad;
  if (happy >= 80) return PetMood.happy;
  return PetMood.idle;
}

class EvolutionRules {
  static String skinForLevel(int level) {
    if (level >= 12) return 'gold';
    if (level >= 7) return 'ninja';
    return 'classic';
  }
}

class PetModel {
  final int id;
  final String name;
  final int level;
  final int xp;
  final int coins;
  final double hunger;
  final double energy;
  final double clean;
  final double happy;
  final String skinKey;
  final int lastUpdatedAtUtcMs;
  
  PetModel({
    required this.id,
    required this.name,
    required this.level,
    required this.xp,
    required this.coins,
    required this.hunger,
    required this.energy,
    required this.clean,
    required this.happy,
    required this.skinKey,
    required this.lastUpdatedAtUtcMs,
  });
  
  factory PetModel.fromTable(PetsTableData data) {
    return PetModel(
      id: data.id,
      name: data.name,
      level: data.level,
      xp: data.xp,
      coins: data.coins,
      hunger: data.hunger,
      energy: data.energy,
      clean: data.clean,
      happy: data.happy,
      skinKey: data.skinKey,
      lastUpdatedAtUtcMs: data.lastUpdatedAtUtcMs,
    );
  }
  
  PetsTableData toTable() {
    return PetsTableData(
      id: id,
      name: name,
      level: level,
      xp: xp,
      coins: coins,
      hunger: hunger,
      energy: energy,
      clean: clean,
      happy: happy,
      skinKey: skinKey,
      lastUpdatedAtUtcMs: lastUpdatedAtUtcMs,
    );
  }
  
  PetModel copyWith({
    int? id,
    String? name,
    int? level,
    int? xp,
    int? coins,
    double? hunger,
    double? energy,
    double? clean,
    double? happy,
    String? skinKey,
    int? lastUpdatedAtUtcMs,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      clean: clean ?? this.clean,
      happy: happy ?? this.happy,
      skinKey: skinKey ?? this.skinKey,
      lastUpdatedAtUtcMs: lastUpdatedAtUtcMs ?? this.lastUpdatedAtUtcMs,
    );
  }
  
  int get xpRequired {
    return 20 + (level * 10);
  }
  
  String get suggestedSkin {
    if (level >= 12) return 'gold';
    if (level >= 7) return 'ninja';
    return 'classic';
  }
  
  String get mood {
    if (happy >= 80) return 'Happy';
    if (happy >= 50) return 'Content';
    if (happy >= 25) return 'Sad';
    return 'Very Sad';
  }
}

