import "package:bookwarm/modelli/libro.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hive_flutter/hive_flutter.dart";

class AggiungiLibroManuale extends StatefulWidget {
  const AggiungiLibroManuale({super.key});

  @override
  State<AggiungiLibroManuale> createState() => _AggiungiLibroManualeState();
}

class _AggiungiLibroManualeState extends State<AggiungiLibroManuale> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController controllerTitolo;
  late TextEditingController controllerAutore;
  late TextEditingController controllerCasaEditrice;
  late TextEditingController controllerPagine;
  late TextEditingController controllerIsbn;
  late TextEditingController controllerDescrizione;

  late Box<Libro> libri;

  @override
  void initState() {
    super.initState();

    controllerTitolo = TextEditingController();
    controllerAutore = TextEditingController();
    controllerCasaEditrice = TextEditingController();
    controllerPagine = TextEditingController();
    controllerIsbn = TextEditingController();
    controllerDescrizione = TextEditingController();

    libri = Hive.box("libri");
  }

  @override
  void dispose() {
    controllerTitolo.dispose();
    controllerAutore.dispose();
    controllerCasaEditrice.dispose();
    controllerPagine.dispose();
    controllerIsbn.dispose();
    controllerDescrizione.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi libro"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: controllerTitolo,
              decoration: const InputDecoration(hintText: "Titolo"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Inserisci un titolo";
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllerAutore,
              decoration: const InputDecoration(hintText: "Autore"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Inserisci un autore";
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllerCasaEditrice,
              decoration: const InputDecoration(hintText: "Casa Editrice"),
            ),
            TextFormField(
              controller: controllerPagine,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: "Pagine"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Inserisci numero pagine";
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllerIsbn,
              maxLength: 13,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: "ISBN"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Inserisci ISBN";
                }
                if (value.length < 13) {
                  return "ISBN deve avere 13 caratteri";
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllerDescrizione,
              decoration: const InputDecoration(hintText: "Descrizione"),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final libro = Libro(
                      titolo: controllerTitolo.value.text,
                      autore: controllerAutore.value.text,
                      pagine: int.parse(controllerPagine.value.text),
                      isbn: controllerIsbn.value.text,
                      casaEditice: controllerCasaEditrice.value.text,
                      descrizione: controllerDescrizione.value.text,
                    );
                    libri.add(libro);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Aggiungi"))
          ],
        ),
      ),
    );
  }
}
