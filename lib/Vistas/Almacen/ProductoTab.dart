import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Controlador/Cproducto.dart';
import '../../Controlador/Scanner.dart';
import '../../Controlador/preferencias.dart';
import '../../Modelos/Product.dart';

class CantidadProductosPage extends StatefulWidget {
  const CantidadProductosPage({super.key});

  @override
  State<CantidadProductosPage> createState() => _CantidadProductosPageState();
}

class _CantidadProductosPageState extends State<CantidadProductosPage> {
  Cproducto cproducto = Cproducto();
  TextEditingController controller = TextEditingController();
  late List<Producto> productos;
  var isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productos = cproducto.listProductos(isSearching, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            isSearching = true;
                            productos =
                                cproducto.listProductos(isSearching, value);
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            isSearching = true;
                            productos = cproducto.listProductos(
                                isSearching, controller.text);
                            FocusScope.of(context).unfocus();
                          });
                        },
                        onTap: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        controller: controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Buscar',
                        ),
                      ),
                    ),
                  ),
                ),
                isSearching
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                            controller.clear();
                            FocusScope.of(context).unfocus();
                            productos =
                                cproducto.listProductos(isSearching, '');
                          });
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Scanner scan = Scanner();
                    scan.scanBarcodeNormal(mounted).then(
                      (value) {
                        setState(
                          () {
                            String codigo = scan.scanBarcode;
                            print(codigo);
                            if (codigo != '-1') {
                              Producto? producto =
                                  cproducto.ProductoPorCodigo(codigo);
                              if (producto != null) {
                                print(producto.nombre);
                                BottomSheetCantidad(context, producto)
                                    .then((value) {
                                  setState(() {});
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No se encontro el producto'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Hubo un error al escanear'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.barcode_reader,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    Producto producto = productos[index];

                    return ListTile(
                      textColor: Colors.white,
                      onTap: () {
                        BottomSheetCantidad(context, producto)
                            .then((value) => setState(() {}));
                      },
                      title: Text(producto.nombre),
                      subtitle: Text('Existencias: ${producto.cantidad}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> BottomSheetCantidad(BuildContext context, Producto producto) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        int cantidad = 0;
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              height: 250,
              decoration: BoxDecoration(
                color: Pref().colorBackground,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          producto.nombre,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                        Text(
                          'Existencias: ${producto.cantidad}',
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Pref().colorBotones),
                            ),
                            onPressed: () {
                              if (cantidad > 0) cantidad--;
                              setState(() {});
                            },
                            child: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 30),
                          Text(
                            cantidad.toString(),
                            style: const TextStyle(
                                fontSize: 30, color: Colors.white),
                          ),
                          const SizedBox(width: 30),
                          FilledButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Pref().colorBotones),
                            ),
                            onPressed: () {
                              cantidad++;
                              setState(() {});
                            },
                            child: const Icon(Icons.add),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Pref().colorBotones),
                            ),
                            onPressed: () {
                              cproducto.AnadirCantidad(producto, cantidad);
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: const Text('Agregar'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
