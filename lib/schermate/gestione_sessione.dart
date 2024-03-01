import "dart:async";

import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/schermate/fine_sessione.dart";
import "package:flutter/material.dart";

class GestioneSessione extends StatefulWidget {
  final Libro libro;

  const GestioneSessione({super.key, required this.libro});

  @override
  State<GestioneSessione> createState() => _GestioneSessioneState();
}

class _GestioneSessioneState extends State<GestioneSessione> {
  late Stopwatch stopwatch;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    stopwatch.start();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }

  String returnFormattedText() {
    final milli = stopwatch.elapsed.inMilliseconds;

    var secondi = milli ~/ 1000;

    final ore = secondi ~/ 3600;

    secondi -= ore * 3600;

    final minuti = secondi ~/ 60;

    secondi -= minuti * 60;

    final stringaSecondi = secondi.toString().padLeft(2, "0");
    final stringaMinuti = minuti.toString().padLeft(2, "0");
    final stringOre = ore.toString().padLeft(2, "0");

    return "$stringOre:$stringaMinuti:$stringaSecondi";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sessione"),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 50),
        children: [
          Center(
            child: Text(
              returnFormattedText(),
              style: const TextStyle(fontSize: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                handleStartStop();
              },
              child: Text(stopwatch.isRunning ? "Pausa" : "Riprendi"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FineSessione(
                      libro: widget.libro,
                      durata: stopwatch.elapsed,
                    ),
                  ),
                );
              },
              child: const Text("Finito"),
            ),
          ),
        ],
      ),
    );
  }
}
