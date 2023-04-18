import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ValoresBox extends StatelessWidget {
  final Box? box;
  final String? nombre;

  const ValoresBox({super.key, this.box, this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombre!),
      ),
      body: ListView.builder(
        itemCount: box!.length,
        itemBuilder: (context, index) {
          String value = '';
          if (nombre!.contains('Categorias')) {
            value = box!.getAt(index).toString();
          } else {
            value = box!.getAt(index).nombre.toString();
          }
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, value);
            },
            child: ListTile(
              title: Text(value),
            ),
          );
        },
      ),
    );
  }
}
