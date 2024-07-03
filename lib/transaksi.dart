import 'package:flutter/material.dart';
import 'data.dart'; // Mengimpor file data.dart yang berisi pengolahan data API

class Transaksi extends StatefulWidget {
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  List<Map<String, dynamic>> namaTanamanList = []; // Menyimpan daftar nama tanaman
  List<Map<String, dynamic>> namaPenerimaList = []; // Menyimpan daftar nama penerima

  TextEditingController _quantityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  String? _selectedTanaman; // Menyimpan tanaman yang dipilih
  String? _selectedPenerima; // Menyimpan penerima yang dipilih

  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form validasi

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil fungsi untuk mengambil data saat inisialisasi
  }

  @override
  void dispose() {
    _quantityController.dispose(); // Membersihkan controller saat dispose
    _dateController.dispose(); // Membersihkan controller saat dispose
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      // Mengambil data nama tanaman dan nama penerima dari API
      final tanamanList = await ApiData.fetchNamaTanaman();
      final penerimaList = await ApiTransaksi.fetchNamaCustomer();

      setState(() {
        namaTanamanList = tanamanList; // Menyimpan daftar nama tanaman
        namaPenerimaList = penerimaList; // Menyimpan daftar nama penerima
      });
    } catch (error) {
      print('Error fetching data: $error'); // Menampilkan pesan error jika gagal mengambil data
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Fungsi untuk memilih tanggal
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selected != null)
      setState(() {
        _dateController.text = "${selected.toLocal()}".split(' ')[0]; // Menyimpan tanggal yang dipilih
      });
  }

  Future<void> _saveSupply() async {
    // Fungsi untuk menyimpan data transaksi
    try {
      final response = await ApiTransaksi.saveTransaksi(
        idTanaman: _selectedTanaman!,
        idPenerima: _selectedPenerima!,
        quantity: _quantityController.text,
        date: _dateController.text,
      );

      print('Response data: $response');

      bool success = response['success'] ?? false;
      if (!success) {
        // Menampilkan pesan jika data gagal disimpan
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data berhasil disimpan')));
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      } else {
        // Menampilkan pesan jika data berhasil disimpan dan kembali ke halaman sebelumnya
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data gagal disimpan')));
      }
    } catch (error) {
      // Menampilkan pesan error jika terjadi kesalahan saat menyimpan data
      print('Error menyimpan data: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Transaksi', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedTanaman,
                items: namaTanamanList.map((item) {
                  // Menampilkan daftar nama tanaman dalam dropdown
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
                    _selectedTanaman = newValue; // Menyimpan pilihan tanaman
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
              DropdownButtonFormField<String>(
                value: _selectedPenerima,
                items: namaPenerimaList.map((item) {
                  // Menampilkan daftar nama penerima dalam dropdown
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
                    _selectedPenerima = newValue; // Menyimpan pilihan penerima
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
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  await _selectDate(context); // Memilih tanggal
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong'; // Validasi jika tanggal kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveSupply(); // Menyimpan data transaksi jika form valid
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
