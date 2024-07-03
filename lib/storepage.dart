import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Import untuk logout
import 'package:path_provider/path_provider.dart';
import 'profile.dart';
import 'package:path/path.dart' as path; //path untuk menarik gambar dari device
import 'productpage.dart'; // Import ProductPage untuk tanaman detail

class StorePage extends StatefulWidget {
  // deklarasi variabel
  final String namaLengkap;
  final String username;
  final String alamatUser;
  final String noUser;

  StorePage({
    required this.namaLengkap,
    required this.username,
    required this.alamatUser,
    required this.noUser,
  });

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Panggil fungsi fetchData saat halaman pertama kali dibuat
  }

  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchData() async {
    final url = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/listTanaman.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        // Set state productList dengan data dari API
        productList = data.map((item) => {
          'nama_tanaman': item['nama_tanaman'],
          'harga': item['harga'],
          'jenis_tanaman': item['jenis_tanaman'],
          'stok': item['stok'],
          'image': item['image'],
          'id_tanaman': item['id_tanaman'],
        }).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fungsi untuk konfirmasi logout
  void _confirmLogout(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah kamu yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Batalkan logout
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Lakukan logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      // Lakukan logout dengan menghapus SharedPreferences dan navigasi ke halaman LoginPage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('namaLengkap');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

      // Tampilkan Snackbar setelah navigasi ke LoginPage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kamu berhasil logout'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Fungsi untuk mengunduh gambar dari URL
  Future<File> _downloadImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = path.join(directory.path, 'images', fileName);

    final response = await http.get(Uri.parse(url));
    final file = File(imagePath);
    await file.create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 94, 60, 1),
        title: Text('Biotanic Store', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Navigasi ke halaman ProfilePage saat tombol profil ditekan
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          namaLengkap: widget.namaLengkap,
                          username: widget.username,
                          alamatUser: widget.alamatUser,
                          noUser: widget.noUser,
                        )),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _confirmLogout(context), // Panggil fungsi _confirmLogout saat tombol logout ditekan
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          // Widget CarouselSlider untuk menampilkan slider gambar
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              viewportFraction: 0.8,
            ),
            items: [
              'assets/images/slider1.jpg',
              'assets/images/slider2.jpg',
              'assets/images/slider3.jpg',
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(i, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rekomendasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            // GridView.builder untuk menampilkan produk dalam bentuk grid
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8, // Sesuaikan rasio ini sesuai kebutuhan
              ),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman ProductPage saat item produk di-tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          product: productList[index],
                          namaLengkap: widget.namaLengkap, // Kirimkan data namaLengkap ke ProductPage
                        ),
                      ),
                    );
                  },
                  child: _buildProductCard(productList[index]), // Panggil fungsi untuk membangun kartu produk
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun kartu produk
  Widget _buildProductCard(Map<String, dynamic> product) {
    return FutureBuilder<File>(
      future: _downloadImage(
          'https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/images/' +
              product['image'],
          product['image']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final imageFile = snapshot.data!;
          return Card(
            color: Color.fromRGBO(13, 127, 70, 1),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['nama_tanaman'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Harga: ${product['harga']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Stok: ${product['stok']}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            color: Color.fromRGBO(13, 127, 70, 1),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
