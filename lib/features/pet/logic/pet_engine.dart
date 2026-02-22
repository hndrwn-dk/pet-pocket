import '../../../core/constants.dart';
import '../../../core/time.dart';
import '../model/models.dart';

class PetEngine {
  static PetModel applyDecay(PetModel pet) {
    final minutes = TimeUtils.minutesSinceDouble(pet.lastUpdatedAtUtcMs);
    if (minutes <= 0) return pet;
    
    double hunger = pet.hunger + (Constants.hungerDecayPerMin * minutes);
    double energy = pet.energy + (Constants.energyDecayPerMin * minutes);
    double clean = pet.clean + (Constants.cleanDecayPerMin * minutes);
    
    double happyDecay = Constants.happyDecayBaselinePerMin;
    if (hunger < Constants.hungerThreshold ||
        clean < Constants.cleanThreshold ||
        energy < Constants.energyThreshold) {
      happyDecay += Constants.happyDecayExtraPerMin;
    }
    double happy = pet.happy + (happyDecay * minutes);
    
    hunger = hunger.clamp(Constants.minStat, Constants.maxStat);
    energy = energy.clamp(Constants.minStat, Constants.maxStat);
    clean = clean.clamp(Constants.minStat, Constants.maxStat);
    happy = happy.clamp(Constants.minStat, Constants.maxStat);
    
    return pet.copyWith(
      hunger: hunger,
      energy: energy,
      clean: clean,
      happy: happy,
      lastUpdatedAtUtcMs: TimeUtils.nowUtcMs(),
    );
  }
  
  static PetModel feed(PetModel pet) {
    final updated = pet.copyWith(
      hunger: (pet.hunger + Constants.feedHungerGain)
          .clamp(Constants.minStat, Constants.maxStat),
      clean: (pet.clean + Constants.feedCleanLoss)
          .clamp(Constants.minStat, Constants.maxStat),
      xp: pet.xp + Constants.feedXpGain,
      coins: pet.coins + Constants.feedCoinsGain,
      lastUpdatedAtUtcMs: TimeUtils.nowUtcMs(),
    );
    return _checkLevelUp(updated);
  }
  
  static PetModel clean(PetModel pet) {
    final updated = pet.copyWith(
      clean: (pet.clean + Constants.cleanGain)
          .clamp(Constants.minStat, Constants.maxStat),
      xp: pet.xp + Constants.cleanXpGain,
      coins: pet.coins + Constants.cleanCoinsGain,
      lastUpdatedAtUtcMs: TimeUtils.nowUtcMs(),
    );
    return _checkLevelUp(updated);
  }
  
  static PetModel play(PetModel pet) {
    final updated = pet.copyWith(
      happy: (pet.happy + Constants.playHappyGain)
          .clamp(Constants.minStat, Constants.maxStat),
      energy: (pet.energy + Constants.playEnergyLoss)
          .clamp(Constants.minStat, Constants.maxStat),
      hunger: (pet.hunger + Constants.playHungerLoss)
          .clamp(Constants.minStat, Constants.maxStat),
      xp: pet.xp + Constants.playXpGain,
      coins: pet.coins + Constants.playCoinsGain,
      lastUpdatedAtUtcMs: TimeUtils.nowUtcMs(),
    );
    return _checkLevelUp(updated);
  }
  
  static PetModel sleep(PetModel pet) {
    final updated = pet.copyWith(
      energy: (pet.energy + Constants.sleepEnergyGain)
          .clamp(Constants.minStat, Constants.maxStat),
      hunger: (pet.hunger + Constants.sleepHungerLoss)
          .clamp(Constants.minStat, Constants.maxStat),
      xp: pet.xp + Constants.sleepXpGain,
      lastUpdatedAtUtcMs: TimeUtils.nowUtcMs(),
    );
    return _checkLevelUp(updated);
  }
  
  static PetModel _checkLevelUp(PetModel pet) {
    if (pet.xp >= pet.xpRequired) {
      final newLevel = pet.level + 1;
      final remainingXp = pet.xp - pet.xpRequired;
      return pet.copyWith(
        level: newLevel,
        xp: remainingXp,
        happy: (pet.happy + Constants.levelUpHappyGain)
            .clamp(Constants.minStat, Constants.maxStat),
        coins: pet.coins + Constants.levelUpCoinsGain,
      );
    }
    return pet;
  }
}

