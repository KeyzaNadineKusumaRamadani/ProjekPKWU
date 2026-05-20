import 'package:flutter/material.dart';
import 'package:projek_kik/services/apiService.dart';
import 'package:projek_kik/views/cartView.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;
  List<dynamic> _history = [];
  List<dynamic> _wishlist = [];

  bool _loading = true;

  static const int _userId = 1;

  static const Color _green =  Color(0xff1F5B4D);
  static const Color _bg = Color(0xFFF5F5F2);

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);

    try {
      final user = await ApiService.getUser(_userId);

      final history = await ApiService.getHistory();
  
      final wishlist = await ApiService.getWishlist();

      print(history);

      setState(() {
        _user = user;
        _history = history;
        _wishlist = wishlist;
      });
    } catch (e) {
      print("PROFILE ERROR: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  String _formatPrice(dynamic price) {
    final number = int.tryParse(price.toString()) ?? 0;

    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);

      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: _green,
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF154E3F),
                    Color(0xFFF4F4F1),
                    Color(0xFF154E3F),
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      Text(
                        "History",
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // PROFILE CARD
                      _buildProfileCard(),

                      const SizedBox(height: 28),

                      // HISTORY
                      const Text(
                        "History",
                        style: TextStyle(
                          color: _green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _history.isEmpty
                          ? _emptyWidget("Belum ada history")
                          : Column(
                              children: _history.map((item) {
                                return _buildHistoryCard(item);
                              }).toList(),
                            ),

                      const SizedBox(height: 28),

                      // WISHLIST
                      const Text(
                        "Wishlist",
                        style: TextStyle(
                          color: _green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      _wishlist.isEmpty
                          ? _emptyWidget("Wishlist kosong")
                          : GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount: _wishlist.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.72,
                              ),
                              itemBuilder: (context, index) {
                                return _buildWishlistCard(
                                    _wishlist[index]);
                              },
                            ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ================= PROFILE CARD =================

  Widget _buildProfileCard() {
    final name = _user?['name'] ?? 'Nanami Kento';

    final address =
        _user?['address'] ?? 'Your Address';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/𝐉𝐢𝐧𝐱.jpeg",
                    fit: BoxFit.cover,
                    width: 76,
                    height: 76,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    address,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: _green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CartPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EFEA),
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "View Cart",
                        style: TextStyle(
                          color: _green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= HISTORY CARD =================

  Widget _buildHistoryCard(dynamic item) {
    final name = item['nama_barang'] ??
        item['name'] ??
        'Produk';

    final price = _formatPrice(
      item['harga'] ?? item['price'] ?? 0,
    );

    final date = _formatDate(
      item['tanggal'] ?? item['date'] ?? '',
    );

    final image = item['gambar'] ??
        item['image'] ??
        '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFDADADA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  price,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Text(
            date,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ================= WISHLIST CARD =================

  Widget _buildWishlistCard(dynamic item) {
    final name = item['nama_barang'] ??
        item['name'] ??
        'Produk';

    final price = _formatPrice(
      item['harga'] ?? item['price'] ?? 0,
    );

    final image = item['gambar'] ??
        item['image'] ??
        '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.fastfood,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  price,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY =================

  Widget _emptyWidget(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

// ================= MODEL HISTORY =================

class HistoryItem {
  final int id;
  final int total;
  final String tanggal;

  HistoryItem({
    required this.id,
    required this.total,
    required this.tanggal,
  });

  factory HistoryItem.fromJson(
      Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? 0,
      total: json['total'] ?? 0,
      tanggal: json['tanggal'] ?? '',
    );
  }
}