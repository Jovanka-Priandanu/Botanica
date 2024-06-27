import 'package:flutter/material.dart';
import 'data.dart';
import 'tambah_supplier.dart';

class SupplierView extends StatefulWidget {
  @override
  _SupplierViewState createState() => _SupplierViewState();
}

class _SupplierViewState extends State<SupplierView> {
  late Future<List<Supplier>> futureSuppliers;
  final ApiSupplier apiSupplier = ApiSupplier();

  @override
  void initState() {
    super.initState();
    futureSuppliers = apiSupplier.fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Supplier', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 40),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TambahSupplier()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Supplier>>(
        future: futureSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Supplier belum tersedia'));
          } else {
            List<Supplier> suppliers = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                return SupplierCard(
                  nama: suppliers[index].namaSupplier,
                  lokasi: suppliers[index].alamatSupplier,
                  kontak: suppliers[index].noSupplier,
                  email: suppliers[index].email,
                  onEdit: () {
                    // TODO: Navigate to EditSupplier page
                  },
                  onDelete: () {
                    // TODO: Implement delete functionality
                  },
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
  final String nama;
  final String lokasi;
  final String kontak;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  SupplierCard({
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
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
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
