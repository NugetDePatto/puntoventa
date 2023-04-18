import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';
import 'package:puntoventa/Controlador/Cventa.dart';
import 'package:puntoventa/Controlador/preferencias.dart';
import 'package:puntoventa/Modelos/Product.dart';
import 'package:puntoventa/Vistas/Ventas/VerTickets.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  Cventa cventa = Cventa();
  String scanBarcode = '';

  TextEditingController efectivoC = TextEditingController();

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes != '-1') {
        AudioPlayer().play(AssetSource("BEEP.mp3"));
      } else {
        AudioPlayer().play(AssetSource("ERROR.mp3"));
      }

      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: TextField(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuscarProducto(),
                      ),
                    ).then((value) {
                      if (value != null) {
                        String result = cventa.AddProducto(value);
                        if (result == 'Producto agregado') {
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                            ),
                          );
                        }

                        setState(() {});
                      }
                      FocusScope.of(context).unfocus();
                    });
                  },
                  controller: TextEditingController(),
                  decoration: const InputDecoration(
                    fillColor: Colors.amber,
                    border: InputBorder.none,
                    hintText: 'Buscar producto',
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: IconButton(
                splashRadius: 10,
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.blue,
                ),
                onPressed: () {
                  scanBarcodeNormal().then((value) {
                    if (scanBarcode != '-1') {
                      String result = cventa.AddProducto(scanBarcode);
                      if (result == 'Producto agregado') {
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result),
                          ),
                        );
                      }
                      setState(() {});
                    }
                  });
                },
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cventa.getProductos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  textColor: Colors.white,
                  leading: Text(
                    '\$ ${cventa.GetProductoByIndex(index).precio}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(cventa.GetProductoByIndex(index).nombre),
                  subtitle: Text(
                      'Codigo: ${cventa.GetProductoByIndex(index).codigo}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          cventa.RemoveProducto(index);
                          setState(() {});
                        },
                      ),
                      Text(cventa.GetCantidadProducto(index),
                          style: const TextStyle(fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          String result = cventa.AddProducto(
                              cventa.GetProductoByIndex(index).codigo);
                          if (result == 'Producto agregado') {
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result),
                              ),
                            );
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Pref().colorBotones,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total: \$ ${cventa.getTotalTicket}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        //ingresar el efectivo
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Efectivo: \$ ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: efectivoC,
                                decoration: const InputDecoration(
                                  focusColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    cventa.efectivo = 0;
                                  } else if (double.parse(value) >=
                                      cventa.getTotalTicket) {
                                    print('entre$value');
                                    cventa.efectivo = double.parse(value);
                                  } else {
                                    cventa.efectivo = 0;
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (cventa.getProductos.isNotEmpty) {
                        if (cventa.efectivo >= cventa.getTotalTicket) {
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 250,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          title: Text('TOTAL:'),
                                          trailing: Text(
                                            '\$ ${cventa.getTotalTicket.toString()}',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('EFECTIVO:'),
                                          trailing: Text(
                                            '\$ ${cventa.efectivo.toString()}',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('CAMBIO:'),
                                          trailing: Text(
                                            '\$ ${(cventa.efectivo - cventa.getTotalTicket).toString()}',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TicketContainer(
                                                      ticket: cventa.ticket,
                                                    ),
                                                  ),
                                                );
                                                cventa.Save(context);
                                                cventa.Clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                setState(() {});
                                              },
                                              child: const Text(
                                                'Aceptar',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Efectivo insuficiente'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No hay productos en la lista'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Pagar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container botonBuscar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        icon: const Icon(
          Icons.search,
        ),
        onPressed: () {},
      ),
    );
  }
}

class BuscarProducto extends StatefulWidget {
  const BuscarProducto({super.key});

  @override
  State<BuscarProducto> createState() => _BuscarProductoState();
}

class _BuscarProductoState extends State<BuscarProducto> {
  Box<Producto> p = Hive.box<Producto>('productos');

  List<Producto> productos = [];

  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: TextField(
                  autofocus: true,
                  onTap: () {},
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    setState(
                      () {
                        if (value.isEmpty) {
                          productos = [];
                        } else {
                          productos = p.values
                              .where((element) =>
                                  element.nombre
                                      .toLowerCase()
                                      .contains(value) ||
                                  element.codigo.toLowerCase().contains(value))
                              .toList();
                        }
                      },
                    );
                  },
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    fillColor: Colors.amber,
                    border: InputBorder.none,
                    hintText: 'Buscar producto',
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: IconButton(
                splashRadius: 25,
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
      body: productos.isEmpty
          ? const Center(
              child: Text('Sin resultados',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            )
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context, productos[index].codigo);
                  },
                  title: Text('Producto: ${productos[index].nombre}'),
                  subtitle: Text('Codigo: ${productos[index].codigo}'),
                );
              },
            ),
    );
  }
}
