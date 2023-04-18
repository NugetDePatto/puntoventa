import 'dart:collection';

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Producto {
  @HiveField(0)
  String codigo = '';
  @HiveField(1)
  String nombre = '';
  @HiveField(2)
  double precio = 0.0;
  @HiveField(3)
  String categoria = 'default';
  @HiveField(4)
  String proveedor = 'default';
  @HiveField(5)
  String imagen = '';
  @HiveField(6)
  int cantidad = 0;

  Producto({
    required this.codigo,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.categoria,
    required this.proveedor,
    required this.cantidad,
  });

  @override
  String toString() =>
      'Producto(codigo: $codigo, nombre: $nombre, precio: $precio, categoria: $categoria, proveedor: $proveedor, imagen: $imagen)';
}

class ProductoAdapter extends TypeAdapter<Producto> {
  @override
  Producto read(BinaryReader reader) {
    return Producto(
      codigo: reader.read(),
      nombre: reader.read(),
      precio: reader.read(),
      categoria: reader.read(),
      proveedor: reader.read(),
      imagen: reader.read(),
      cantidad: reader.read(),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Producto obj) {
    writer.write(obj.codigo);
    writer.write(obj.nombre);
    writer.write(obj.precio);
    writer.write(obj.categoria);
    writer.write(obj.proveedor);
    writer.write(obj.imagen);
    writer.write(obj.cantidad);
  }
}
