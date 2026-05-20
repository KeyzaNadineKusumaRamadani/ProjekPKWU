import 'package:flutter/material.dart';
import 'package:projek_kik/controllers/produkControllers.dart';
import 'package:projek_kik/models/productModels.dart';
import 'package:projek_kik/services/appconstans.dart';
import 'package:projek_kik/services/barang_service.dart';
import 'package:projek_kik/views/cartView.dart';
import 'package:projek_kik/views/produkdetail.dart';
import 'package:projek_kik/widgets/carousel_widget.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final BarangService service = BarangService();

  List barang = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final data = await service.getBarang();

      setState(() {
        barang = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR GET DATA: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  String getImageUrl(String? image) {
    if (image == null || image.isEmpty) return "";

    if (image.startsWith('http://') ||
        image.startsWith('https://')) {
      return image;
    }

    return "${AppConstants.baseUrl}$image";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Colors.white,
              Color(0xffF4FBF7),
              Color(0xff1F5B4D),
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(30),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.07,
                                ),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 8),
                              ),

                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.08,
                                ),
                                blurRadius: 5,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.search,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      /// CART
                      Consumer<ProductController>(
                        builder:
                            (context, controller, _) =>
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CartPage(),
                                      ),
                                    );
                                  },

                                  child: Stack(
                                    clipBehavior: Clip.none,

                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.all(
                                              12,
                                            ),

                                        decoration:
                                            BoxDecoration(
                                              color:
                                                  Colors.white,
                                              shape:
                                                  BoxShape.circle,

                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xff1F5B4D,
                                                  ).withOpacity(
                                                    0.18,
                                                  ),

                                                  blurRadius: 20,
                                                  spreadRadius: 1,
                                                  offset:
                                                      const Offset(
                                                        0,
                                                        8,
                                                      ),
                                                ),
                                              ],
                                            ),

                                        child: const Icon(
                                          Icons
                                              .shopping_cart_outlined,
                                          size: 25,
                                          color: Color(
                                            0xff1F5B4D,
                                          ),
                                        ),
                                      ),

                                      if (controller.cartCount >
                                          0)
                                        Positioned(
                                          top: -2,
                                          right: -2,

                                          child: Container(
                                            width: 18,
                                            height: 18,

                                            decoration:
                                                const BoxDecoration(
                                                  color:
                                                      Colors.red,
                                                  shape:
                                                      BoxShape
                                                          .circle,
                                                ),

                                            child: Center(
                                              child: Text(
                                                '${controller.cartCount}',

                                                style:
                                                    const TextStyle(
                                                      color:
                                                          Colors
                                                              .white,
                                                      fontSize:
                                                          10,
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// BANNER
                Container(
                  height: 180,

                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 22,
                        spreadRadius: 1,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),

                    child: Image.asset(
                      "assets/banner (2).png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// CAROUSEL
                CarouselWidget(
                  height: 190,

                  images: const [
                    "assets/promo1.png",
                    "assets/promo2.png",
                    "assets/promo3.png",
                  ],
                ),

                const SizedBox(height: 30),

                /// TOP OFFER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(25),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.08,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Top Offers for you",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: offerItem(
                                "50%\nOFF",
                                "First Order",
                                Colors.yellow.shade200,
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: offerItem(
                                "30%\nOFF",
                                "Weekend",
                                Colors.green.shade200,
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: offerItem(
                                "10%\nOFF",
                                "Special",
                                Colors.red.shade200,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// PEOPLE TOP PICKS
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "People Top Picks",

                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),

                      Text(
                        "See all",

                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )
                    : SizedBox(
                        height: 255,

                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal,

                          itemCount: barang.length,

                          itemBuilder: (context, index) {
                            final item = barang[index];

                            final imageUrl =
                                getImageUrl(
                                  item['image'],
                                );

                            final namaBarang =
                                item['nama_barang'] ??
                                'Tanpa Nama';

                            final hargaBarang =
                                item['harga'] ?? 0;

                            final productModel =
                                Product(
                                  id: item['id'],
                                  name: namaBarang,
                                  imageUrl: imageUrl,
                                  category:
                                      item['category'] ??
                                      '',
                                  sizes: [],
                                  description:
                                      item['deskripsi'] ??
                                      '',
                                  harga: hargaBarang,
                                  addons: [],
                                  type:
                                      item['type'] ??
                                      'food',
                                );

                            return Consumer<
                              ProductController
                            >(
                              builder:
                                  (
                                    context,
                                    controller,
                                    _,
                                  ) {
                                    return _foodCard(
                                      image: imageUrl,
                                      title:
                                          namaBarang,
                                      price:
                                          "Rp $hargaBarang",

                                      onTapCard: () {
                                        Navigator.push(
                                          context,

                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProductDetailPage(
                                                  product:
                                                      productModel,
                                                ),
                                          ),
                                        );
                                      },

                                      onAddToCart: () {
                                        controller
                                            .addToCart(
                                              productModel,

                                              selectedSize:
                                                  ProductSize(
                                                    label:
                                                        'Regular',
                                                    price:
                                                        hargaBarang,
                                                  ),
                                            );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "$namaBarang berhasil ditambahkan ke keranjang!",
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                            );
                          },
                        ),
                      ),

                const SizedBox(height: 30),

                /// LAST STOCK
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "Last Stock",

                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),

                      Text(
                        "See all",

                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )
                    : SizedBox(
                        height: 255,

                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal,

                          itemCount: barang.length,

                          itemBuilder: (context, index) {
                            final item = barang[index];

                            final imageUrl =
                                getImageUrl(
                                  item['image'],
                                );

                            final namaBarang =
                                item['nama_barang'] ??
                                'Tanpa Nama';

                            final hargaBarang =
                                item['harga'] ?? 0;

                            final productModel =
                                Product(
                                  id: item['id'],
                                  name: namaBarang,
                                  imageUrl: imageUrl,
                                  category:
                                      item['category'] ??
                                      '',
                                  sizes: [],
                                  description:
                                      item['deskripsi'] ??
                                      '',
                                  harga: hargaBarang,
                                  addons: [],
                                  type:
                                      item['type'] ??
                                      'food',
                                );

                            return Consumer<
                              ProductController
                            >(
                              builder:
                                  (
                                    context,
                                    controller,
                                    _,
                                  ) {
                                    return _foodCard(
                                      image: imageUrl,
                                      title:
                                          namaBarang,
                                      price:
                                          "Rp $hargaBarang",

                                      onTapCard: () {
                                        Navigator.push(
                                          context,

                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProductDetailPage(
                                                  product:
                                                      productModel,
                                                ),
                                          ),
                                        );
                                      },

                                      onAddToCart: () {
                                        controller
                                            .addToCart(
                                              productModel,

                                              selectedSize:
                                                  ProductSize(
                                                    label:
                                                        'Regular',
                                                    price:
                                                        hargaBarang,
                                                  ),
                                            );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "$namaBarang berhasil ditambahkan ke keranjang!",
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                            );
                          },
                        ),
                      ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _foodCard({
    required String image,
    required String title,
    required String price,
    required VoidCallback onTapCard,
    required VoidCallback onAddToCart,
  }) {
    return GestureDetector(
      onTap: onTapCard,

      child: Container(
        width: 150,

        margin: const EdgeInsets.only(
          left: 16,
          bottom: 8,
        ),

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: 110,
              width: double.infinity,

              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(18),

                child: Image.network(
                  image,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                        );
                      },
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: -0.2,
                      color: Colors.black87,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: onAddToCart,

                  child: Container(
                    padding: const EdgeInsets.all(5),

                    decoration: BoxDecoration(
                      color:
                          const Color(0xff1F5B4D),
                      borderRadius:
                          BorderRadius.circular(9),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xff1F5B4D,
                          ).withOpacity(0.25),

                          blurRadius: 10,
                          offset: const Offset(
                            0,
                            5,
                          ),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              price,

              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget offerItem(
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      height: 105,

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Align(
            alignment: Alignment.topRight,

            child: Container(
              padding: const EdgeInsets.all(5),

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 12,
                color: Color(0xff1F5B4D),
              ),
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,

                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}