import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final dbName = 'byahero.db';
  static final dbVersion = 1;
  static final _tableName = 'user';
  static final _tableAutoshop = 'tblautoshop';
  static final _tableGasoline = 'tblgasoline';
  static final _tableMechanic = 'tblmechanic';
  static final _tableAutoshopService = 'tblAutoshopService';
  static final _tableGasService = 'tblGasService';
  static final _tableMechanicService = 'tblMechanicService';

  //------------------------------------ USER DECLARATION---------------------------------------------

  static final userId = 'userid';
  static final username = 'username';
  static final password = 'password';
  static final userType = 'userType';

  //------------------------------------ AUTOSHOP DECLARATION ----------------------------------------

  static final shopId = 'shopId';
  static final shopName = 'shopName';
  static final shopContact = 'shopContact';
  static final shopStartDay = 'shopStartDay';
  static final shopEndDay = 'shopEndDay';
  static final shopStartTime = 'shopStartTime';
  static final shopEndTime = 'shopEndTime';
  static final shopImage = 'shopImage';
  static final shopLatitude = 'shopLatitude';
  static final shopLongitude = 'shopLongitude';
  static final shopAddress = 'shopAddress';
  static final shopDistance = 'shopDistance';

  //------------------------------------ Gasoline DECLARATION ----------------------------------------
  static final gasId = 'gasId';
  static final gasName = 'gasName';
  static final gasContact = 'gasContact';
  static final gasStartDay = 'gasStartDay';
  static final gasEndDay = 'gasEndDay';
  static final gasStartTime = 'gasStartTime';
  static final gasEndTime = 'gasEndTime';
  static final gasImage = 'gasImage';
  static final gasLatitude = 'gasLatitude';
  static final gasLongitude = 'gasLongitude';
  static final gasAddress = 'gasAddress';
  static final gasDistance = 'gasDistance';

  //------------------------------------ MECHANIC DECLARATION ----------------------------------------
  static final mechanicId = 'mechanicId';
  static final mechanicName = 'mechanicName';
  static final mechanicContact = 'mechanicContact';
  static final mechanicStartDay = 'mechanicStartDay';
  static final mechanicEndDay = 'mechanicEndDay';
  static final mechanicStartTime = 'mechanicStartTime';
  static final mechanicEndTime = 'mechanicEndTime';
  static final mechanicImage = 'mechanicImage';
  static final mechanicLatitude = 'mechanicLatitude';
  static final mechanicLongitude = 'mechanicLongitude';
  static final mechanicAddress = 'mechanicAddress';
  static final mechanicDistance = 'mechanicDistance';

  //------------------------------------ AUTOSHOP SERVICE DECLARATION ------------------------------------

  static final shopServiceId = 'shopServiceId';
  static final shopServiceName = 'shopServiceName';
  static final shopServicePrice = 'shopServicePrice';

  //------------------------------------ GASOLINE SERVICE DECLARATION ------------------------------------

  static final gasFuelId = 'gasFuelId';
  static final gasFuelName = 'gasFuelName';
  static final gasFuelPrice = 'gasFuelPrice';

  //------------------------------------ MECHANIC SERVICE DECLARATION ------------------------------------

  static final mechanicServiceId = 'mechanicServiceId';
  static final mechanicServiceName = 'mechanicServiceName';
  static final mechanicServicePrice = 'mechanicServicePrice';

  DatabaseHelper._privateCont();
  static final DatabaseHelper instance = DatabaseHelper._privateCont();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initialDatabase();
    return _database;
  }

  _initialDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    print('db location : ' + path);

    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_tableName(
          $userId TEXT PRIMARY KEY, 
          $username TEXT NOT NULL,
          $password TEXT NOT NULL,
          $userType TEXT NOT NULL
          )
        ''');
    await db.execute('''
        CREATE TABLE $_tableAutoshop(
          $shopId TEXT PRIMARY KEY, 
          $shopName TEXT NOT NULL,
          $shopContact TEXT NOT NULL,
          $shopStartDay TEXT NOT NULL,
          $shopEndDay TEXT NOT NULL,
          $shopStartTime TEXT NOT NULL,
          $shopEndTime TEXT NOT NULL,
          $shopImage TEXT,
          $shopLatitude REAL NOT NULL,
          $shopLongitude REAL NOT NULL,
          $shopAddress TEXT,
          $userId TEXT NOT NULL,
          $shopDistance INT
          )
        ''');
    await db.execute('''
        CREATE TABLE $_tableGasoline(
          $gasId TEXT PRIMARY KEY, 
          $gasName TEXT NOT NULL,
          $gasContact TEXT NOT NULL,
          $gasStartDay TEXT NOT NULL,
          $gasEndDay TEXT NOT NULL,
          $gasStartTime TEXT NOT NULL,
          $gasEndTime TEXT NOT NULL,
          $gasImage TEXT NOT NULL,
          $gasLatitude REAL NOT NULL,
          $gasLongitude REAL NOT NULL,
          $gasAddress TEXT,
          $userId TEXT NOT NULL,
          $gasDistance INT
          )
        ''');
    await db.execute('''
        CREATE TABLE $_tableMechanic(
          $mechanicId TEXT PRIMARY KEY, 
          $mechanicName TEXT NOT NULL,
          $mechanicContact TEXT NOT NULL,
          $mechanicStartDay TEXT NOT NULL,
          $mechanicEndDay TEXT NOT NULL,
          $mechanicStartTime TEXT NOT NULL,
          $mechanicEndTime TEXT NOT NULL,
          $mechanicImage TEXT NOT NULL,
          $mechanicLatitude REAL NOT NULL,
          $mechanicLongitude REAL NOT NULL,
          $mechanicAddress TEXT,
          $userId TEXT NOT NULL,
          $mechanicDistance INT
          )
        ''');
    await db.execute('''
        CREATE TABLE $_tableAutoshopService(
          $shopServiceId TEXT PRIMARY KEY, 
          $shopServiceName TEXT NOT NULL,
          $shopServicePrice TEXT NOT NULL,
          $shopId TEXT NOT NULL
          )
        ''');
    await db.execute('''
        CREATE TABLE $_tableGasService(
          $gasFuelId TEXT PRIMARY KEY, 
          $gasFuelName TEXT NOT NULL,
          $gasFuelPrice TEXT NOT NULL,
          $gasId TEXT NOT NULL
          )
        ''');
    await db.execute('''
        CREATE TABLE $_tableMechanicService(
          $mechanicServiceId TEXT PRIMARY KEY, 
          $mechanicServiceName TEXT NOT NULL,
          $mechanicServicePrice TEXT NOT NULL,
          $mechanicId TEXT  NOT NULL
          )
        ''');
  }

  //------------------------------------ USER DECLARATION---------------------------------------------

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[userId];
    return await db
        .update(_tableName, row, where: '$userId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$userId = ?', whereArgs: [id]);
  }

  Future search(String user, String pass) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableName WHERE $username =? AND $password =?',
        ['$user', '$pass']);

    return result;
  }

  //------------------------------------ AUTOSHOP DECLARATION ----------------------------------------
  Future<int> insertAutoshop(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableAutoshop, row);
  }

  Future<List<Map<String, dynamic>>> queryAllAutoshop() async {
    Database db = await instance.database;
    return await db.query(_tableAutoshop);
  }

  Future searchAutoshop(String userid) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableAutoshop WHERE $userId =?', ['$userid']);

    return result;
  }

  Future updateAutoshop(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[shopId];
    return await db
        .update(_tableAutoshop, row, where: '$shopId = ?', whereArgs: [id]);
  }

  Future sortAutoshop() async {
    Database db = await instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM $_tableAutoshop ORDER BY $shopDistance');

    return result;
  }

  Future<int> deleteAutoshoop(String _shopId) async {
    Database db = await instance.database;
    return await db
        .delete(_tableAutoshop, where: '$shopId = ?', whereArgs: [_shopId]);
  }

  //------------------------------------ GASOLINE DECLARATION ----------------------------------------
  Future<int> insertGasoline(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableGasoline, row);
  }

  Future<List<Map<String, dynamic>>> queryAllGasoline() async {
    Database db = await instance.database;
    return await db.query(_tableGasoline);
  }

  Future updateGasoline(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[gasId];
    return await db
        .update(_tableGasoline, row, where: '$gasId = ?', whereArgs: [id]);
  }

  Future<int> deleteGasoline(String _gasId) async {
    Database db = await instance.database;
    return await db
        .delete(_tableGasoline, where: '$gasId = ?', whereArgs: [_gasId]);
  }

  Future searchGasoline(String _userid) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableGasoline WHERE $userId =?', ['$_userid']);

    return result;
  }

  Future sortGasoline() async {
    Database db = await instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM $_tableGasoline ORDER BY $gasDistance');

    return result;
  }

  //------------------------------------ MECHANIC DECLARATION ----------------------------------------
  Future<int> insertMechanic(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableMechanic, row);
  }

  Future<List<Map<String, dynamic>>> queryAllMechanic() async {
    Database db = await instance.database;
    return await db.query(_tableMechanic);
  }

  Future updateMechanic(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[mechanicId];
    return await db
        .update(_tableMechanic, row, where: '$mechanicId = ?', whereArgs: [id]);
  }

  Future<int> deleteMechanic(String _mechanicId) async {
    Database db = await instance.database;
    return await db.delete(_tableMechanic,
        where: '$mechanicId = ?', whereArgs: [_mechanicId]);
  }

  Future searchMechanic(String userid) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableMechanic WHERE $userId =?', ['$userid']);

    return result;
  }

  Future sortMechanic() async {
    Database db = await instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM $_tableMechanic ORDER BY $mechanicDistance');

    return result;
  }

  //------------------------------------ FROM LIST DECLARATION ----------------------------------------
  Future shopFromList(String _shopId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableAutoshop WHERE $shopId =?', ['$_shopId']);

    return result;
  }

  Future gasFromList(String _gasId) async {
    Database db = await instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM $_tableGasoline WHERE $gasId =?', ['$_gasId']);

    return result;
  }

  Future mechanicFromList(String _mechanicId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableMechanic WHERE $mechanicId =?', ['$_mechanicId']);

    return result;
  }

  //------------------------------------ AUTOSHOP SERVICE ----------------------------------------

  Future<int> shopInsertService(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableAutoshopService, row);
  }

  Future<int> deleteShopService(String _shopId) async {
    Database db = await instance.database;
    return await db.delete(_tableAutoshopService,
        where: '$shopId = ?', whereArgs: [_shopId]);
  }

  Future searchAutoshopService(String _shopId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableAutoshopService WHERE $shopId =?', ['$_shopId']);

    return result;
  }

  //------------------------------------ GASOLINE SERVICE ----------------------------------------

  Future gasFuel(String _gasId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableGasService WHERE $gasId =?', ['$_gasId']);

    return result;
  }

  Future<int> gasInsertService(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableGasService, row);
  }

  Future searchGasService(String _gasId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableGasService WHERE $gasId =?', ['$_gasId']);

    return result;
  }

  Future<int> deleteGasService(String _gasId) async {
    Database db = await instance.database;
    return await db
        .delete(_tableGasService, where: '$gasId = ?', whereArgs: [_gasId]);
  }

  //------------------------------------ MECHANIC SERVICE ----------------------------------------

  Future mechanicService(String _mechanicId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableMechanicService WHERE $mechanicId =?',
        ['$_mechanicId']);

    return result;
  }

  Future<int> mechanicInsertService(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableMechanicService, row);
  }

  Future<int> deleteMechanicService(String _mechanicId) async {
    Database db = await instance.database;
    return await db.delete(_tableMechanicService,
        where: '$mechanicId = ?', whereArgs: [_mechanicId]);
  }

  Future searchMechanicService(String _mechanicId) async {
    Database db = await instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM $_tableMechanicService WHERE $mechanicId =?',
        ['$_mechanicId']);

    return result;
  }
}
