import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:puntoventa/Modelos/Proveedor.dart';

import '../Modelos/Product.dart';

class Cproducto {
  Box<Producto> productos = Hive.box<Producto>('productos');
  Box<Proveedor> proveedores = Hive.box<Proveedor>('proveedores');
  Box categorias = Hive.box('categorias');

  //filtrado de productos por categoria
  List listCategorias(estaBuscando, nombre) {
    if (estaBuscando) {
      return categorias.values
          .where(
              (element) => element.toLowerCase().contains(nombre.toLowerCase()))
          .toList();
    }
    return categorias.values.toList();
  }

  //filtrado de productos por proveedor
  List<Proveedor> listProveedores(estaBuscando, nombre) {
    if (estaBuscando) {
      return proveedores.values
          .where((element) =>
              element.nombre.toLowerCase().contains(nombre.toLowerCase()))
          .toList();
    }
    return proveedores.values.toList();
  }

  //filtrado de productos por nombre o codigo
  List<Producto> listProductos(estaBuscando, nombre) {
    if (estaBuscando) {
      return productos.values
          .where((element) =>
              element.nombre.toLowerCase().contains(nombre.toLowerCase()) ||
              element.codigo.toLowerCase().contains(nombre.toLowerCase()))
          .toList();
    }
    return productos.values.toList();
  }

  //obtener todos los productos por categoria
  List<Producto> ProductosPorCategoria(String categoria) {
    return productos.values
        .where((element) => element.categoria == categoria)
        .toList();
  }

  //obtener todos los productos por proveedor
  List<Producto> ProductosPorProveedor(String proveedor) {
    return productos.values
        .where((element) => element.proveedor == proveedor)
        .toList();
  }

  //obtener el producto por indice
  Producto? ProductoPorIndice(int index) {
    return productos.getAt(index);
  }

  //obtener el producto por codigo
  Producto? ProductoPorCodigo(String codigo) {
    return productos.get(codigo);
  }

  //añadir a la lista de productos por comprar
  bool AnadirProductos(codigo, nombre, precio, categoria, proveedor) {
    //validar que los campos no esten vacios
    if (codigo.text.isEmpty ||
        nombre.text.isEmpty ||
        precio.text.isEmpty ||
        categoria.text.isEmpty ||
        proveedor.text.isEmpty) {
      return false;
    }
    productos.put(
      codigo.text,
      Producto(
        codigo: codigo.text,
        nombre: nombre.text,
        precio: double.parse(precio.text),
        categoria: categoria.text,
        proveedor: proveedor.text,
        cantidad: 0,
        imagen: '',
      ),
    );
    return true;
  }

  //editar el producto
  void EditarProducto(p, id, nombre, precio, categoria, proveedor) {
    p.codigo = id.text;
    p.nombre = nombre.text;
    p.precio = double.parse(precio.text);
    p.categoria = categoria.text;
    p.proveedor = proveedor.text;
    productos.put(p.codigo, p);
  }

  //eliminar el producto
  void EliminarProducto(p) {
    productos.delete(p.codigo);
  }

  //añadir cantidad a un producto
  void AnadirCantidad(p, cantidad) {
    p.cantidad = p.cantidad + cantidad;
    productos.put(p.codigo, p);
  }
}
