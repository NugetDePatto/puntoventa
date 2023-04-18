import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Proveedor {
  @HiveField(0)
  String id = '';
  @HiveField(1)
  String nombre = '';
  @HiveField(2)
  String telefono = '';
  @HiveField(3)
  String direccion = '';
  @HiveField(4)
  String correo = '';
  @HiveField(5)
  String rfc = '';

  Proveedor({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.correo,
    required this.rfc,
  });

  @override
  String toString() {
    return 'Proveedor(id: $id, nombre: $nombre, telefono: $telefono, direccion: $direccion, correo: $correo, rfc: $rfc)';
  }
}

class ProveedorAdapter extends TypeAdapter<Proveedor> {
  @override
  Proveedor read(BinaryReader reader) {
    return Proveedor(
      id: reader.read(),
      nombre: reader.read(),
      telefono: reader.read(),
      direccion: reader.read(),
      correo: reader.read(),
      rfc: reader.read(),
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, Proveedor obj) {
    writer.write(obj.id);
    writer.write(obj.nombre);
    writer.write(obj.telefono);
    writer.write(obj.direccion);
    writer.write(obj.correo);
    writer.write(obj.rfc);
  }
}
