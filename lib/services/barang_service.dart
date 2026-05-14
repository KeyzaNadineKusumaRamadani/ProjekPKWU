import 'dart:convert';
import 'package:http/http.dart' as http;

class BarangService {

  Future<List<dynamic>> getBarang() async {

    final response = await http.get(
      Uri.parse("http://localhost:3000/barang"),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception("Gagal mengambil data");

    }
  }
}