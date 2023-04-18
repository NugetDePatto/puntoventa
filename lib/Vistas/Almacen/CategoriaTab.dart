import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Controlador/Cproducto.dart';
import '../../Controlador/preferencias.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  Cproducto cproducto = Cproducto();
  var textEditingController = TextEditingController();
  late List listCategorias = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    listCategorias = cproducto.listCategorias(isSearching, '');
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
                            listCategorias = cproducto.listCategorias(
                                isSearching, textEditingController.text);
                            FocusScope.of(context).unfocus();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            isSearching = true;
                            listCategorias = cproducto.listCategorias(
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
                            listCategorias =
                                cproducto.listCategorias(isSearching, '');
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
                child: ListView.builder(
                  itemCount: listCategorias.length,
                  itemBuilder: (context, index) {
                    List cantidadProductos =
                        cproducto.ProductosPorCategoria(listCategorias[index]);
                    return ListTile(
                      textColor: Colors.white,
                      title: Text(listCategorias[index]),
                      subtitle: Text(
                          'Cantidad de Productos: ${cantidadProductos.length}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          // Acción a realizar cuando se selecciona una opción
                          switch (value) {
                            case 'Editar':
                              var controller = TextEditingController(
                                  text: listCategorias[index]);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Editar'),
                                    content: TextField(
                                      autofocus: true,
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nombre de la categoria',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Hive.box('categorias')
                                              .putAt(index, controller.text);
                                          Navigator.pop(context);
                                          listCategorias = cproducto
                                              .listCategorias(isSearching, '');
                                          setState(() {});
                                        },
                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              break;
                            case 'Eliminar':
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar'),
                                    content: const Text(
                                        '¿Está seguro de eliminar esta categoria?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Hive.box('categorias')
                                              .deleteAt(index);
                                          Navigator.pop(context);
                                          listCategorias = cproducto
                                              .listCategorias(isSearching, '');
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
          TextEditingController controller = TextEditingController();
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Agregar Categoria'),
                    content: TextField(
                      autofocus: true,
                      onEditingComplete: () {
                        Hive.box('categorias').add(
                          controller.text,
                        );

                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Categoria',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Hive.box('categorias').add(
                            controller.text,
                          );
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text('Agregar'),
                      ),
                    ],
                  )).then((value) => setState(() {
                listCategorias = cproducto.listCategorias(isSearching, '');
              }));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
