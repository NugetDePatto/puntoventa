import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Controlador/preferencias.dart';
import '../../Modelos/Product.dart';
import 'EditProduct.dart';

class NewVerProductos extends StatefulWidget {
  final Producto? producto;

  const NewVerProductos({super.key, required this.producto});

  @override
  State<NewVerProductos> createState() => _NewVerProductosState();
}

class _NewVerProductosState extends State<NewVerProductos> {
  @override
  Widget build(BuildContext context) {
    Producto p = widget.producto!;
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Pref().colorBotones,
            expandedHeight: 300,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Pref().colorBotones),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return NewEditarProducto(
                                        p: p,
                                      );
                                    },
                                  ),
                                ).then((value) => setState(() {}));
                              },
                              child: const Text('Editar'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Pref().colorBotones),
                              ),
                              onPressed: () {
                                //elimnar producto
                                var box = Hive.box<Producto>('productos');
                                box.delete(widget.producto!.codigo);
                                Navigator.pop(context, box);
                              },
                              child: const Text('Eliminar'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Titulos(
                          titulo: widget.producto!.codigo, subtitulo: 'Código'),
                      const SizedBox(height: 10),
                      Titulos(
                          titulo: widget.producto!.nombre, subtitulo: 'Nombre'),
                      const SizedBox(height: 10),
                      Titulos(
                          titulo: widget.producto!.precio.toString(),
                          subtitulo: 'Precio'),
                      const SizedBox(height: 10),
                      Titulos(
                          titulo: widget.producto!.categoria,
                          subtitulo: 'Categoria'),
                      const SizedBox(height: 10),
                      Titulos(
                          titulo: widget.producto!.proveedor,
                          subtitulo: 'Proveedor'),
                      const SizedBox(height: 10),
                      Titulos(
                          titulo: widget.producto!.cantidad.toString(),
                          subtitulo: 'Cantidad'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Titulos extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  const Titulos({super.key, required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        titulo,
        style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      subtitle: Text(
        subtitulo,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white),
      ),
    );
  }
}
