import 'package:drift/drift.dart';
import 'app_db.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [SettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);
  
  Stream<SettingsTableData?> watchSettings() {
    return (select(settingsTable)..limit(1)).watchSingleOrNull();
  }
  
  Future<SettingsTableData> ensureSettings() async {
    final existing = await (select(settingsTable)..limit(1)).getSingleOrNull();
    if (existing != null) {
      return existing;
    }
    
    return await into(settingsTable).insertReturning(
      SettingsTableCompanion.insert(),
    );
  }
  
  Future<void> setActivePet(int? petId) async {
    final settings = await ensureSettings();
    await update(settingsTable).replace(
      settings.copyWith(activePetId: Value(petId)),
    );
  }
}

@DriftAccessor(tables: [PetsTable])
class PetsDao extends DatabaseAccessor<AppDatabase> with _$PetsDaoMixin {
  PetsDao(AppDatabase db) : super(db);
  
  Stream<List<PetsTableData>> watchAll() {
    return select(petsTable).watch();
  }
  
  Stream<PetsTableData?> watchById(int id) {
    return (select(petsTable)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }
  
  Future<PetsTableData> createPet({
    required String name,
    int level = 1,
    int xp = 0,
    int coins = 0,
    double hunger = 100.0,
    double energy = 100.0,
    double clean = 100.0,
    double happy = 100.0,
    String skinKey = 'classic',
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return await into(petsTable).insertReturning(
      PetsTableCompanion.insert(
        name: name,
        level: Value(level),
        xp: Value(xp),
        coins: Value(coins),
        hunger: Value(hunger),
        energy: Value(energy),
        clean: Value(clean),
        happy: Value(happy),
        skinKey: Value(skinKey),
        lastUpdatedAtUtcMs: now,
      ),
    );
  }
  
  Future<void> upsertPet(PetsTableData pet) async {
    await update(petsTable).replace(pet);
  }
}

@DriftAccessor(tables: [ItemsTable])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(AppDatabase db) : super(db);
  
  Stream<List<ItemsTableData>> watchItems() {
    return select(itemsTable).watch();
  }
  
  Future<void> seedCatalogIfEmpty() async {
    final existing = await (select(itemsTable)..limit(1)).getSingleOrNull();
    if (existing != null) return;
    
    final items = [
      ItemsTableCompanion.insert(
        id: 'food_basic',
        type: 'food',
        name: 'Basic Food',
        priceCoins: 5,
      ),
      ItemsTableCompanion.insert(
        id: 'soap_basic',
        type: 'soap',
        name: 'Basic Soap',
        priceCoins: 3,
      ),
      ItemsTableCompanion.insert(
        id: 'toy_basic',
        type: 'toy',
        name: 'Basic Toy',
        priceCoins: 10,
      ),
      ItemsTableCompanion.insert(
        id: 'skin_ninja',
        type: 'skin',
        name: 'Ninja Skin',
        priceCoins: 50,
      ),
      ItemsTableCompanion.insert(
        id: 'skin_gold',
        type: 'skin',
        name: 'Gold Skin',
        priceCoins: 100,
      ),
    ];
    
    await batch((batch) {
      batch.insertAll(itemsTable, items);
    });
  }
}

@DriftAccessor(tables: [PetInventoryTable])
class InventoryDao extends DatabaseAccessor<AppDatabase> with _$InventoryDaoMixin {
  InventoryDao(AppDatabase db) : super(db);
  
  Stream<List<PetInventoryTableData>> watchInventory(int petId) {
    return (select(petInventoryTable)..where((t) => t.petId.equals(petId))).watch();
  }
  
  Future<PetInventoryTableData?> getItem(int petId, String itemId) async {
    return await (select(petInventoryTable)
          ..where((t) => t.petId.equals(petId) & t.itemId.equals(itemId)))
        .getSingleOrNull();
  }
  
  Future<void> addQty(int petId, String itemId, int delta) async {
    final existing = await getItem(petId, itemId);
    if (existing != null) {
      final newQty = (existing.qty + delta).clamp(0, 999999);
      await update(petInventoryTable).replace(
        existing.copyWith(qty: newQty),
      );
    } else if (delta > 0) {
      await into(petInventoryTable).insert(
        PetInventoryTableCompanion.insert(
          petId: petId,
          itemId: itemId,
          qty: Value(delta),
        ),
      );
    }
  }
}

