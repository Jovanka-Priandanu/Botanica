import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class EditTanaman extends StatefulWidget {
  final String idTanaman;

  EditTanaman({required this.idTanaman});

  @override
  _EditTanamanState createState() => _EditTanamanState();
}

class _EditTanamanState extends State<EditTanaman> {
  late Future<Map<String, dynamic>> futureTanaman;
  final _formKey = GlobalKey<FormState>();
  late String _namaTanaman;
  late String _jenisTanaman;
  late String _harga;
  late String _stok;
  late String _image;
  File? _imageFile;
  final picker = ImagePicker();

  TextEditingController namaTanamanController = TextEditingController();
  TextEditingController jenisTanamanController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTanaman = fetchTanaman(widget.idTanaman);
  }

  Future<Map<String, dynamic>> fetchTanaman(String idTanaman) async {
    final response = await http.get(
      Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/detailTanaman.php?id_tanaman=$idTanaman'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tanaman');
    }
  }

  Future<void> saveTanaman() async {
    String imagePath = _image;

    if (_imageFile != null) {
      imagePath = await saveImageLocally(_namaTanaman);
      if (imagePath.isEmpty) return;
    }

    final response = await http.post(
      Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/editTanaman.php'),
      body: {
        'id_tanaman': widget.idTanaman,
        'nama_tanaman': _namaTanaman,
        'jenis_tanaman': _jenisTanaman,
        'harga': _harga,
        'stok': _stok,
        'image': imagePath,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tanaman berhasil diperbarui')));
      Navigator.pop(context, true); // Return to the previous screen with a success flag
    } else {
      throw Exception('Failed to update tanaman');
    }
  }

  Future<String> saveImageLocally(String namaTanaman) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, 'images');
      await Directory(imagePath).create(recursive: true);

      String timestamp = DateTime.now().toString().substring(0, 10).replaceAll('-', '');
      final fileName = '$namaTanaman$timestamp.jpg'; // Adjust the file name format as needed
      final filePath = '$imagePath/$fileName';

      await _imageFile!.copy(filePath);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gambar berhasil disimpan')));

      return fileName;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan gambar')));
      return '';
    }
  }

  Future<String> _getImagePath(String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = path.join(directory.path, 'images', imageName);
    return imagePath;
  }

  Future<void> _getFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tanaman', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
         leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureTanaman,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            Map<String, dynamic> tanaman = snapshot.data!;
            namaTanamanController.text = tanaman['nama_tanaman'];
            jenisTanamanController.text = tanaman['jenis_tanaman'];
            hargaController.text = tanaman['harga'];
            stokController.text = tanaman['stok'];
            _image = tanaman['image'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    FutureBuilder<String>(
                      future: _getImagePath(_image),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          final imagePath = snapshot.data!;
                          return (File(imagePath).existsSync())
                              ? Image.file(File(imagePath), height: 200, fit: BoxFit.cover)
                              : Container(height: 200, color: Colors.grey);
                        } else {
                          return Container(height: 200, color: Colors.grey);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _getFromGallery,
                          icon: Icon(Icons.photo_library),
                          label: Text('Pilih dari Gallery'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: _getFromCamera,
                          icon: Icon(Icons.camera_alt),
                          label: Text('Camera'),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: namaTanamanController,
                      decoration: InputDecoration(labelText: 'Nama Tanaman'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tanaman tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: jenisTanamanController,
                      decoration: InputDecoration(labelText: 'Jenis Tanaman'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis tanaman tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: hargaController,
                      decoration: InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: stokController,
                      decoration: InputDecoration(labelText: 'Stok'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _namaTanaman = namaTanamanController.text;
                            _jenisTanaman = jenisTanamanController.text;
                            _harga = hargaController.text;
                            _stok = stokController.text;
                          });
                          saveTanaman(); // Save the edited tanaman
                        }
                      },
                      child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
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
            );
          }
        },
      ),
    );
  }
}