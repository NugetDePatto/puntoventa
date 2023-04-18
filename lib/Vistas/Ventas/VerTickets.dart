import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:puntoventa/Controlador/preferencias.dart';

import '../../Modelos/ticket.dart';

class VerTickets extends StatefulWidget {
  const VerTickets({super.key});

  @override
  State<VerTickets> createState() => _VerTicketsState();
}

class _VerTicketsState extends State<VerTickets> {
  late Box<VentaDia> ventas = Hive.box<VentaDia>('ventas');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Ventas por día y hora'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: ventas.length,
                itemBuilder: (context, index) {
                  final VentaDia? ventaDia = ventas.getAt(index);
                  return Column(
                    children: [
                      ListTile(
                        textColor: Colors.white,
                        onLongPress: () {
                          ventas.deleteAt(index);
                          setState(() {});
                        },
                        leading: const Icon(
                          Icons.date_range,
                          color: Colors.white,
                        ),
                        title: Text(
                          ventaDia!.fecha,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        trailing: Text(
                          'Total: \$${ventaDia.totalDia}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (final ticket in ventaDia.tickets)
                        Row(
                          children: [
                            const SizedBox(width: 50.0),
                            Expanded(
                              child: ListTile(
                                textColor: Colors.white,
                                leading: const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  ticket.hora,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                onLongPress: () {
                                  if (ventaDia.tickets.length == 1) {
                                    ventas.deleteAt(index);
                                  } else {
                                    ventaDia.tickets.remove(ticket);
                                    ventas.putAt(index, ventaDia);
                                  }
                                  setState(() {});
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        print(ticket.tickets());
                                        return TicketContainer(ticket: ticket);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketContainer extends StatefulWidget {
  final Ticket? ticket;
  const TicketContainer({super.key, required this.ticket});

  @override
  State<TicketContainer> createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Text('Hora de venta: ${widget.ticket!.hora}'),
              SizedBox(height: 16.0),
              Text('Productos vendidos:'),
              SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: widget.ticket!.productos.length,
                    itemBuilder: (context, index) {
                      final CantidadProducto cp =
                          widget.ticket!.productos[index];
                      return ListTile(
                        title: Text(cp.product.nombre),
                        subtitle: Text('${cp.cantidad} x ${cp.product.precio}'),
                        trailing: Text('${cp.subtotal}'),
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text('Total'),
                trailing: Text('${widget.ticket!.total}'),
              ),
              ListTile(
                title: Text('Efectivo'),
                trailing: Text('${widget.ticket!.efectivo}'),
              ),
              ListTile(
                title: Text('Cambio'),
                trailing: Text('${widget.ticket!.cambio}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
