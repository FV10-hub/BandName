import 'dart:io';

import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,
        listen:
            false); //listen false es para que no vuelve a redibujar si hay cambios S
    socketService.socket.on('bandas-activas', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((banda) => Band.fromMap(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bandas-activas');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) =>
                    bandTile(bands[index])),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((banda) {
      dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble());
    });
    final List<Color> colorList = [
      Colors.blue[50],
      Colors.blue[200],
      Colors.pink[50],
      Colors.pink[200],
      Colors.yellow[50],
      Colors.yellow[200],
    ];
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 15,
          centerText: "",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            //legendShape: _BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            decimalPlaces: 0,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
          )),
    );
  }

  Widget bandTile(Band banda) {
    final socketServiceTile =
        Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        socketServiceTile.emit('delete-banda', {'id': banda.id});
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
        onTap: () {
          socketServiceTile.socket.emit('vote-banda', {'id': banda.id});
        },
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
      //this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 19));
      //setState(() {});
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-banda', {'name': name});
    }
    Navigator.pop(context); //para cerrar el dialgo
  }
}
