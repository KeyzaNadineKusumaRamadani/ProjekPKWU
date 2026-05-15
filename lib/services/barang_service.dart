import 'dart:convert';
import 'package:http/http.dart' as http;

class BarangService {

  Future<List<dynamic>> getBarang() async {

    final url = "http://192.168.1.3:3000/barang";

    print(url);

    final response = await http.get(Uri.parse(url));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception("Gagal mengambil data");

    }
  }
}