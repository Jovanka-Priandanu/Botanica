import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TambahSupply extends StatefulWidget {
  @override
  _TambahSupplyState createState() => _TambahSupplyState();
}

class _TambahSupplyState extends State<TambahSupply> {
  // Lists to store the fetched data
  List<Map<String, dynamic>> namaTanamanList = [];
  List<Map<String, dynamic>> namaSupplierList = [];
  List<Map<String, dynamic>> namaPenerimaList = [];

  // Controllers for the input fields
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  // Variables to store selected values
  String? _selectedTanaman;
  String? _selectedSupplier;
  String? _selectedPenerima;

  // Key for the form
  final _formKey = GlobalKey<FormState>();

  // Function to fetch data from API
  Future<void> fetchData() async {
    final tanamanUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/listTanaman.php');
    final supplierUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/supplier/listSupplier.php');
    final userUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/user/User.php');

    try {
      // Fetch nama tanaman data
      final responseTanaman = await http.get(tanamanUrl);
      if (responseTanaman.statusCode == 200) {
        final jsonData = json.decode(responseTanaman.body) as List;
        List<Map<String, dynamic>> fetchedNamaTanamanList = jsonData.map((item) => {
          'id_tanaman': item['id_tanaman'],
          'nama_tanaman': item['nama_tanaman'],
        }).toList();
        setState(() {
          namaTanamanList = fetchedNamaTanamanList;
        });
      } else {
        throw Exception('Failed to load nama tanaman data');
      }

      // Fetch nama supplier data
      final responseSupplier = await http.get(supplierUrl);
      if (responseSupplier.statusCode == 200) {
        final jsonData = json.decode(responseSupplier.body) as List;
        List<Map<String, dynamic>> fetchedNamaSupplierList = jsonData.map((item) => {
          'id_supplier': item['id_supplier'],
          'nama_supplier': item['nama_supplier'],
        }).toList();
        setState(() {
          namaSupplierList = fetchedNamaSupplierList;
        });
      } else {
        throw Exception('Failed to load nama supplier data');
      }

      // Fetch nama penerima data
      final responseUser = await http.get(userUrl);
      if (responseUser.statusCode == 200) {
        final jsonData = json.decode(responseUser.body) as List;
        List<Map<String, dynamic>> fetchedNamaPenerimaList = jsonData.map((item) => {
          'id_user': item['id_user'],
          'nama_lengkap': item['nama_lengkap'],
        }).toList();
        setState(() {
          namaPenerimaList = fetchedNamaPenerimaList;
        });
      } else {
        throw Exception('Failed to load nama penerima data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selected != null)
      setState(() {
        _dateController.text = "${selected.toLocal()}".split(' ')[0];
      });
  }

  Future<void> _saveSupply() async {
    final addSupplyUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/pengadaan/addSupply.php');
    try {
      final response = await http.post(
        addSupplyUrl,
        body: {
          'id_tanaman': _selectedTanaman!,
          'id_supplier': _selectedSupplier!,
          'id_user': _selectedPenerima!,
          'qty_in': _quantityController.text,
          'date_in': _dateController.text,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Response data: $jsonData'); // Log response data
        bool success = jsonData['success'] ?? false; // Handle null safely
        if (success) {
          // Handle success (e.g., show a success message or navigate to another screen)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil disimpan')));
        } else {
          // Handle failure (e.g., show an error message)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan data')));
        }
      } else {
        print('Failed to save data: ${response.body}');
        throw Exception('Failed to save data');
      }
    } catch (error) {
      print('Error saving data: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Supply'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
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
                    _selectedTanaman = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Tanaman tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
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
                    _selectedSupplier = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Supplier tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
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
                    _selectedPenerima = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Penerima tidak boleh kosong';
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
                    return 'Quantity tidak boleh kosong';
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
                  await _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar and proceed with the action
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                    _saveSupply();
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
