import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:puntoventa/Controlador/Cproducto.dart';
import 'package:puntoventa/Controlador/Scanner.dart';
import 'package:puntoventa/Controlador/preferencias.dart';
import 'package:puntoventa/Modelos/Proveedor.dart';

import 'BuscarCyP.dart';
import 'EditProduct.dart';

class NewAddProducto extends StatefulWidget {
  const NewAddProducto({super.key});

  @override
  State<NewAddProducto> createState() => _NewAddProductoState();
}

class _NewAddProductoState extends State<NewAddProducto> {
  TextEditingController codigo = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController precio = TextEditingController();
  TextEditingController categoria = TextEditingController();
  TextEditingController proveedor = TextEditingController();
  FocusNode nombreF = FocusNode();
  FocusNode precioF = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Añadir Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: codigo,
                    focus: FocusNode(),
                    texto: 'Codigo',
                    onfocus: () => FocusScope.of(context).requestFocus(nombreF),
                    formatos: [],
                    TextInputType: null),
                const SizedBox(width: 10),
                Boton(
                    vista: () {
                      Scanner scanner = Scanner();
                      scanner.scanBarcodeNormal(mounted).then(
                            (value) => {
                              setState(
                                () {
                                  codigo.text = scanner.scanBarcode;
                                },
                              ),
                            },
                          );
                    },
                    icon: const Icon(Icons.barcode_reader)),
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
                    onfocus: () => FocusScope.of(context).requestFocus(precioF),
                    formatos: [],
                    TextInputType: null),
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
                    onfocus: () => FocusScope.of(context).unfocus(),
                    formatos: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    TextInputType: TextInputType.number),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: false,
                    controlador: categoria,
                    focus: null,
                    texto: 'Categoria',
                    onfocus: () {},
                    formatos: [],
                    TextInputType: null),
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
                      ).then(
                        (value) => setState(
                          () {
                            if (value != null) {
                              categoria.text = value;
                            }
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: false,
                    controlador: proveedor,
                    focus: null,
                    texto: 'Proveedor',
                    onfocus: () {},
                    formatos: [],
                    TextInputType: null),
                const SizedBox(width: 10),
                Boton(
                    vista: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ValoresBox(
                              box: Hive.box<Proveedor>('proveedores'),
                              nombre: 'Seleccionar Proveedores',
                            );
                          },
                        ),
                      ).then(
                        (value) => setState(
                          () {
                            if (value != null) {
                              proveedor.text = value;
                            }
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  if (Cproducto().AnadirProductos(
                      codigo, nombre, precio, categoria, proveedor)) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Error al guardar')));
                  }
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Boton extends StatelessWidget {
//   const Boton({
//     super.key,
//     required this.vista,
//     required this.icon,
//   });

//   final Function vista;
//   final Widget icon;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 58,
//       width: 58,
//       child: ElevatedButton(
//         onPressed: () {
//           vista();
//         },
//         child: icon,
//       ),
//     );
//   }
// }

// class Campo extends StatelessWidget {
//   const Campo({
//     super.key,
//     required this.enab,
//     required this.controlador,
//     required this.focus,
//     required this.texto,
//     required this.onfocus,
//     required this.formatos,
//     required this.TextInputType,
//   });

//   final var enab;
//   final var controlador;
//   final var focus;
//   final var texto;
//   final var onfocus;
//   final List<TextInputFormatter> formatos;
//   final var TextInputType;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.only(left: 15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: TextField(
//           keyboardType: TextInputType,
//           inputFormatters: formatos,
//           enabled: enab,
//           controller: controlador,
//           focusNode: focus,
//           onEditingComplete: () {
//             if (focus != null) {
//               onfocus();
//             }
//           },
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             labelText: texto,
//           ),
//         ),
//       ),
//     );
//   }
// }
