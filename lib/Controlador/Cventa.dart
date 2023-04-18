import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:puntoventa/Modelos/ticket.dart';
import 'package:uuid/uuid.dart';

import '../Modelos/Product.dart';

class Cventa {
  late Box<VentaDia> ventas = Hive.box<VentaDia>('ventas');
  List<CantidadProducto> productos = [];
  double total = 0.00;
  double efectivo = 0.00;
  double get getTotalTicket => total;

  Ticket? ticket;

  get getProductos => productos;

  double getCambio() {
    if (efectivo > total) {
      return efectivo - getTotalTicket;
    } else {
      return 0.00;
    }
  }

  Producto GetProducto(String codigo) {
    return Hive.box<Producto>('productos').get(codigo)!;
  }

  Producto GetProductoByIndex(int index) {
    return productos[index].product;
  }

  String GetCantidadProducto(int index) {
    return productos[index].cantidad.toString();
  }

  String AddProducto(String codigo) {
    Producto producto = GetProducto(codigo);
    if (producto != null) {
      {
        if (productos
            .any((element) => element.product.codigo == producto.codigo)) {
          for (CantidadProducto element in productos) {
            if (element.product.codigo == producto.codigo) {
              if (element.cantidad < producto.cantidad) {
                element.cantidad++;
                print('entro if');
              } else {
                print('entro else');
                return 'No hay suficientes productos';
              }
            }
          }
        } else {
          if (producto.cantidad > 0) {
            productos.add(CantidadProducto(cantidad: 1, product: producto));
            print('entro if 2');
          } else {
            print('entro else 2');
            return 'No hay suficientes productos';
          }
        }

        total += producto.precio;
        return 'Producto agregado';
      }
    }
    return 'Producto no encontrado';
  }

  void RemoveProducto(index) {
    Producto producto = GetProductoByIndex(index);
    if (producto != null) {
      if (productos
          .any((element) => element.product.codigo == producto.codigo)) {
        for (CantidadProducto element in productos) {
          if (element.product.codigo == producto.codigo) {
            if (element.cantidad > 1) {
              element.cantidad--;
            } else {
              productos.remove(element);
            }
            break;
          }
        }
      }

      total -= producto.precio;
    }
  }

  void Clear() {
    productos.clear();
    total = 0;
  }

  void Save(context) {
    Ticket ticket = Ticket(
      id: const Uuid().v4(),
      hora: TimeOfDay.fromDateTime(DateTime.now()).format(context),
      total: total,
      efectivo: efectivo,
      cambio: efectivo - total,
      productos: [...productos],
    );
    this.ticket = ticket;

    final now = DateTime.now();
    final fecha = '${now.day}/${now.month}/${now.year}';

    VentaDia? ventaDia = ventas.get(fecha);
    if (ventaDia != null) {
      print('si existe la fecha $fecha');
      ventaDia.tickets.add(ticket);
    } else {
      ventaDia = VentaDia(
        fecha: fecha,
        tickets: [ticket],
      );
    }

    for (CantidadProducto cantidadProducto in productos) {
      Producto producto = cantidadProducto.product;
      //resta la cantidad de productos vendidos a la cantidad de productos en inventario
      producto.cantidad -= cantidadProducto.cantidad;
      //actualiza la cantidad de productos en inventario
      Hive.box<Producto>('productos').put(producto.codigo, producto);
    }
    ventas.put(fecha, ventaDia);
  }

  void DeleteTicket(String fecha, String id) {
    if (ventas.containsKey(fecha)) {
      ventas.get(fecha)!.tickets.removeWhere((element) => element.id == id);
    }
  }

  void DeleteVentaDia(String fecha) {
    if (ventas.containsKey(fecha)) {
      ventas.delete(fecha);
    }
  }

  List<Ticket> GetTickets(String fecha) {
    if (ventas.containsKey(fecha)) {
      return ventas.get(fecha)!.tickets;
    } else {
      return [];
    }
  }

  double GetTotalDia(String fecha) {
    if (ventas.containsKey(fecha)) {
      return ventas
          .get(fecha)!
          .tickets
          .fold(0, (previousValue, element) => previousValue + element.total);
    } else {
      return 0;
    }
  }

  //aqui se manda el mes en numero
  double GetTotalMes(String mes) {
    double total = 0;
    for (VentaDia venta in ventas.values) {
      if (venta.fecha.contains(mes)) {
        total += venta.tickets
            .fold(0, (previousValue, element) => previousValue + element.total);
      }
    }
    return total;
  }

  //aqui se manda el año en numero
  double GetTotalAnio(String anio) {
    double total = 0;
    for (VentaDia venta in ventas.values) {
      if (venta.fecha.contains(anio)) {
        total += venta.tickets
            .fold(0, (previousValue, element) => previousValue + element.total);
      }
    }
    return total;
  }

  double GetTotal() {
    double total = 0;
    for (VentaDia venta in ventas.values) {
      total += venta.tickets
          .fold(0, (previousValue, element) => previousValue + element.total);
    }
    return total;
  }

  List<VentaDia> GetVentas() {
    return ventas.values.toList();
  }

  List GetFechas() {
    return ventas.keys.toList();
  }

  List GetFechasMes(String mes) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.contains(mes)) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }

  List GetFechasAnio(String anio) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.contains(anio)) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }

  List GetFechasRango(String fecha1, String fecha2) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.compareTo(fecha1) >= 0 && fecha.compareTo(fecha2) <= 0) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }

  List GetFechasRangoMes(String fecha1, String fecha2) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.substring(3).compareTo(fecha1.substring(3)) >= 0 &&
          fecha.substring(3).compareTo(fecha2.substring(3)) <= 0) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }

  List GetFechasRangoAnio(String fecha1, String fecha2) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.substring(6).compareTo(fecha1.substring(6)) >= 0 &&
          fecha.substring(6).compareTo(fecha2.substring(6)) <= 0) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }

  List GetFechasRangoAnioMes(String fecha1, String fecha2) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.substring(6).compareTo(fecha1.substring(6)) >= 0 &&
          fecha.substring(6).compareTo(fecha2.substring(6)) <= 0 &&
          fecha.substring(3, 5).compareTo(fecha1.substring(3, 5)) >= 0 &&
          fecha.substring(3, 5).compareTo(fecha2.substring(3, 5)) <= 0) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }

  List GetFechasRangoAnioMesDia(String fecha1, String fecha2) {
    List fechas = [];
    for (String fecha in ventas.keys) {
      if (fecha.substring(6).compareTo(fecha1.substring(6)) >= 0 &&
          fecha.substring(6).compareTo(fecha2.substring(6)) <= 0 &&
          fecha.substring(3, 5).compareTo(fecha1.substring(3, 5)) >= 0 &&
          fecha.substring(3, 5).compareTo(fecha2.substring(3, 5)) <= 0 &&
          fecha.substring(0, 2).compareTo(fecha1.substring(0, 2)) >= 0 &&
          fecha.substring(0, 2).compareTo(fecha2.substring(0, 2)) <= 0) {
        fechas.add(fecha);
      }
    }
    return fechas;
  }
}
