import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'daos.dart';

part 'app_db.g.dart';

class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn? get activePetId => integer().nullable()();
}

class PetsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  RealColumn get hunger => real().withDefault(const Constant(100.0))();
  RealColumn get energy => real().withDefault(const Constant(100.0))();
  RealColumn get clean => real().withDefault(const Constant(100.0))();
  RealColumn get happy => real().withDefault(const Constant(100.0))();
  TextColumn get skinKey => text().withDefault(const Constant('classic'))();
  IntColumn get lastUpdatedAtUtcMs => integer()();
}

class ItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  IntColumn get priceCoins => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class PetInventoryTable extends Table {
  IntColumn get petId => integer()();
  TextColumn get itemId => text()();
  IntColumn get qty => integer().withDefault(const Constant(0))();
  
  @override
  Set<Column> get primaryKey => {petId, itemId};
}

@DriftDatabase(tables: [SettingsTable, PetsTable, ItemsTable, PetInventoryTable], daos: [SettingsDao, PetsDao, ItemsDao, InventoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pet_pocket.db'));
    return NativeDatabase(file);
  });
}

