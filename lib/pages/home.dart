import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/pages/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 2),
    Band(id: '2', name: 'Korn', votes: 10),
    Band(id: '3', name: 'Bon Jovi', votes: 8),
    Band(id: '4', name: 'The Beatles', votes: 15),
    Band(id: '5', name: 'Rihana', votes: 6)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) =>
                bandTile(bands[index])),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget bandTile(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => {
        
      },
      background: Container(
        padding: EdgeInsets.all(20),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Eliminar Banda',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.name),
        trailing: Text(
          '${banda.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {},
      ),
    );
  }

  addNewBand() {
    final textEditingController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context:
            context, //el context en StatefullWindget ya esta heredado por eso no hace falta pasar por parametro
        builder: (context) {
          return AlertDialog(
            title: Text('Nueva Banda:'),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addName(textEditingController.text))
            ],
          );
        },
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          //el guion bajo es para no pasarle el contexto que ya esta en el arbol de widgets
          return CupertinoAlertDialog(
            title: Text('Nueva Banda:'),
            content: CupertinoTextField(
              controller: textEditingController,
            ),
            actions: [
              CupertinoDialogAction(
                  child: Text('Add'),
                  isDefaultAction: true,
                  onPressed: () => addName(textEditingController.text)),
              CupertinoDialogAction(
                  child: Text('Cancelar'),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  void addName(String name) {
    if (name.length > 0) {
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 19));
      setState(() {});
    }
    Navigator.pop(context); //para cerrar el dialgo
  }
}
