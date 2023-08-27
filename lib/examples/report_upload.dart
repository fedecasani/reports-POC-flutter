// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> enviarReportesGuardados() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<String>? reportesGuardados = prefs.getStringList('reportes') ?? [];

//   for (String reporte in reportesGuardados) {
//     // Enviar el reporte utilizando una solicitud HTTP (POST, PUT, etc.)
//     // Aquí puedes agregar tu lógica para enviar el reporte
//     // Puedes usar http.post() o http.put() según tus necesidades
//     await http.post('URL_DEL_ENDPOINT', body: reporte);
//   }

//   // Borrar los reportes guardados después de enviarlos exitosamente
//   await prefs.remove('reportes');
// }
