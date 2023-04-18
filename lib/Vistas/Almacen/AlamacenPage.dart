import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/preferencias.dart';
import 'CategoriaTab.dart';
import 'ProductoTab.dart';
import 'ProveedorTab.dart';

class AlmacenPage extends StatefulWidget {
  const AlmacenPage({super.key});

  @override
  State<AlmacenPage> createState() => _AlmacenPageState();
}

class _AlmacenPageState extends State<AlmacenPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Pref().colorBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Inventario'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Productos'),
              Tab(text: 'Proveedores'),
              Tab(text: 'Categorias'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: const [
            CantidadProductosPage(),
            ProveedorTab(),
            CategoriaPage()
          ],
        ),
      ),
    );
  }
}
