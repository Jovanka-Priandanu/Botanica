import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'tanaman_view.dart';

class TambahTanaman extends StatefulWidget {
  const TambahTanaman({Key? key}) : super(key: key);

  @override
  State<TambahTanaman> createState() => _TambahTanamanState();
}

class _TambahTanamanState extends State<TambahTanaman> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  TextEditingController namaTanamanController = TextEditingController();
  TextEditingController jenisTanamanController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    namaTanamanController.dispose();
    jenisTanamanController.dispose();
    hargaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tanaman', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Mengecek validasi saat interaksi pengguna
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: size.width,
                height: 250,
                child: GestureDetector(
                  onTap: () {
                    showPictureDialog();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    color: Colors.grey,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: _image != null
                            ? Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.image_outlined,
                                color: Colors.blueGrey,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: namaTanamanController,
                decoration: InputDecoration(
                  labelText: 'Nama Tanaman',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tanaman tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: jenisTanamanController,
                decoration: InputDecoration(
                  labelText: 'Jenis Tanaman',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis tanaman tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: stokController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (_image != null) {
                          saveImageLocally().then((imagePath) {
                            if (imagePath != null) {
                              sendDataToApi(imagePath);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TanamanView(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gambar gagal disimpan.'),
                                ),
                              );
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Silakan pilih gambar.'),
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: size.width,
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPictureDialog();
        },
        tooltip: 'Pilih Gambar',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<String?> saveImageLocally() async {
    if (_image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/images';
      await Directory(imagePath).create(recursive: true);

      // Generate current date and time for unique file name
      String timestamp = DateTime.now().toString().substring(0, 10).replaceAll('-', '');
      final fileName = '${namaTanamanController.text}$timestamp.jpg'; // Nama file sesuai format yang diminta
      final filePath = '$imagePath/$fileName';

      try {
        await _image!.copy(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gambar berhasil disimpan.'),
          ),
        );
        return fileName; // Mengembalikan nama file gambar yang disimpan
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gambar gagal disimpan.'),
          ),
        );
        return null;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih gambar.'),
        ),
      );
      return null;
    }
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Action'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                getFromCamera();
                Navigator.of(context).pop();
              },
              child: const Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                getFromGallery();
                Navigator.of(context).pop();
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> getFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> sendDataToApi(String imageName) async {
    try {
      final uri = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/addTanaman.php');
      var request = http.MultipartRequest('POST', uri);
      request.fields['nama_tanaman'] = namaTanamanController.text;
      request.fields['jenis_tanaman'] = jenisTanamanController.text;
      request.fields['harga'] = hargaController.text;
      request.fields['stok'] = stokController.text;
      request.fields['image'] = imageName; // Menambahkan nama file gambar ke data

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data berhasil disimpan');
      } else {
        print('Data gagal disimpan. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
