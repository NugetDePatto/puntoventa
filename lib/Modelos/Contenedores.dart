import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Product.dart';

class Boton extends StatelessWidget {
  final String texto;
  final Color color;
  final void Function() alPresionar;

  const Boton({
    super.key,
    required this.alPresionar,
    required this.texto,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: alPresionar,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text(
              texto,
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CardP extends StatefulWidget {
  final Producto? producto;
  final Function() alPresionar;
  const CardP({super.key, required this.producto, required this.alPresionar});

  @override
  State<CardP> createState() => _CardPState();
}

class _CardPState extends State<CardP> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.alPresionar,
      child: ListTile(
        //leading: Image.network(widget.producto!.imagen),
        title: Text(
          widget.producto!.nombre,
          style: GoogleFonts.spaceGrotesk(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text(widget.producto!.codigo),
        trailing: Text(
          widget.producto!.precio.toString(),
          style: GoogleFonts.spaceGrotesk(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
