import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data.dart'; 
import 'receipt.dart';
import 'transaksi.dart'; // Import halaman Transaksi.dart

class OutLogPage extends StatefulWidget {
  @override
  _OutLogPageState createState() => _OutLogPageState();
}

class _OutLogPageState extends State<OutLogPage> {
  List _data = []; // Menyimpan data transaksi
  Map<String, List> _monthlyData = {}; // Menyimpan data transaksi yang dikelompokkan per bulan

  @override
  void initState() {
    super.initState();
    _fetchData(); // Memanggil fungsi untuk mengambil data saat inisialisasi
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData(); // Memanggil fungsi untuk mengambil data saat ada perubahan dependencies
  }

  Future<void> _fetchData() async {
    try {
      // Mengambil data transaksi dari API
      List data = await ApiTransaksi.fetchTransaksiData();

      setState(() {
        _data = data; // Menyimpan data transaksi
        _groupDataByMonth(); // Mengelompokkan data berdasarkan bulan
      });
    } catch (e) {
      print('Error fetching data: $e'); // Menampilkan pesan error jika gagal mengambil data
    }
  }

  void _groupDataByMonth() {
    // Mengelompokkan data transaksi berdasarkan bulan
    Map<String, List> groupedData = {};

    for (var entry in _data) {
      DateTime date = DateTime.parse(entry['date_out']);
      String monthYear = DateFormat('MMMM yyyy').format(date);

      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = [];
      }

      groupedData[monthYear]!.add(entry);
    }

    setState(() {
      _monthlyData = groupedData; // Menyimpan data yang sudah dikelompokkan
    });
  }

  void _showDetailDialog(Map<String, dynamic> entry) {
    // Menampilkan halaman detail transaksi
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(transactionData: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Log Stok Keluar', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 40),
            onPressed: () {
              // Navigasi ke halaman tambah transaksi
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Transaksi()),
              ).then((_) {
                _fetchData(); // Auto refresh halaman setelah tambah transaksi
              });
            },
          ),
        ],
      ),
      body: _data.isEmpty
          ? Center(child: Text('Belum ada Log keluar')) // Menampilkan pesan jika tidak ada log keluar
          : ListView.builder(
              itemCount: _monthlyData.keys.length,
              itemBuilder: (context, index) {
                String monthKey = _monthlyData.keys.elementAt(index);
                List monthEntries = _monthlyData[monthKey]!;
                return ExpansionTile(
                  title: Text(monthKey),
                  children: monthEntries.map<Widget>((entry) {
                    return ListTile(
                      title: Text('Jumlah Transaksi: ${entry['qty_out']}'),
                      subtitle: Text('Tanggal Transaksi: ${entry['date_out']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          _showDetailDialog(entry); // Menampilkan detail transaksi
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
