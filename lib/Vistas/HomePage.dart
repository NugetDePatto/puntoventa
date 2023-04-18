import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puntoventa/Vistas/Almacen/AlamacenPage.dart';
import 'package:puntoventa/Vistas/Ventas/VerTickets.dart';
import '../Controlador/preferencias.dart';
import 'Producto/ProductoPage.dart';
import 'Ventas/SellPage.dart';

class NewHomePage extends StatelessWidget {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pref().colorBackground,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BotonInicio(
                  texto: 'Productos',
                  height: 250,
                  image: 'assets/productos.jpg',
                  vista: NewPageProducto(),
                ),
                SizedBox(width: 20),
                BotonInicio(
                  texto: 'Inventario',
                  height: 225,
                  image: 'assets/proveedores.jpg',
                  vista: AlmacenPage(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                BotonInicio(
                  texto: 'Reportes',
                  height: 225,
                  image: 'assets/reportes.jpg',
                  vista: VerTickets(),
                ),
                SizedBox(width: 20),
                BotonInicio(
                  texto: 'Ventas',
                  height: 250,
                  image: 'assets/ventas.jpg',
                  vista: SellPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BotonInicio extends StatelessWidget {
  final String texto;
  final double height;
  final String image;
  final Widget vista;
  const BotonInicio(
      {super.key,
      required this.height,
      required this.image,
      required this.vista,
      required this.texto});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => vista,
            ),
          );
        },
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Pref().colorBotones,
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              opacity: 0.70,
              image: Image.asset(
                image,
                height: 300,
                width: 300,
              ).image,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              texto,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
