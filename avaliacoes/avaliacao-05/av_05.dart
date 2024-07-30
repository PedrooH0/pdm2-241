import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Abrir o banco de dados
  var db = sqlite3.open('examplinho.db');

  // Criar a tabela TB_ALUNO
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  // Função para gravar dados na tabela TB_ALUNO
  void gravarDados() {
    print('Digite o nome do aluno:');
    String? nome = stdin.readLineSync();

    if (nome != null && nome.isNotEmpty) {
      db.execute('INSERT INTO TB_ALUNO (nome) VALUES (?)', [nome]);
      print('Dados gravados com sucesso!');
    } else {
      print('Nome inválido!');
    }
  }

  // Função para ler dados da tabela TB_ALUNO
  void lerDados() {
    var resultados = db.select('SELECT * FROM TB_ALUNO');

    print('Alunos cadastrados:');
    for (var resultado in resultados) {
      print('ID: ${resultado['id']}, Nome: ${resultado['nome']}');
    }
  }

  // Menu principal
  print('Menu:');
  print('1. Gravar dados');
  print('2. Ler dados');
  print('3. Sair');

  int? opcao = int.tryParse(stdin.readLineSync() ?? '');

  if (opcao != null) {
    switch (opcao) {
      case 1:
        gravarDados();
        break;
      case 2:
        lerDados();
        break;
      case 3:
        print('Saindo...');
        break;
      default:
        print('Opção inválida!');
    }
  } else {
    print('Entrada inválida!');
  }

  // Fechar o banco de dados
  db.dispose();
}