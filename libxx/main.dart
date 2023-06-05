import 'package:flutter/material.dart';
import 'funcpessoa.dart';
import 'pop.dart';

void mainx() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Principal());
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Listagem(),
    );
  }
}

class Listagem extends StatefulWidget {
  const Listagem({super.key});

  @override
  State<Listagem> createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  funcoes banco = funcoes();
  var lista;

  @override
  void initState() {
    super.initState();
    lista = inicializar();
  }

  inicializar() async {
    return await banco.Listar();
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async {
          await callPop(
              context, ActionScreen.editar, 'Editar', lista[index].id);
        },
        child: ListTile(
          title: Text(lista[index].nome + " " + lista[index].sobrenome),
        ),
      ),
    );
  }

  Future<void> callPop(
      BuildContext context, ActionScreen actions, String nome, int id) {
    return telaPop(context, actions, nome, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      callPop(context, ActionScreen.salvar, 'Adicionar', -1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Add'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder(
              future: lista,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  lista = snapshot.data;
                  return ListView.builder(
                    itemBuilder: itemBuilder,
                    itemCount: lista.length,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
