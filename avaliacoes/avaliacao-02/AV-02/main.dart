// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
  
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes':
          _dependentes.map((dependente) => dependente.toJson()).toList(),
    };
  }
  
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios':
          _funcionarios.map((funcionario) => funcionario.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  Dependente dependente1 = new Dependente("Pedro Henrique");
  Dependente dependente2 = new Dependente("Mário");
  Dependente dependente3 = new Dependente("João Pedro");
  Dependente dependente4 = new Dependente("Allan");
  Dependente dependente5 = new Dependente("Gabriel");

  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
  Funcionario funcionario1 = new Funcionario("Wladison", [dependente1,dependente3,dependente2]);
  Funcionario funcionario2 = new Funcionario("Pedro Farley", [dependente2,dependente5]);
  Funcionario funcionario3 = new Funcionario("Nicolas", [dependente3]);
  Funcionario funcionario4 = new Funcionario("Gerdeson", [dependente4,dependente5]);
  Funcionario funcionario5 = new Funcionario("Matheus", [dependente5]);
  
  // 4. Criar uma lista de Funcionarios
  var funcList = [funcionario1,funcionario2,funcionario3,funcionario4,funcionario5];
  
  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  var EqProj = EquipeProjeto("Projeto Teste",funcList);
    
  // 6. Printar no formato JSON o objeto Equipe Projeto.
  var printEquipe = jsonEncode(EqProj.toJson());
  print(printEquipe);
}