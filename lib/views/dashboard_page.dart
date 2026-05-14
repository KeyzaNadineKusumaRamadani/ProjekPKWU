import 'package:flutter/material.dart';
import 'package:projek_kik/services/barang_service.dart';
import 'package:projek_kik/widgets/carousel_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  BarangService service = BarangService();

  List barang = [];

  bool isLoading = true;

  int selectedIndex = 0;

  getData() async {

    barang = await service.getBarang();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
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
              Color(0xffEAF5F1),
              Color(0xff1F5B4D),
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 20),

                /// =========================
                /// SEARCH BAR
                /// =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 50,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: const Offset(0, 5),
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

                      /// CART BUTTON
                      GestureDetector(
                        onTap: () {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cart clicked"),
                            ),
                          );
                        },

                        child: Container(
                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),

                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 25,
                            color: Color(0xff1F5B4D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// =========================
                /// BANNER
                /// =========================
                Container(
                  height: 180,

                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],

                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/banner (2).png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// =========================
                /// CAROUSEL
                /// =========================
                CarouselWidget(
                  height: 190,

                  images: [
                    "assets/promo2.png",
                    "assets/promo1.png",
                    "assets/promo3.png",
                  ],
                ),

                const SizedBox(height: 30),

                /// =========================
                /// TOP OFFER
                /// =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: const Offset(0, 5),
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
                            fontWeight: FontWeight.bold,
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

                /// =========================
                /// PEOPLE TOP PICKS
                /// =========================
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "People Top Picks",

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "See all",

                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )

                    : SizedBox(
                        height: 220,

                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,

                          itemCount: barang.length,

                          itemBuilder: (context, index) {

                            return foodCard(
                              image: barang[index]['image'],
                              title:
                                  barang[index]['nama_barang'],
                              price:
                                  "Rp ${barang[index]['harga'] ?? 0}",
                            );
                          },
                        ),
                      ),

                const SizedBox(height: 30),

                /// =========================
                /// LAST STOCK
                /// =========================
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "Last Stock",

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "See all",

                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )

                    : SizedBox(
                        height: 220,

                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,

                          itemCount: barang.length,

                          itemBuilder: (context, index) {

                            return foodCard(
                              image: barang[index]['image'],
                              title:
                                  barang[index]['nama_barang'],
                              price:
                                  "Rp ${barang[index]['harga'] ?? 0}",
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

      /// =========================
      /// BOTTOM NAVBAR
      /// =========================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),

        height: 70,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),

          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,

          children: [

            navItem(Icons.home, 0),

            navItem(Icons.receipt_long, 1),

            navItem(Icons.person_outline, 2),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// NAVBAR ITEM
  /// =========================
  Widget navItem(IconData icon, int index) {

    return GestureDetector(
      onTap: () {

        setState(() {
          selectedIndex = index;
        });
      },

      child: Icon(
        icon,
        size: 28,

        color: selectedIndex == index
            ? const Color(0xff1F5B4D)
            : Colors.grey,
      ),
    );
  }

  /// =========================
  /// FOOD CARD
  /// =========================
  Widget foodCard({
    required String image,
    required String title,
    required String price,
  }) {

    return Container(
      width: 135,
      height: 200,

      margin: const EdgeInsets.only(left: 20),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          SizedBox(
            height: 110,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),

              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,

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
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text("$title added"),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(4),

                  decoration: BoxDecoration(
                    color: const Color(0xff1F5B4D),
                    borderRadius:
                        BorderRadius.circular(8),
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
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// OFFER ITEM
  /// =========================
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
              padding: const EdgeInsets.all(4),

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
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}