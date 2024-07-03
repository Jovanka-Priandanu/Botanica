// import library & package
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> transactionData;

  ReceiptPage({required this.transactionData});

  // Fungsi untuk memformat jumlah uang menjadi format mata uang Indonesia
  String formatCurrency(String amount) {
    final intAmount = int.parse(amount);
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(intAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            // Judul untuk bagian detail customer
            Text(
              'Detail Customer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Baris detail untuk username customer
            _buildDetailRow('Username Customer', transactionData['username']),
            // Baris detail untuk nama lengkap customer
            _buildDetailRow('Nama Lengkap', transactionData['nama_lengkap']),
            // Baris detail untuk alamat customer
            _buildDetailRow('Alamat', transactionData['alamat_user']),
            // Baris detail untuk nomor HP customer
            _buildDetailRow('No Hp', transactionData['no_user']),
            Divider(height: 20),
            // Judul untuk bagian detail tanaman
            Text(
              'Detail Tanaman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Baris detail untuk nama tanaman
            _buildDetailRow('Nama Tanaman', transactionData['nama_tanaman']),
            // Baris detail untuk jenis tanaman
            _buildDetailRow('Jenis Tanaman', transactionData['jenis_tanaman']),
            Divider(height: 20),
            // Judul untuk bagian detail transaksi
            Text(
              'Detail Transaksi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Baris detail untuk tanggal transaksi
            _buildDetailRow('Tanggal Transaksi', transactionData['date_out']),
            // Baris detail untuk jumlah qty
            _buildDetailRow('Qty', transactionData['qty_out']),
            // Baris detail untuk harga satuan dengan format mata uang Indonesia
            _buildDetailRow('Harga Satuan', 'Rp. ${formatCurrency(transactionData['harga'])}'),
            // Baris detail untuk total harga dengan format mata uang Indonesia
            _buildDetailRow('Total Harga', 'Rp. ${formatCurrency(transactionData['total_harga'])}', isTotal: true),
            Divider(),
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun baris detail dengan label dan nilai
  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label detail dengan teks tebal
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Nilai detail, jika isTotal true maka teks akan berwarna merah
          Text(
            value,
            style: isTotal
                ? TextStyle(fontWeight: FontWeight.bold, color: Colors.red)
                : null,
          ),
        ],
      ),
    );
  }
}
