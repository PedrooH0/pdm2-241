import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Aluno {
  int? id;
  String nome;
  String dataNascimento;
  int? alunoretrivied;

  Aluno({this.id, required this.nome, required this.dataNascimento});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'data_nascimento': dataNascimento,
    };
  }

  @override
  String toString() {
    return 'Aluno{id: $id, nome: $nome, dataNascimento: $dataNascimento}';
  }

}

class AlunoDatabase {
  static final AlunoDatabase instance = AlunoDatabase._init();
  static Database? _database;
  
  AlunoDatabase._init();
  

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('aluno.db');
    return _database!;
  }


  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS TB_ALUNOS (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  data_nascimento TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertAluno(Aluno aluno) async {
    final db = await database;
    return await db.insert('TB_ALUNOS', aluno.toMap());
  }

  Future<Aluno> getAluno(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'TB_ALUNOS',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return Aluno(id: -1, nome: '', dataNascimento: '');
    }

    final Map<String, dynamic> alunoMap = maps.first;

   if (alunoMap.containsKey('id') &&
      alunoMap.containsKey('nome') &&
      alunoMap.containsKey('data_nascimento')) {
    return Aluno(
      id: alunoMap['id'] as int,
      nome: alunoMap['nome'] as String,
      dataNascimento: alunoMap['data_nascimento'] as String,
    );
  } else {
    return Aluno(id: -1, nome: '', dataNascimento: '');
  }
}

  Future<List<Aluno>> getAllAlunos() async {
    final db = await database;
    final maps = await db.query('TB_ALUNOS');

    return List.generate(maps.length, (i) {
      
        final int id = maps[i]['id'] as int;
        final String nome = maps[i]['nome'] as String;
        final String dataNascimento = maps[i]['data_nascimento'] as String;
      
       return Aluno(
      id: id,
      nome: nome,
      dataNascimento: dataNascimento,
    );
    });   
     }

  Future<int> updateAluno(Aluno aluno) async {
    final db = await database;
    return await db.update(
      'TB_ALUNOS',
      aluno.toMap(),
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }

  Future<int> deleteAluno(int id) async {
    final db = await database;
    return await db.delete(
      'TB_ALUNOS',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

void main() async {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  // Inicializar o banco de dados
  final db = AlunoDatabase.instance;

  // Inserir um aluno
  final aluno1 = Aluno(nome: 'Pedro Henrique', dataNascimento: '2006-12-5');
  final aluno2 = Aluno(nome: 'Mario Soares', dataNascimento: '2006-01-5');

  int aluno1Id = await db.insertAluno(aluno1);
  int alunoId2 = await db.insertAluno(aluno2);
  

  // Buscar um aluno pelo ID
  Aluno retrievedAluno = await db.getAluno(aluno1Id);
  if (retrievedAluno == null) {
    print('Aluno não encontrado');
    return;
  }

  print('Aluno recuperado: $retrievedAluno');

  // Atualizar os dados de um aluno
  retrievedAluno.nome == null;
  await db.updateAluno(retrievedAluno);

  // Buscar todos os alunos
  List<Aluno> alunos = await db.getAllAlunos();
  print('Todos os alunos: $alunos.nome');

  // Deletar um aluno
  await db.deleteAluno(aluno1Id);

  print('\n Olá! Nossos nomes são: $alunos.nome');
}