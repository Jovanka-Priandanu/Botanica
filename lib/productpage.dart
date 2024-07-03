import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'transaksi.dart'; transaksi user gajadi di store karna banyak bug

// menarik data product dan namaLengkap (yang sebelumnya untuk informasi detail transaksi)
class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String namaLengkap;

  ProductPage({required this.product, required this.namaLengkap});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late File _imageFile;
  bool _isLoading = true;

// download gambar dari path
  @override
  void initState() {
    super.initState();
    _downloadImage();
  }

// mendownload gambar dari path device
  Future<void> _downloadImage() async {
    final url =
        'https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/images/${widget.product['image']}';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/images/${widget.product['image']}';
    _imageFile = File(imagePath);
    await _imageFile.writeAsBytes(bytes);

    setState(() {
      _isLoading = false;
    });
  }

// format harga menjadi rupiah
  String formatRupiah(int price) {
    String rupiah = price.toString();
    String result = '';
    while (rupiah.length > 3) {
      result = '.' + rupiah.substring(rupiah.length - 3) + result;
      rupiah = rupiah.substring(0, rupiah.length - 3);
    }
    result = rupiah + result;
    return result;
  }

// tampilan utama product
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 94, 60, 1),
        title: Text(widget.product['nama_tanaman'], style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Gambar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _imageFile.existsSync()
                    ? Image.file(
                        _imageFile,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.error, size: 300),
            Divider(),
            // informasi nama tanaman, harga dan stok
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['nama_tanaman'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jenis Tanaman : ${widget.product['jenis_tanaman']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Harga: Rp ${formatRupiah(int.parse(widget.product['harga']))}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Stok: ${widget.product['stok']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  // tombol yang dseharusnya navigate ke transaksi
                  Divider(),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color.fromRGBO(27, 94, 60, 1),
                    ),
                    child: Text('BELI', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
