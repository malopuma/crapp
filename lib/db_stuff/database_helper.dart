// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coda/db_stuff/crystal_info.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Private constructor to enforce a singleton pattern
  // This ensures that only one instance of DatabaseHelper exists.
  DatabaseHelper._internal();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() {
    return _instance;
  }

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Initializes the database
  Future<Database> _initDatabase() async {
    // Get the default document directory path for the app
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, 'crystal_info_database.db'); // Define your database file name

    // Open the database or create it if it doesn't exist
    return await openDatabase(
      path,
      version: 1, // Database version, crucial for upgrades
      onCreate: _onCreate, // Called when the database is created for the first time
      onUpgrade: _onUpgrade, // Called when the database version changes
    );
  }

  // Method to create the crystal_info table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE crystal_info(
        codId TEXT PRIMARY KEY,
        chemicalName TEXT,
        mineral TEXT,
        spaceGroup TEXT,
        a TEXT,
        b TEXT,
        c TEXT,
        alpha TEXT,
        beta TEXT,
        gamma TEXT,
        title TEXT,
        doi TEXT,
        year TEXT,
        -- New User-Editable Fields
        crystalSystem TEXT,
        solubility TEXT,
        cleavagePlanes TEXT,
        appearance TEXT,
        laueExposureTime REAL -- REAL for double values in SQLite
      )
    ''');
  }

  // Method to handle database upgrades (e.g., adding new columns)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // This is where you would handle schema changes for future versions of your app.
    // For now, we'll keep it simple, but this is critical for app updates.
    // Example: if (oldVersion < 2) { await db.execute("ALTER TABLE crystal_info ADD COLUMN newField TEXT"); }
  }

  // --- CRUD Operations ---

  // Insert a CrystalInfo object into the database
  Future<int> insertCrystalInfo(CrystalInfo crystalInfo) async {
    final db = await database;
    // The conflictAlgorithm is set to replace any existing entry with the same codId.
    return await db.insert(
      'crystal_info',
      crystalInfo.toMap(), // Convert CrystalInfo object to a Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all CrystalInfo objects from the database
  Future<List<CrystalInfo>> getCrystalInfoList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('crystal_info');

    // Convert the List<Map<String, dynamic>> into a List<CrystalInfo>
    return List.generate(maps.length, (i) {
      return CrystalInfo.fromMap(maps[i]); // Use the fromMap factory
    });
  }

  // Update an existing CrystalInfo object
  Future<int> updateCrystalInfo(CrystalInfo crystalInfo) async {
    final db = await database;
    return await db.update(
      'crystal_info',
      crystalInfo.toMap(),
      where: 'codId = ?', // Specify which crystal to update
      whereArgs: [crystalInfo.codId], // Pass the codId for the where clause
    );
  }

  // Delete a CrystalInfo object
  Future<int> deleteCrystalInfo(String codId) async {
    final db = await database;
    return await db.delete(
      'crystal_info',
      where: 'codId = ?',
      whereArgs: [codId],
    );
  }

  // You can also add a method to get a single CrystalInfo by codId
  Future<CrystalInfo?> getCrystalInfoById(String codId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'crystal_info',
      where: 'codId = ?',
      whereArgs: [codId],
      limit: 1, // Only expect one result
    );
    if (maps.isNotEmpty) {
      return CrystalInfo.fromMap(maps.first);
    }
    return null; // Return null if no matching crystal is found
  }
}