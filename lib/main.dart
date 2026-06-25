import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ListaExterna());
}

class ListaExterna extends StatelessWidget {
  const ListaExterna({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Cuerpo());
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Externo")),
      body: Center(
        child: Column(
          children: [
            Text('Lista externa'),
            Expanded(child: listaExterna(context)),
          ],
        ),
      ),
    );
  }
}

//
//! Funcion que lea el JSON mediante una URL
Future<List> leerUrl(String url) async {
  final respuesta = await http.get(Uri.parse(url));

  final data = jsonDecode(respuesta.body);

  return data["series"];
}

Widget listaExterna(BuildContext context) {
  final String url = "https://jritsqmet.github.io/web-api/series.json";

  return FutureBuilder(
    future: leerUrl(url),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data;

        return ListView.builder(
          itemCount: data!.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return ListTile(
              title: Text(item["titulo"]),
              subtitle: Text(item["descripcion"]),
              leading: image(item["info"]["imagen"]),
              onTap: () => verMas(context, item),
            );
          },
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No hay data"),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        );
      }
    },
  );
}

void verMas(BuildContext context, serie) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(serie["titulo"]),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [image(serie["info"]["imagen"])],
    ),
  ),
);

Widget image(String url) => SizedBox(
  width: 60,
  child: Image.network(
    url,
    errorBuilder: (context, error, stackTrace) => Column(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.orange),
        Text("No image", style: TextStyle(color: Colors.orange)),
      ],
    ),
  ),
);
