import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tanaman_view.dart';
import 'main.dart';
import 'supplier_view.dart';

class HomePage extends StatelessWidget {
  final String namaLengkap;

  HomePage({required this.namaLengkap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selamat Datang, $namaLengkap',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('namaLengkap');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TanamanView()),
              );
            },
            child: SizedBox(
              width: 500,
              height: 200,
              child: Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/tanaman-menu.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SupplierView()),
              );
            },
            child: SizedBox(
              width: 500,
              height: 200,
              child: Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/supplier-menu.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Tambahkan 2 buah tombol ikon berbentuk bulat di bawah gambar Supplier
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Material(
                  shape: CircleBorder(),
                  elevation: 3,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.add_box, size: 30),
                      color: Colors.red,
                      onPressed: () {
                        // Aksi saat tombol ditekan
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8), // Jarak antara ikon dan teks
                Text('Tambah Supply', style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(width: 32), // Jarak antara dua tombol
            Column(
              children: [
                Material(
                  shape: CircleBorder(),
                  elevation: 3,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.shopping_bag, size: 30),
                      color: Colors.blue,
                      onPressed: () {
                        // Aksi saat tombol ditekan
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8), // Jarak antara ikon dan teks
                Text('Transaksi', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        ],
      ),
    );
  }
}
