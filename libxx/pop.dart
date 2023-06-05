import 'package:flutter/material.dart';
import 'funcpessoa.dart';
import 'main.dart';
import 'pessoa.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
var nomeTela = TextEditingController();
var sobrenomeTela = TextEditingController();
var idadeTela = TextEditingController();
funcoes banco = funcoes();

Pessoa sqlInsert(nomeTela, sobrenomeTela, idadeTela) {
  Pessoa p = Pessoa(
      nome: nomeTela.text,
      sobrenome: sobrenomeTela.text,
      idade: int.parse(idadeTela.text));
  return p;
}

Pessoa sqlEdit(id, nomeTela, sobrenomeTela, idadeTela) {
  Pessoa p = Pessoa(
      id: id,
      nome: nomeTela.text,
      sobrenome: sobrenomeTela.text,
      idade: int.parse(idadeTela.text));
  return p;
}

void limpaControllers() {
  setState() {
    nomeTela.clear();
    sobrenomeTela.clear();
    idadeTela.clear();
  }
}

// void checkData(id) async {
//   final db = await banco.chamaBanco();
//   var resultado = await db.rawQuery("SELECT * FROM pessoa where id = $id");
//   if (resultado.isNotEmpty) {
//     // print(resultado[0]['nome']);
//     setState() {
//       nomeTela.text = resultado[0]['nome'];
//       sobrenomeTela.text = resultado[0]['sobrenome'];
//       idadeTela.text = resultado[0]['idade'];
//     }
//   }
// }

Future<void> telaPop(
    BuildContext context, ActionScreen actions, String msg, int id) async {
  // checkData(id);
  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nomeTela,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter any text";
                    },
                    decoration: const InputDecoration(
                      hintText: "Insira o Nome",
                    ),
                  ),
                  TextFormField(
                    controller: sobrenomeTela,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter any text";
                    },
                    decoration: const InputDecoration(
                      hintText: "Insira o Sobrenome",
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: idadeTela,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter any text";
                    },
                    decoration: const InputDecoration(
                      hintText: "Insira a Idade",
                    ),
                  ),
                ],
              ),
            ),
            title: Text(msg, textAlign: TextAlign.center),
            actions: <Widget>[
              InkWell(
                child: const Text('Deletar'),
                onTap: () {
                  banco.Deletar(id);
                  limpaControllers();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Listagem()),
                  );
                },
              ),
              InkWell(
                child: const Text('Salvar'),
                onTap: () {
                  if (actions == ActionScreen.editar) {
                    banco.Atualizar(
                        sqlEdit(id, nomeTela, sobrenomeTela, idadeTela));
                  } else {
                    banco.Inserir(
                        sqlInsert(nomeTela, sobrenomeTela, idadeTela));
                  }
                  limpaControllers();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Listagem()),
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );
}

enum ActionScreen { salvar, editar, func }
