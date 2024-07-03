import 'package:flutter/material.dart';
import 'data.dart';

// Widget untuk halaman edit supplier
class EditSupplier extends StatefulWidget {
  final Supplier supplier; // data Supplier yang akan diedit

  EditSupplier({required this.supplier});

  @override
  _EditSupplierState createState() => _EditSupplierState();
}

class _EditSupplierState extends State<EditSupplier> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  late TextEditingController _namaController; // Controller untuk input nama
  late TextEditingController _alamatController; // Controller untuk input alamat
  late TextEditingController _noController; // Controller untuk input nomor
  late TextEditingController _emailController; // Controller untuk input email

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data supplier yang akan diedit
    _namaController = TextEditingController(text: widget.supplier.namaSupplier);
    _alamatController = TextEditingController(text: widget.supplier.alamatSupplier);
    _noController = TextEditingController(text: widget.supplier.noSupplier);
    _emailController = TextEditingController(text: widget.supplier.email);
  }

  // Fungsi untuk mengedit supplier
  Future<void> _editSupplier() async {
    if (_formKey.currentState!.validate()) { // Validasi form
      String idSupplier = widget.supplier.idSupplier;
      String nama = _namaController.text;
      String alamat = _alamatController.text;
      String no = _noController.text;
      String email = _emailController.text;

      ApiSupplier apiSupplier = ApiSupplier();
      bool isSuccess = await apiSupplier.editSupplier(
        idSupplier,
        nama,
        alamat,
        no,
        email,
      );

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data supplier berhasil diubah')), // Tampilkan pesan sukses
        );
        Navigator.of(context).pop(true); // Kembalikan nilai true jika berhasil
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah data supplier')), // Tampilkan pesan gagal
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Mendapatkan ukuran layar

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Supplier', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
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
              // Tombol simpan perubahan
              ElevatedButton(
                onPressed: _editSupplier, // Panggil fungsi edit supplier saat ditekan
                child: Text('Simpan', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(size.width, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
