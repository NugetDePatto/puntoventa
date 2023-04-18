import 'package:hive/hive.dart';

import '../Modelos/Proveedor.dart';

class Cproveedor {
  Box<Proveedor> proveedorBox = Hive.box<Proveedor>('proveedores');

  String agregarProveedor(id, nombre, telefono, direccion, correo, rfc) {
    if (proveedorBox.containsKey(id.text)) {
      return 'Existe';
    } else if (id.text.isEmpty ||
        nombre.text.isEmpty ||
        telefono.text.isEmpty ||
        direccion.text.isEmpty ||
        correo.text.isEmpty ||
        rfc.text.isEmpty) {
      return 'Vacio';
    }

    proveedorBox.put(
      id.text,
      Proveedor(
        id: id.text,
        nombre: nombre.text,
        telefono: telefono.text,
        direccion: direccion.text,
        correo: correo.text,
        rfc: rfc.text,
      ),
    );
    return 'Agregado';
  }

  String editarProveedor(id, nombre, telefono, direccion, correo, rfc) {
    if (id.text.isEmpty ||
        nombre.text.isEmpty ||
        telefono.text.isEmpty ||
        direccion.text.isEmpty ||
        correo.text.isEmpty ||
        rfc.text.isEmpty) {
      return 'Vacio';
    }

    proveedorBox.put(
      id.text,
      Proveedor(
        id: id.text,
        nombre: nombre.text,
        telefono: telefono.text,
        direccion: direccion.text,
        correo: correo.text,
        rfc: rfc.text,
      ),
    );
    return 'Editado';
  }

  void eliminarProveedor(id) {
    proveedorBox.delete(id);
  }
}
