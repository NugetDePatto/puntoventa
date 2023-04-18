import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puntoventa/Controlador/Cproducto.dart';
import 'package:puntoventa/Controlador/Scanner.dart';
import 'package:puntoventa/Controlador/preferencias.dart';

import '../../Modelos/Product.dart';
import 'NewAñadirProducto.dart';
import 'VerProducto.dart';

class NewPageProducto extends StatefulWidget {
  const NewPageProducto({super.key});

  @override
  State<NewPageProducto> createState() => _NewPageProductoState();
}

class _NewPageProductoState extends State<NewPageProducto> {
  Cproducto cproducto = Cproducto();
  TextEditingController controller = TextEditingController();
  bool estaBuscando = false;
  List<Producto> productos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productos = cproducto.listProductos(estaBuscando, '');
  }

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
        padding: const EdgeInsets.all(15.0),
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
                            estaBuscando = true;
                            productos =
                                cproducto.listProductos(estaBuscando, value);
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            estaBuscando = true;
                            productos = cproducto.listProductos(
                                estaBuscando, controller.text);
                            FocusScope.of(context).unfocus();
                          });
                        },
                        onTap: () {
                          setState(() {
                            estaBuscando = true;
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
                estaBuscando
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            estaBuscando = false;
                            controller.clear();
                            FocusScope.of(context).unfocus();
                            productos =
                                cproducto.listProductos(estaBuscando, '');
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
                    Scanner scanner = Scanner();
                    scanner.scanBarcodeNormal(mounted).then(
                          (value) => {
                            setState(
                              () {
                                if (scanner.scanBarcode != '-1') {
                                  var p = cproducto.ProductoPorCodigo(
                                      scanner.scanBarcode);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return NewVerProductos(
                                          producto: p,
                                        );
                                      },
                                    ),
                                  ).then(
                                    (value) => setState(
                                      () {
                                        productos = cproducto.listProductos(
                                            false, controller.text);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
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
                    var p = productos[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NewVerProductos(
                                producto: p,
                              );
                            },
                          ),
                        ).then(
                          (value) => setState(
                            () {
                              productos = cproducto.listProductos(
                                  false, controller.text);
                            },
                          ),
                        );
                      },
                      title: Text(
                        p.nombre,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      subtitle: Text(
                        '${p.proveedor} ${p.categoria}',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      trailing: Text(
                        p.precio.toString(),
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NewAddProducto();
              },
            ),
          ).then((value) => setState(() {
                productos = cproducto.listProductos(false, controller.text);
              }));
        },
        child: const Icon(Icons.add),
        backgroundColor: Pref().colorBotones,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
