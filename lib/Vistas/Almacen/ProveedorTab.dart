import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Controlador/Cproducto.dart';
import '../../Controlador/Cproveedor.dart';
import '../../Controlador/preferencias.dart';
import '../../Modelos/Proveedor.dart';
import '../Producto/EditProduct.dart';

class ProveedorTab extends StatefulWidget {
  const ProveedorTab({super.key});

  @override
  State<ProveedorTab> createState() => _ProveedorTabState();
}

class _ProveedorTabState extends State<ProveedorTab> {
  Cproducto cproducto = Cproducto();
  var textEditingController = TextEditingController();
  late List<Proveedor> listProveedores = [];
  bool isSearching = false;

  @override
  void initState() {
    listProveedores = cproducto.listProveedores(isSearching, '');
    super.initState();
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
                        onEditingComplete: () {
                          setState(() {
                            isSearching = true;
                            listProveedores = cproducto.listProveedores(
                                isSearching, textEditingController.text);
                            FocusScope.of(context).unfocus();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            isSearching = true;
                            listProveedores = cproducto.listProveedores(
                                isSearching, textEditingController.text);
                          });
                        },
                        onTap: () => setState(() {
                          isSearching = true;
                        }),
                        controller: textEditingController,
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
                            listProveedores =
                                cproducto.listProveedores(isSearching, '');
                            textEditingController.clear();
                            FocusScope.of(context).unfocus();
                          });
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            Expanded(
              child: SizedBox(
                child: listProveedores.isEmpty
                    ? const Center(child: Text('No hay Proveedores'))
                    : ListView.builder(
                        itemCount: listProveedores.length,
                        itemBuilder: (context, index) {
                          List cantidadProductos =
                              cproducto.ProductosPorProveedor(
                                  listProveedores[index].nombre);
                          return ListTile(
                            onTap: () {},
                            textColor: Colors.white,
                            title: Text(listProveedores[index].nombre),
                            subtitle: Text(
                                'Cantidad de Productos: ${cantidadProductos.length}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                // Acción a realizar cuando se selecciona una opción
                                switch (value) {
                                  case 'Editar':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return NewEditarProveedor(
                                            proveedor: listProveedores[index],
                                          );
                                        },
                                      ),
                                    ).then(
                                      (value) => setState(
                                        () {
                                          listProveedores = cproducto
                                              .listProveedores(isSearching, '');
                                        },
                                      ),
                                    );
                                    break;
                                  case 'Eliminar':
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Eliminar'),
                                          content: const Text(
                                              '¿Está seguro de eliminar este Proveedor?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Cproveedor().eliminarProveedor(
                                                    listProveedores[index].id);
                                                Navigator.pop(context);
                                                listProveedores =
                                                    cproducto.listProveedores(
                                                        isSearching, '');
                                                setState(() {});
                                              },
                                              child: const Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Editar',
                                    child: Text('Editar'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Eliminar',
                                    child: Text('Eliminar'),
                                  ),
                                ];
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
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
        backgroundColor: Pref().colorBotones,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewAddProovedores(),
            ),
          ).then(
            (value) => setState(
              () {
                listProveedores = cproducto.listProveedores(isSearching, '');
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class NewAddProovedores extends StatelessWidget {
  NewAddProovedores({super.key});

  TextEditingController id = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController direccion = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController rfc = TextEditingController();

  FocusNode nombreFocus = FocusNode();
  FocusNode telefonoFocus = FocusNode();
  FocusNode direccionFocus = FocusNode();
  FocusNode correoFocus = FocusNode();
  FocusNode rfcFocus = FocusNode();

  Future<dynamic> Dialogo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Desea salir sin guardar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Salir'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Seguir editando'),
          ),
        ],
      ),
    );
  }

  void agregar(context) {
    switch (Cproveedor()
        .agregarProveedor(id, nombre, telefono, direccion, correo, rfc)) {
      case 'Existe':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El proveedor ya existe'),
          ),
        );
        Navigator.pop(context);
        break;
      case 'Vacio':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Faltan campos por llenar'),
          ),
        );
        break;
      case 'Agregado':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proveedor agregado'),
          ),
        );
        Navigator.pop(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error desconocido'),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Agregar Proveedor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              agregar(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: id,
                    focus: FocusNode(),
                    texto: 'Identificador',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(nombreFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: nombre,
                    focus: nombreFocus,
                    texto: 'Nombre',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(telefonoFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: telefono,
                    focus: telefonoFocus,
                    texto: 'Telefono',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(direccionFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: direccion,
                    focus: direccionFocus,
                    texto: 'Direccion',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(correoFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: correo,
                    focus: correoFocus,
                    texto: 'Correo',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(rfcFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: rfc,
                    focus: rfcFocus,
                    texto: 'RFC',
                    onfocus: () {
                      FocusScope.of(context).unfocus();
                      agregar(context);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
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

class NewEditarProveedor extends StatefulWidget {
  final Proveedor proveedor;
  NewEditarProveedor({super.key, required this.proveedor});

  @override
  State<NewEditarProveedor> createState() => _NewEditarProveedorState();
}

class _NewEditarProveedorState extends State<NewEditarProveedor> {
  TextEditingController id = TextEditingController();

  TextEditingController nombre = TextEditingController();

  TextEditingController telefono = TextEditingController();

  TextEditingController direccion = TextEditingController();

  TextEditingController correo = TextEditingController();

  TextEditingController rfc = TextEditingController();

  FocusNode nombreFocus = FocusNode();

  FocusNode telefonoFocus = FocusNode();

  FocusNode direccionFocus = FocusNode();

  FocusNode correoFocus = FocusNode();

  FocusNode rfcFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    id.text = widget.proveedor.id;
    nombre.text = widget.proveedor.nombre;
    telefono.text = widget.proveedor.telefono;
    direccion.text = widget.proveedor.direccion;
    correo.text = widget.proveedor.correo;
    rfc.text = widget.proveedor.rfc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Editar Proveedor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              switch (Cproveedor().editarProveedor(
                  id, nombre, telefono, direccion, correo, rfc)) {
                case 'Vacio':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Faltan campos por llenar'),
                    ),
                  );
                  break;
                case 'Editado':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proveedor editado'),
                    ),
                  );
                  Navigator.pop(context);
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error desconocido'),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Campo(
                    enab: false,
                    controlador: id,
                    focus: FocusNode(),
                    texto: 'Identificador',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(nombreFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: nombre,
                    focus: nombreFocus,
                    texto: 'Nombre',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(telefonoFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: telefono,
                    focus: telefonoFocus,
                    texto: 'Telefono',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(direccionFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: direccion,
                    focus: direccionFocus,
                    texto: 'Direccion',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(correoFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: correo,
                    focus: correoFocus,
                    texto: 'Correo',
                    onfocus: () {
                      FocusScope.of(context).requestFocus(rfcFocus);
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Campo(
                    enab: true,
                    controlador: rfc,
                    focus: rfcFocus,
                    texto: 'RFC',
                    onfocus: () {
                      FocusScope.of(context).unfocus();
                    },
                    formatos: [],
                    TextInputType: null),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
