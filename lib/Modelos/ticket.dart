import 'package:hive/hive.dart';

import 'Product.dart';

@HiveType(typeId: 4)
class CantidadProducto {
  @HiveField(0)
  Producto product;
  @HiveField(1)
  int cantidad;
  CantidadProducto({required this.cantidad, required this.product});

  double get subtotal => product.precio * cantidad;
}

class CantidadProductoAdapter extends TypeAdapter<CantidadProducto> {
  @override
  CantidadProducto read(BinaryReader reader) {
    return CantidadProducto(
      cantidad: reader.read(),
      product: reader.read(),
    );
  }

  @override
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, CantidadProducto obj) {
    writer.write(obj.cantidad);
    writer.write(obj.product);
  }
}

@HiveType(typeId: 3)
class Ticket {
  @HiveField(0)
  String id;
  @HiveField(1)
  String hora;
  @HiveField(2)
  double total;
  @HiveField(3)
  double efectivo;
  @HiveField(4)
  double cambio;
  @HiveField(5)
  List<CantidadProducto> productos;

  Ticket({
    required this.id,
    required this.hora,
    required this.total,
    required this.efectivo,
    required this.cambio,
    required this.productos,
  });

  String tickets() {
    return productos.map((e) => e.product.nombre).join(', ');
  }
}

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  Ticket read(BinaryReader reader) {
    return Ticket(
      id: reader.read(),
      hora: reader.read(),
      total: reader.read(),
      efectivo: reader.read(),
      cambio: reader.read(),
      productos: List<CantidadProducto>.from(reader.read()),
    );
  }

  @override
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, Ticket obj) {
    writer.write(obj.id);
    writer.write(obj.hora);
    writer.write(obj.total);
    writer.write(obj.efectivo);
    writer.write(obj.cambio);
    writer.write(obj.productos);
  }
}

@HiveType(typeId: 2)
class VentaDia {
  @HiveField(0)
  String fecha;
  @HiveField(1)
  List<Ticket> tickets;

  VentaDia({required this.fecha, required this.tickets});

  double get totalDia => tickets.fold(
      0, (previousValue, element) => previousValue + element.total);
}

class VentaDiaAdapter extends TypeAdapter<VentaDia> {
  @override
  VentaDia read(BinaryReader reader) {
    return VentaDia(
      fecha: reader.read(),
      tickets: List<Ticket>.from(reader.read()),
    );
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, VentaDia obj) {
    writer.write(obj.fecha);
    writer.write(obj.tickets);
  }
}
