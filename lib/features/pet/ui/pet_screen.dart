import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/notifs.dart';
import '../../../core/logger.dart';
import '../data/app_db.dart';
import '../model/models.dart';
import '../logic/pet_engine.dart';
import 'widgets/section_card.dart';
import 'widgets/action_button.dart';
import 'widgets/pet_status_card.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  db.itemsDao.seedCatalogIfEmpty();
  return db;
});

final activePetIdProvider = StreamProvider<int?>((ref) async* {
  final db = ref.watch(databaseProvider);
  await db.settingsDao.ensureSettings();
  yield* db.settingsDao.watchSettings().map((s) => s?.activePetId);
});

final activePetProvider = StreamProvider<PetModel?>((ref) async* {
  final activePetId = await ref.watch(activePetIdProvider.future);
  if (activePetId == null) {
    yield null;
    return;
  }
  
  final db = ref.watch(databaseProvider);
  yield* db.petsDao.watchById(activePetId).map((pet) {
    if (pet == null) return null;
    final model = PetModel.fromTable(pet);
    return PetEngine.applyDecay(model);
  });
});

final allPetsProvider = StreamProvider<List<PetModel>>((ref) async* {
  final db = ref.watch(databaseProvider);
  yield* db.petsDao.watchAll().map((pets) {
    return pets.map((p) => PetModel.fromTable(p)).toList();
  });
});

final itemsProvider = StreamProvider<List<ItemsTableData>>((ref) async* {
  final db = ref.watch(databaseProvider);
  yield* db.itemsDao.watchItems();
});

final inventoryProvider = StreamProvider.family<List<PetInventoryTableData>, int>((ref, petId) async* {
  final db = ref.watch(databaseProvider);
  yield* db.inventoryDao.watchInventory(petId);
});

class PetScreen extends ConsumerStatefulWidget {
  const PetScreen({super.key});
  
  @override
  ConsumerState<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends ConsumerState<PetScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyDecayOnStart();
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _applyDecayOnResume();
    }
  }
  
  Future<void> _initializeNotifications() async {
    await NotificationService.initialize();
  }
  
  Future<void> _applyDecayOnStart() async {
    final petAsync = ref.read(activePetProvider);
    petAsync.whenData((pet) async {
      if (pet != null) {
        await _savePet(PetEngine.applyDecay(pet));
        await _checkNotifications(pet);
      }
    });
  }
  
  Future<void> _applyDecayOnResume() async {
    final petAsync = ref.read(activePetProvider);
    petAsync.whenData((pet) async {
      if (pet != null) {
        await _savePet(PetEngine.applyDecay(pet));
        await _checkNotifications(pet);
      }
    });
  }
  
  Future<void> _checkNotifications(PetModel pet) async {
    await NotificationService.checkAndNotify(
      hunger: pet.hunger,
      clean: pet.clean,
    );
  }
  
  Future<void> _savePet(PetModel pet) async {
    final db = ref.read(databaseProvider);
    await db.petsDao.upsertPet(pet.toTable());
  }
  
  Future<void> _performAction(PetModel pet, PetModel Function(PetModel) action) async {
    final updated = action(pet);
    await _savePet(updated);
  }
  
  Future<void> _createPet() async {
    final nameController = TextEditingController();
    if (!mounted) return;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Pet'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Pet Name',
            hintText: 'Enter pet name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty && mounted) {
      final db = ref.read(databaseProvider);
      final pet = await db.petsDao.createPet(name: result);
      await db.settingsDao.setActivePet(pet.id);
      Logger.info('Created pet: ${pet.name}');
    }
  }
  
  Future<void> _useItem(PetModel pet, ItemsTableData item, int qty) async {
    final db = ref.read(databaseProvider);
    final inventory = await db.inventoryDao.getItem(pet.id, item.id);
    if (inventory == null || inventory.qty < qty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough items')),
      );
      return;
    }
    
    PetModel updated = pet;
    switch (item.type) {
      case 'food':
        updated = PetEngine.feed(updated);
        break;
      case 'soap':
        updated = PetEngine.clean(updated);
        break;
      case 'toy':
        updated = PetEngine.play(updated);
        break;
    }
    
    await db.inventoryDao.addQty(pet.id, item.id, -qty);
    await _savePet(updated);
  }
  
  Future<void> _buyItem(PetModel pet, ItemsTableData item) async {
    if (pet.coins < item.priceCoins) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins')),
      );
      return;
    }
    
    final db = ref.read(databaseProvider);
    final updated = pet.copyWith(coins: pet.coins - item.priceCoins);
    await _savePet(updated);
    await db.inventoryDao.addQty(pet.id, item.id, 1);
    
    if (item.type == 'skin') {
      final inventory = await db.inventoryDao.getItem(pet.id, item.id);
      if (inventory != null && inventory.qty > 0) {
        final withSkin = updated.copyWith(skinKey: item.id.replaceAll('skin_', ''));
        await _savePet(withSkin);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final activePetAsync = ref.watch(activePetProvider);
    final allPetsAsync = ref.watch(allPetsProvider);
    final itemsAsync = ref.watch(itemsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Pocket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createPet,
            tooltip: 'Create New Pet',
          ),
        ],
      ),
      body: activePetAsync.when(
        data: (pet) {
          if (pet == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No active pet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createPet,
                    child: const Text('Create Your First Pet'),
                  ),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildPetSelector(allPetsAsync),
                _buildPetStatus(pet),
                _buildActions(pet),
                _buildInventory(pet, itemsAsync),
                _buildShop(pet, itemsAsync),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
  
  Widget _buildPetSelector(AsyncValue<List<PetModel>> allPetsAsync) {
    return allPetsAsync.when(
      data: (pets) {
        if (pets.isEmpty) return const SizedBox.shrink();
        
        return SectionCard(
          title: 'Active Pet',
          child: Consumer(
            builder: (context, ref, _) {
              final activePetIdAsync = ref.watch(activePetIdProvider);
              return activePetIdAsync.when(
                data: (activeId) {
                  return DropdownButtonFormField<int>(
                    initialValue: activeId,
                    items: pets.map((p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name),
                      );
                    }).toList(),
                    onChanged: (id) async {
                      if (id != null && mounted) {
                        final db = ref.read(databaseProvider);
                        await db.settingsDao.setActivePet(id);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error'),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
  
  Widget _buildPetStatus(PetModel pet) {
    final mood = moodFromStats(pet.hunger, pet.energy, pet.clean, pet.happy);
    final nextSkin = EvolutionRules.skinForLevel(pet.level);
    final nextUnlockLabel = (nextSkin == pet.skinKey)
        ? "Next unlock: keep leveling up"
        : "Next unlock: $nextSkin skin (level-based)";

    return SectionCard(
      title: 'Pet Status',
      child: PetStatusCard(
        name: pet.name,
        mood: mood,
        skinKey: pet.skinKey,
        hunger: pet.hunger.toInt(),
        energy: pet.energy.toInt(),
        clean: pet.clean.toInt(),
        happy: pet.happy.toInt(),
        level: pet.level,
        xp: pet.xp,
        xpNeed: pet.xpRequired,
        coins: pet.coins,
        nextUnlockLabel: nextUnlockLabel,
      ),
    );
  }
  
  Widget _buildActions(PetModel pet) {
    return SectionCard(
      title: 'Actions',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          ActionButton(
            label: 'Feed',
            icon: Icons.restaurant,
            onPressed: () => _performAction(pet, PetEngine.feed),
          ),
          ActionButton(
            label: 'Clean',
            icon: Icons.cleaning_services,
            onPressed: () => _performAction(pet, PetEngine.clean),
          ),
          ActionButton(
            label: 'Play',
            icon: Icons.sports_esports,
            onPressed: () => _performAction(pet, PetEngine.play),
            enabled: pet.energy > 15,
          ),
          ActionButton(
            label: 'Sleep',
            icon: Icons.bedtime,
            onPressed: () => _performAction(pet, PetEngine.sleep),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInventory(PetModel pet, AsyncValue<List<ItemsTableData>> itemsAsync) {
    return SectionCard(
      title: 'Inventory',
      child: itemsAsync.when(
        data: (items) {
          return Consumer(
            builder: (context, ref, _) {
              final inventoryAsync = ref.watch(inventoryProvider(pet.id));
              return inventoryAsync.when(
                data: (inventory) {
                  if (inventory.isEmpty) {
                    return const Text('No items in inventory');
                  }
                  
                  return Column(
                    children: inventory.map((inv) {
                      final item = items.firstWhere((i) => i.id == inv.itemId);
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Qty: ${inv.qty}'),
                        trailing: item.type != 'skin'
                            ? TextButton(
                                onPressed: inv.qty > 0
                                    ? () => _useItem(pet, item, 1)
                                    : null,
                                child: const Text('Use'),
                              )
                            : null,
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading inventory'),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text('Error loading items'),
      ),
    );
  }
  
  Widget _buildShop(PetModel pet, AsyncValue<List<ItemsTableData>> itemsAsync) {
    return SectionCard(
      title: 'Shop',
      child: itemsAsync.when(
        data: (items) {
          return Column(
            children: items.map((item) {
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.priceCoins} coins'),
                trailing: ElevatedButton(
                  onPressed: pet.coins >= item.priceCoins
                      ? () => _buyItem(pet, item)
                      : null,
                  child: const Text('Buy'),
                ),
              );
            }).toList(),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text('Error loading shop'),
      ),
    );
  }
}

