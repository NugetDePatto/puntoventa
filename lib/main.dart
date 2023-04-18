import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puntoventa/Modelos/Proveedor.dart';
import 'Modelos/Product.dart';
import 'Modelos/ticket.dart';
import 'Vistas/HomePage.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFF545058),
    ),
  );
  await initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const NewHomePage(),
    );
  }
}

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProductoAdapter());
  await Hive.openBox<Producto>('productos');

  await Hive.openBox('categorias');

  Hive.registerAdapter(ProveedorAdapter());
  await Hive.openBox<Proveedor>('proveedores');

  Hive.registerAdapter(CantidadProductoAdapter());
  Hive.registerAdapter(TicketAdapter());
  Hive.registerAdapter(VentaDiaAdapter());
  await Hive.openBox<VentaDia>('ventas');
}

  // var c1 = CantidadProducto(
  //   cantidad: 3,
  //   product: Producto(
  //     codigo: '123',
  //     nombre: 'nombre',
  //     precio: 20,
  //     imagen: '',
  //     categoria: 'categoria',
  //     proveedor: 'proveedor',
  //   ),
  // );

  // var c2 = CantidadProducto(
  //   cantidad: 2,
  //   product: Producto(
  //     codigo: '456',
  //     nombre: 'nombre1',
  //     precio: 20,
  //     imagen: '',
  //     categoria: 'categoria',
  //     proveedor: 'proveedor',
  //   ),
  // );

  // var t1 = Ticket(
  //   id: '1',
  //   hora: '09:08PM',
  //   total: 20,
  //   efectivo: 100,
  //   cambio: 80,
  //   productos: [],
  // );

  // var v1 = VentaDia(
  //   fecha: '2021-09-01',
  //   tickets: [],
  // );

  // t1.productos.add(c1);
  // t1.productos.add(c2);

  // v1.tickets.add(t1);

  // venta.put(v1.fecha, v1);

  // // print(venta.get(v1.fecha)!.tickets[0].productos[0].product.nombre);

  // proveedores.put(
  //   'Bimbo',
  //   Proveedor(
  //     id: '111',
  //     nombre: 'Bimbo',
  //     direccion: 'Calle 1',
  //     telefono: '1234567890',
  //     correo: '',
  //     rfc: '',
  //   ),
  // );

  // print(p.get(111));

  // proveedores.add('TekClean');
  // proveedores.add('Pepsi');
  // proveedores.add('Bimbo');
  // proveedores.add('Coca Cola');
  // proveedores.add('Bimbo');

  // proveedores.add(
  //   Proveedor(
  //     id: '1',
  //     nombre: 'TekClean',
  //     direccion: 'Calle 1',
  //     telefono: '1234567890',
  //     correo: '',
  //     rfc: '',
  //   ),
  // );

  // categorias.add('Dulceria');
  // categorias.add('Bebidas');
  // categorias.add('Limpieza');
  // categorias.add('Carnes');
  // categorias.add('Frutas');
  // categorias.add('Verduras');
  // categorias.add('Lacteos');
  // categorias.add('Cereales');
  // categorias.add('Abarrotes');
  // categorias.add('Papeleria');
  // categorias.add('Higiene');
  // categorias.add('Otros');

  // var producto = Producto(
  //   codigo: '7502289450048',
  //   nombre: 'Alcohol Isopropilico',
  //   precio: 110.0,
  //   categoria: 'Sin Categoria',
  //   proveedor: 'TekClean',
  //   imagen: 'https://picsum.photos/1000/1000?random=${Random().nextInt(100)}',
  // );
  // Hive.box<Producto>('productos').put(
  //   '7502289450048',
  //   producto,
  // );

  // var p1 = Producto(
  //   codigo: '7502289450047',
  //   nombre: 'Coca-Cola',
  //   precio: 110.0,
  //   categoria: 'Sin Categoria',
  //   proveedor: 'TekClean',
  //   imagen: 'https://picsum.photos/1000/1000?random=${Random().nextInt(100)}',
  // );

  // var p2 = Producto(
  //   codigo: '7502289450049',
  //   nombre: 'Pepsi',
  //   precio: 110.0,
  //   categoria: 'Sin Categoria',
  //   proveedor: 'TekClean',
  //   imagen: 'https://picsum.photos/1000/1000?random=${Random().nextInt(100)}',
  // );

  // var p3 = Producto(
  //   codigo: '7502289450041',
  //   nombre: 'Fanta',
  //   precio: 110.0,
  //   categoria: 'Sin Categoria',
  //   proveedor: 'TekClean',
  //   imagen: 'https://picsum.photos/1000/1000?random=${Random().nextInt(100)}',
  // );

  // Hive.box<Producto>('productos').putAll({
  //   '7502289450047': p1,
  //   '7502289450049': p2,
  //   '7502289450041': p3,
  // });
// }
