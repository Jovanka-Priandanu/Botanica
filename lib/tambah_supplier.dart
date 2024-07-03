import 'package:flutter/material.dart';
import 'data.dart';

class TambahSupplier extends StatefulWidget {
  @override
  _TambahSupplierState createState() => _TambahSupplierState();
}

class _TambahSupplierState extends State<TambahSupplier> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  final TextEditingController _namaController = TextEditingController(); // Controller untuk input nama
  final TextEditingController _alamatController = TextEditingController(); // Controller untuk input alamat
  final TextEditingController _noController = TextEditingController(); // Controller untuk input nomor
  final TextEditingController _emailController = TextEditingController(); // Controller untuk input email

  // Fungsi untuk menambah supplier
  Future<void> _tambahSupplier() async {
    if (_formKey.currentState!.validate()) { // Validasi form
      String nama = _namaController.text;
      String alamat = _alamatController.text;
      String no = _noController.text;
      String email = _emailController.text;

      ApiSupplier apiSupplier = ApiSupplier();
      bool isSuccess = await apiSupplier.addSupplier(
        nama,
        alamat,
        no,
        email,
      );

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supplier berhasil ditambahkan')), // Tampilkan pesan sukses
        );
        Navigator.of(context).pop(true); // Kembalikan nilai true jika berhasil/auto refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan supplier')), // Tampilkan pesan gagal
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Mendapatkan ukuran layar

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Supplier', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input nama supplier
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Supplier',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama supplier tidak boleh kosong'; // Validasi jika kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Input alamat supplier
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat Supplier',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat supplier tidak boleh kosong'; // Validasi jika kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Input nomor supplier
              TextFormField(
                controller: _noController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'No Supplier',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No supplier tidak boleh kosong'; // Validasi jika kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Input email supplier
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Supplier',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email supplier tidak boleh kosong'; // Validasi jika kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Tombol tambah supplier
              GestureDetector(
                onTap: _tambahSupplier, // Panggil fungsi tambah supplier saat ditekan
                child: Container(
                  width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.brown,
                  ),
                  child: Center(
                    child: Text(
                      'Tambah',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
