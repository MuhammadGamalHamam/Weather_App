import 'package:weather_app/models/weather_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
      return _database;
    }
  }

  initDB() async {
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), "weatherDatabase.db"),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        String query =
            "CREATE TABLE weather(id INT PRIMARY KEY, cityName TEXT, temp FLOAT, tempMax FLOAT, tempMin FLOAT, description TEXT, icon TEXT, lastUpdate INT)";
        return db.execute(query);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  addWeather(WeatherModel weather) async {
    final db = await database;
    // db.execute("INSERT INTO weather(cityName, temp, tempMax, tempMin) VALUES (${weather.cityName}, ${weather.getTemp}, ${weather.getMaxTemp}, ${weather.getMinTemp})")
    db.insert("weather", weather.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<WeatherModel>> getAllWeather() async {
    final db = await database;
    List<Map<String, dynamic>> map = await db.query("weather");
    return List.generate(map.length, (i) {
      return WeatherModel(
          map[i]["id"],
          map[i]["cityName"],
          map[i]["temp"],
          map[i]["tempMax"],
          map[i]["tempMin"],
          map[i]["description"],
          map[i]["icon"],
          map[i]["lastUpdate"]);
    });
  }
}
