import 'package:aula_03_pos/datasources/local/editora_helper.dart';
import 'package:aula_03_pos/models/editora.dart';
import 'package:aula_03_pos/ui/components/campo_texto.dart';
import 'package:flutter/material.dart';

class CadEditoraPage extends StatefulWidget {
  final Editora? editora;

  const CadEditoraPage({this.editora, Key? key}) : super(key: key);

  @override
  State<CadEditoraPage> createState() => _CadEditoraPageState();
}

class _CadEditoraPageState extends State<CadEditoraPage> {
  final _editoraHelper = EditoraHelper();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editora != null) {
      _nomeController.text = widget.editora!.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Editora'),),
      body: ListView(
        children: [
          CampoTexto(
            controller: _nomeController,
            texto: 'Nome da editora'
          ),
          ElevatedButton(
            onPressed: _salvarEditora,
            child: const Text('Salvar')
          ),
        ],
      ),
    );
  }

  void _salvarEditora() {
    if (widget.editora != null) {
      widget.editora!.nome = _nomeController.text;
      _editoraHelper.alterar(widget.editora!);
    }
    else {
      _editoraHelper.inserir(Editora(nome: _nomeController.text));
    }
    Navigator.pop(context);
  }
}
