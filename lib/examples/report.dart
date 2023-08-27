// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Proveedor para controlar la conectividad
//         StreamProvider<ConnectivityResult?>(
//           create: (_) => Connectivity().onConnectivityChanged,
//           initialData: null,
//         ),
//       ],
//       child: MaterialApp(
//         // ...
//       ),
//     );
//   }
// }

// class MyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ConnectivityResult? connectivityResult =
//         Provider.of<ConnectivityResult?>(context);

//     if (connectivityResult == ConnectivityResult.none) {
//       // No hay conexión a Internet
//       return Text('Sin conexión');
//     } else {
//       // Hay conexión a Internet
//       // Aquí puedes llamar a la función para enviar los reportes guardados
//       enviarReportesGuardados();

//       return Text('Con conexión');
//     }
//   }
// }
