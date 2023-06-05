import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pessoa.dart';

class funcoes {
   chamaBanco() async {
    return openDatabase(
      join(await getDatabasesPath(), "Banco"),
      onCreate: (db, version) {
        return  db.execute("Create Table pessoa (" +
            " id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            " nome TEXT, " +
            " sobrenome TEXT, " +
            " idade INTEGER)");
      },
      version: 1,
    );
  }

  Future<List<Pessoa>> Listar() async {
    final db = await chamaBanco();
    final List<Map<String, dynamic>> resultado = await db.query("pessoa");
    // await db.rawQuery("SELECT * FROM pessoa"); método para pesquisar sql manualmente
    return List.generate(
      resultado.length,
      (index) {
        return Pessoa(
          id: resultado[index]["id"],
          nome: resultado[index]["nome"],
          sobrenome: resultado[index]["sobrenome"],
          idade: resultado[index]["idade"],
        );
      },
    );
  }

  Future<List<Pessoa>> Buscar(String campo, String valor) async {
    final db = await chamaBanco();

    Map<String, String> lista = {
      "id": "id like ?",
      "nome": "nome like ?",
      "sobrenome": "sobrenome like ?",
      "idade": "idade like ?"
    };

    final List<Map<String, dynamic>> resultado = 
    await db.query("pessoa", where: lista[campo], whereArgs: ["%$valor%"]);
    return List.generate(
      resultado.length,
      (index) {
        return Pessoa(
          id: resultado[index]["id"],
          nome: resultado[index]["nome"],
          sobrenome: resultado[index]["sobrenome"],
          idade: resultado[index]["idade"],
        );
      },
    );
  }

  Future<void> Inserir(Pessoa p) async {
    final db = await chamaBanco();
    await db.insert(
      "pessoa",
      p.criarMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> Atualizar(Pessoa p) async {
    final db = await chamaBanco();
    await db.update(
      "pessoa",
      p.criarMap(),
      where: "id = ?",
      whereArgs: [p.id],
    );
  }

  Future<void> Deletar(int id) async {
    final db = await chamaBanco();
    await db.delete(
      "pessoa",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> recriarTabela() async {
    final db = await chamaBanco();
    db.execute("DROP TABLE IF EXISTS pessoa");
    db.execute(
      "Create Table pessoa (" +
          " id INTEGER PRIMARY KEY AUTOINCREMENT, " +
          " nome TEXT, " +
          " sobrenome TEXT, " +
          " idade INTEGER)",
    );
  }

  // await recriarTabela();
  // Pessoa a = Pessoa(id: 1, nome: "João", sobrenome: "Vitor", idade: 24);
  // await Inserir(a);
  // print(await Listar());

  // a = Pessoa(id: 1, nome: "João", sobrenome: "Vitor", idade: 21);
  // await Atualizar(a);
  // print(await listar());

  // await Deletar(1);
  // print(await listar());
}
