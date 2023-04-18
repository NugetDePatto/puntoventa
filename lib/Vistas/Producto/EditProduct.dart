import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:puntoventa/Controlador/Cproducto.dart';
import 'package:puntoventa/Controlador/preferencias.dart';
import 'package:puntoventa/Modelos/Proveedor.dart';

import '../../Modelos/Product.dart';
import 'BuscarCyP.dart';

class EditProduct extends StatefulWidget {
  final Producto? p;
  const EditProduct({super.key, required this.p});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController? codigo;
  TextEditingController? nombre;
  TextEditingController? precio;
  TextEditingController? categoria;
  TextEditingController? proveedor;

  @override
  void initState() {
    super.initState();
    codigo = TextEditingController(text: widget.p!.codigo);
    nombre = TextEditingController(text: widget.p!.nombre);
    precio = TextEditingController(text: widget.p!.precio.toString());
    categoria = TextEditingController(text: widget.p!.categoria);
    proveedor = TextEditingController(text: widget.p!.proveedor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: codigo,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Codigo',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: precio,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Precio',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: categoria,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Categoria',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Icon(Icons.search)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: proveedor,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Proveedor',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Icon(Icons.search)),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Producto p = Producto(
                //   codigo: codigo!.text,
                //   nombre: nombre!.text,
                //   precio: double.parse(precio!.text),
                //   categoria: categoria!.text,
                //   proveedor: proveedor!.text,
                //   imagen: widget.p!.imagen,
                // );
                widget.p!.codigo = codigo!.text;
                widget.p!.nombre = nombre!.text;
                widget.p!.precio = double.parse(precio!.text);
                widget.p!.categoria = categoria!.text;
                widget.p!.proveedor = proveedor!.text;
                widget.p!.imagen = widget.p!.imagen;

                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewEditarProducto extends StatefulWidget {
  final Producto p;
  const NewEditarProducto({super.key, required this.p});

  @override
  State<NewEditarProducto> createState() => _NewEditarProductoState();
}

class _NewEditarProductoState extends State<NewEditarProducto> {
  TextEditingController codigo = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController precio = TextEditingController();
  TextEditingController categoria = TextEditingController();
  TextEditingController proveedor = TextEditingController();
  FocusNode nombreF = FocusNode();
  FocusNode precioF = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codigo.text = widget.p.codigo;
    nombre.text = widget.p.nombre;
    precio.text = widget.p.precio.toString();
    categoria.text = widget.p.categoria;
    proveedor.text = widget.p.proveedor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Editar Producto'),
        actions: [
          IconButton(
            onPressed: () {
              Cproducto().EditarProducto(
                  widget.p, codigo, nombre, precio, categoria, proveedor);

              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Campo(
                    enab: false,
                    controlador: codigo,
                    focus: FocusNode(),
                    texto: 'Codigo',
                    onfocus: () {},
                    formatos: [],
                    TextInputType: TextInputType.text),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: nombre,
                    focus: nombreF,
                    texto: 'Nombre',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(precioF);
                    },
                    formatos: [],
                    TextInputType: TextInputType.text),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: precio,
                    focus: precioF,
                    texto: 'Precio',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    formatos: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    TextInputType: TextInputType.number),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: categoria,
                    focus: null,
                    texto: 'Categoria',
                    onfocus: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ValoresBox();
                      }));
                    },
                    formatos: [],
                    TextInputType: TextInputType.text),
                const SizedBox(width: 10),
                Boton(
                    vista: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ValoresBox(
                              box: Hive.box('categorias'),
                              nombre: 'Categorias',
                            );
                          },
                        ),
                      ).then((value) => categoria.text = value.toString());
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: proveedor,
                    focus: null,
                    texto: 'Proveedor',
                    onfocus: () {},
                    formatos: [],
                    TextInputType: TextInputType.text),
                const SizedBox(width: 10),
                Boton(
                    vista: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ValoresBox(
                              box: Hive.box<Proveedor>('proveedores'),
                              nombre: 'Proveedores',
                            );
                          },
                        ),
                      ).then((value) => proveedor.text = value.toString());
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class Boton extends StatelessWidget {
  const Boton({
    super.key,
    required this.vista,
    required this.icon,
  });

  final Function vista;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: 58,
      child: ElevatedButton(
        onPressed: () {
          vista();
        },
        child: icon,
      ),
    );
  }
}

class Campo extends StatelessWidget {
  final bool enab;
  final TextEditingController controlador;
  final FocusNode? focus;
  final String texto;
  final Function onfocus;
  final List<TextInputFormatter> formatos;
  final dynamic TextInputType;

  const Campo({
    super.key,
    required this.enab,
    required this.controlador,
    required this.focus,
    required this.texto,
    required this.onfocus,
    required this.formatos,
    required this.TextInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          keyboardType: TextInputType,
          inputFormatters: formatos,
          enabled: enab,
          controller: controlador,
          focusNode: focus,
          onEditingComplete: () {
            if (focus != null) {
              onfocus();
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: texto,
          ),
        ),
      ),
    );
  }
}
