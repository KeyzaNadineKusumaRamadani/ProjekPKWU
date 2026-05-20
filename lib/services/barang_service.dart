import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_kik/services/appconstans.dart';

class BarangService {
  /// GET /barang — dipakai oleh Dashboard & MenuPage
  Future<List<dynamic>> getBarang() async {
    try {
      final res = await http.get(
        Uri.parse('${AppConstants.baseUrl}/barang'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (e) {
      throw Exception('Koneksi gagal: $e');
    }
  }
}