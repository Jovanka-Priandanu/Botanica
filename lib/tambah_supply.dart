import 'package:flutter/material.dart';
import 'data.dart'; 

class TambahSupply extends StatefulWidget {
  @override
  _TambahSupplyState createState() => _TambahSupplyState();
}

class _TambahSupplyState extends State<TambahSupply> {
  // Daftar untuk menyimpan nama tanaman, supplier, dan penerima
  List<Map<String, dynamic>> namaTanamanList = [];
  List<Map<String, dynamic>> namaSupplierList = [];
  List<Map<String, dynamic>> namaPenerimaList = [];

  // Controller untuk mengontrol input teks pada form
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  // Variabel untuk menyimpan nilai yang dipilih dari dropdown
  String? _selectedTanaman;
  String? _selectedSupplier;
  String? _selectedPenerima;

  // Key untuk form validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil fungsi untuk mengambil data dari API saat inisialisasi
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchData() async {
    try {
      final tanamanList = await ApiData.fetchNamaTanaman();
      final supplierList = await ApiData.fetchNamaSupplier();
      final penerimaList = await ApiData.fetchNamaPenerima();

      setState(() {
        // Mengupdate state dengan data yang diambil
        namaTanamanList = tanamanList;
        namaSupplierList = supplierList;
        namaPenerimaList = penerimaList;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selected != null)
      setState(() {
        _dateController.text = "${selected.toLocal()}".split(' ')[0]; // Mengupdate teks field dengan tanggal yang dipilih
      });
  }

  // Fungsi untuk menyimpan data supply
  Future<void> _saveSupply() async {
    try {
      final response = await ApiData.saveSupply(
        idTanaman: _selectedTanaman!,
        idSupplier: _selectedSupplier!,
        idPenerima: _selectedPenerima!,
        quantity: _quantityController.text,
        date: _dateController.text,
      );

      print('Response data: $response');

      bool success = response['success'] ?? false;
      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data gagal disimpan')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data berhasil disimpan')));
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya setelah berhasil menyimpan data
      }
    } catch (error) {
      print('Error menyimpan data: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Tambah Supply', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya saat tombol back ditekan
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Menggunakan key untuk validasi form
          child: Column(
            children: [
              // Dropdown untuk memilih nama tanaman
              DropdownButtonFormField<String>(
                value: _selectedTanaman,
                items: namaTanamanList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id_tanaman'],
                    child: Text('${item['nama_tanaman']} (id: ${item['id_tanaman']})'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Nama Tanaman',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTanaman = newValue; // Mengupdate nilai yang dipilih
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Tanaman tidak boleh kosong'; // Validasi jika nama tanaman kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Dropdown untuk memilih nama supplier
              DropdownButtonFormField<String>(
                value: _selectedSupplier,
                items: namaSupplierList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id_supplier'],
                    child: Text('${item['nama_supplier']} (id: ${item['id_supplier']})'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Nama Supplier',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSupplier = newValue; // Mengupdate nilai yang dipilih
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Supplier tidak boleh kosong'; // Validasi jika nama supplier kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Dropdown untuk memilih nama penerima
              DropdownButtonFormField<String>(
                value: _selectedPenerima,
                items: namaPenerimaList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id_user'],
                    child: Text('${item['nama_lengkap']} (id: ${item['id_user']})'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Nama Penerima',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPenerima = newValue; // Mengupdate nilai yang dipilih
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Penerima tidak boleh kosong'; // Validasi jika nama penerima kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Text field untuk menginput quantity
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity tidak boleh kosong'; // Validasi jika quantity kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Text field untuk menginput tanggal
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  await _selectDate(context); // Memilih tanggal saat text field ditekan
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong'; // Validasi jika tanggal kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Tombol untuk menyimpan data
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveSupply(); // Memanggil fungsi untuk menyimpan data jika form valid
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
