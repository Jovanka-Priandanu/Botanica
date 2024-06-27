import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'tambah_tanaman.dart'; 
import 'edit_tanaman.dart'; // Import halaman edit tanaman

class TanamanView extends StatefulWidget {
  @override
  _TanamanViewState createState() => _TanamanViewState();
}

class _TanamanViewState extends State<TanamanView> {
  List<dynamic> _tanamanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTanamanData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTanamanData(); // Refresh data when dependencies change (e.g., after adding or deleting a plant)
  }

  Future<void> fetchTanamanData() async {
    final response = await http.get(Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/listTanaman.php'));

    if (response.statusCode == 200) {
      setState(() {
        _tanamanList = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteTanaman(String idTanaman) async {
    final response = await http.post(
      Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/deleteTanaman.php'),
      body: {'id_tanaman': idTanaman},
    );

    if (response.statusCode == 200) {
      // If the delete was successful, refresh the list
      fetchTanamanData();
    } else {
      throw Exception('Failed to delete data');
    }
  }

  Future<void> editTanaman(String idTanaman) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTanaman(idTanaman: idTanaman)),
    );
  }

  Future<void> showDeleteConfirmationDialog(String idTanaman) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin menghapus tanaman ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteTanaman(idTanaman);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getImagePath(String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = path.join(directory.path, 'images', imageName);
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tanaman', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 40),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahTanaman()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tanamanList.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada data',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchTanamanData,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: _tanamanList.length,
                    itemBuilder: (context, index) {
                      final tanaman = _tanamanList[index];
                      return FutureBuilder<String>(
                        future: _getImagePath(tanaman['image']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            final imagePath = snapshot.data!;
                            return Card(
                              elevation: 8,
                              color: Colors.green,
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (tanaman['image'] != null && File(imagePath).existsSync())
                                      SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    SizedBox(height: 10),
                                    Text(
                                      tanaman['nama_tanaman'] ?? 'Belum tersedia',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Divider(color: Colors.white, thickness: 2),
                                    Text(
                                      'Jenis: ${tanaman['jenis_tanaman'] ?? 'Belum diketahui'}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Harga: ${tanaman['harga'] ?? 'Harga belum tersedia'}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Stok: ${tanaman['stok'] ?? 'Belum ada stok'}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.white),
                                          onPressed: () {
                                            editTanaman(tanaman['id_tanaman']);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.white),
                                          onPressed: () {
                                            showDeleteConfirmationDialog(tanaman['id_tanaman']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Card(
                              elevation: 8,
                              color: Colors.green,
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Container(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      tanaman['nama_tanaman'] ?? 'Belum tersedia',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Divider(color: Colors.white, thickness: 2),
                                    Text(
                                      'Jenis: ${tanaman['jenis_tanaman'] ?? 'Belum diketahui'}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Harga: ${tanaman['harga'] ?? 'Harga belum tersedia'}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Stok: ${tanaman['stok'] ?? 'Belum ada stok'}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.white),
                                          onPressed: () {
                                            editTanaman(tanaman['id_tanaman']);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.white),
                                          onPressed: () {
                                            showDeleteConfirmationDialog(tanaman['id_tanaman']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
