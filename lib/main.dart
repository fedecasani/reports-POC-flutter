import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult?>(
          create: (_) => Connectivity().onConnectivityChanged,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ejemplo de Conectividad',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _reporteController = TextEditingController();

  @override
  void dispose() {
    _reporteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConnectivityResult? connectivityResult =
        Provider.of<ConnectivityResult?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('POC Connectivity'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                connectivityResult == ConnectivityResult.none
                    ? 'Sin conexión a Internet'
                    : 'Conexión establecida',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _reporteController,
              decoration: InputDecoration(
                labelText: 'Reporte',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (connectivityResult == ConnectivityResult.none) {
                guardarReporteLocalmente(_reporteController.text); // Save report locally
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Reporte guardado'),
                    content: Text('El reporte se guardó localmente.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              } else {
                enviarReporte(_reporteController.text);
              }
            },
            child: Text('Enviar reporte'),
          ),
        ],
      ),
    );
  }

  Future<void> guardarReporteLocalmente(String reporte) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? reportesGuardados = prefs.getStringList('reportes') ?? [];
    reportesGuardados.add(reporte);
    await prefs.setStringList('reportes', reportesGuardados);
  }

  Future<void> enviarReporte(String reporte) async {
    try {
      await http.post(Uri.parse('https://eooyfnppfcj5q65.m.pipedream.net'), body: reporte);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Reporte enviado'),
          content: Text('El reporte se envió correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error al enviar el reporte'),
          content: Text('Hubo un error al enviar el reporte. Se guardará localmente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
      guardarReporteLocalmente(reporte);
    }
  }

  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        enviarReportesLocales();
      }
    });

    // Check connectivity on app startup
    checkConnectivityOnStartup();
  }

  Future<void> checkConnectivityOnStartup() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      enviarReportesLocales();
    }
  }

  Future<void> enviarReportesLocales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? reportesGuardados = prefs.getStringList('reportes') ?? [];
    
    for (String reporte in reportesGuardados) {
      try {
        await enviarReporte(reporte);
      } catch (e) {
        // Handle error while sending report
      }
    }
    
    // Remove saved reports
    await prefs.remove('reportes');
  }
}
