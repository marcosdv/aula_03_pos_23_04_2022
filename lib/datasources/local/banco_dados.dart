import 'package:aula_03_pos/datasources/local/editora_helper.dart';
import 'package:aula_03_pos/datasources/local/livro_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoDados {
  static const String _nomeBanco = 'meus_livros.db';

  static final BancoDados _intancia = BancoDados.internal();
  factory BancoDados() => _intancia;
  BancoDados.internal();

  Database? _db;

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = await getDatabasesPath();
    final pathDb = join(path, _nomeBanco);

    return await openDatabase(pathDb, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(sqlCreateEditora);
        await db.execute(LivroHelper.sqlCreate);
      }
    );
  }

  void close() async {
    Database meuDb = await db;
    meuDb.close();
  }
}