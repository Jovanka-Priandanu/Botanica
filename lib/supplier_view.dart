import 'package:flutter/material.dart';
import 'data.dart';
import 'tambah_supplier.dart';
import 'edit_supplier.dart';

class SupplierView extends StatefulWidget {
  @override
  _SupplierViewState createState() => _SupplierViewState();
}

class _SupplierViewState extends State<SupplierView> {
  late Future<List<Supplier>> futureSuppliers; // Deklarasi variabel futureSuppliers untuk menyimpan daftar supplier yang diambil dari API
  final ApiSupplier apiSupplier = ApiSupplier(); // Inisialisasi objek ApiSupplier untuk menangani panggilan API

  @override
  void initState() {
    super.initState();
    futureSuppliers = apiSupplier.fetchSuppliers(); // Mengambil daftar supplier saat inisialisasi state
  }

  // Fungsi untuk menghapus supplier berdasarkan id
  void _deleteSupplier(String idSupplier) async {
    try {
      await apiSupplier.deleteSupplier(idSupplier); // Memanggil fungsi deleteSupplier dari ApiSupplier
      setState(() {
        futureSuppliers = apiSupplier.fetchSuppliers(); // Memperbarui daftar supplier setelah penghapusan
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier berhasil dihapus')), // Menampilkan pesan sukses
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus supplier: $e')), // Menampilkan pesan kesalahan jika gagal menghapus
      );
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi penghapusan
  void _confirmDelete(BuildContext context, String idSupplier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus supplier ini?"),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog jika batal
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog dan memanggil fungsi penghapusan
                _deleteSupplier(idSupplier);
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk navigasi ke halaman tambah supplier
  Future<void> _navigateToTambahSupplier(BuildContext context) async {
    bool? isAdded = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TambahSupplier()),
    );

    if (isAdded != null && isAdded) {
      setState(() {
        futureSuppliers = apiSupplier.fetchSuppliers(); // Memperbarui daftar supplier jika ada penambahan
      });
    }
  }

  // Fungsi untuk navigasi ke halaman edit supplier
  Future<void> _navigateToEditSupplier(BuildContext context, String idSupplier) async {
    Supplier supplier = await apiSupplier.detailSupplierById(idSupplier); // Mengambil detail supplier berdasarkan id
    bool? isUpdated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSupplier(
          supplier: supplier,
        ),
      ),
    );

    if (isUpdated != null && isUpdated) {
      setState(() {
        futureSuppliers = apiSupplier.fetchSuppliers(); // Memperbarui daftar supplier jika ada pembaruan
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Supplier', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 40),
            onPressed: () => _navigateToTambahSupplier(context), // Navigasi ke halaman tambah supplier saat tombol ditekan
          ),
        ],
      ),
      body: FutureBuilder<List<Supplier>>(
        future: futureSuppliers, // Menampilkan data supplier menggunakan FutureBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menampilkan loading indicator saat data sedang diambil
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan pesan kesalahan jika terjadi error
          } else if (!snapshot.hasData) {
            return Center(child: Text('Supplier belum tersedia')); // Menampilkan pesan jika tidak ada data supplier
          } else {
            List<Supplier> suppliers = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                return SupplierCard(
                  idSupplier: suppliers[index].idSupplier,
                  nama: suppliers[index].namaSupplier,
                  lokasi: suppliers[index].alamatSupplier,
                  kontak: suppliers[index].noSupplier,
                  email: suppliers[index].email,
                  onEdit: () => _navigateToEditSupplier(context, suppliers[index].idSupplier), // Navigasi ke halaman edit supplier
                  onDelete: () => _confirmDelete(context, suppliers[index].idSupplier), // Menampilkan dialog konfirmasi hapus
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SupplierCard extends StatelessWidget {
  final String idSupplier;
  final String nama;
  final String lokasi;
  final String kontak;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  SupplierCard({
    required this.idSupplier,
    required this.nama,
    required this.lokasi,
    required this.kontak,
    required this.email,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nama, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: onEdit, // Memanggil fungsi edit saat tombol ditekan
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete, // Memanggil fungsi hapus saat tombol ditekan
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.black, thickness: 2),
            SizedBox(height: 8),
            Text('Lokasi : ' + lokasi, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('No : ' + kontak, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Email : ' + email, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
