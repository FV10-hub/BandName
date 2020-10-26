import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          backgroundColor: Colors.blue,
          onPressed: () {
            socketService.emit('emitir-mensaje',
                {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter kp'});
          }),
    );
  }
}
