// import package, library, dan file
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data.dart'; 
import 'tambah_supply.dart'; 

class InLogPage extends StatefulWidget {
  @override
  _InLogPageState createState() => _InLogPageState();
}

// state log masuk
class _InLogPageState extends State<InLogPage> {
  // array untuk menyimpan data supply & group data berdasarkan bulan
  List _data = [];
  Map<String, List> _monthlyData = {};

// fetch data supply
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

// fetch data supply setiap kali ada perubahan (auto refresh)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

// fetch data supply dari API supply (data.dart)
  Future<void> _fetchData() async {
    try {
      List data = await ApiSupply.fetchSupplyData();
      setState(() {
        _data = data;
        _groupDataByMonth();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

// method untuk membuat group data per bulan
  void _groupDataByMonth() {
    Map<String, List> groupedData = {};

// format group bulan - tahun
    for (var entry in _data) {
      DateTime date = DateTime.parse(entry['date_in']);
      String monthYear = DateFormat('MMMM yyyy').format(date);

// jika ada data baru yang berbeda bulan, maka buat group baru
      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = [];
      }

      groupedData[monthYear]!.add(entry);
    }

    setState(() {
      _monthlyData = groupedData;
    });
  }

// method untuk menampilkan detail supply saat tombol info ditekan
  void _showDetailDialog(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Supply'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // data-data ang ditampilkan pada info detail
            children: <Widget>[
              Text('Nama Tanaman: ${entry['nama_tanaman']}'),
              Text('Jenis Tanaman: ${entry['jenis_tanaman']}'),
              Text('Nama Supplier: ${entry['nama_supplier']}'),
              Text('Stok: ${entry['stok']}'),
              Text('Quantity: ${entry['qty_in']}'),
              Text('Date: ${entry['date_in']}'),
              Text('Nama Penerima: ${entry['nama_lengkap']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// navigasi saat tombol add ditekan
  void _navigateToAddSupply() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahSupply()),
    ).then((_) {
      _fetchData(); //auto refresh page setelah tambah supply
    });
  }

// widget tampilan log masuk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Log Supply Masuk', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // tombol addd
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 40),
            onPressed: _navigateToAddSupply,
          ),
        ],
      ),
      // jika belum ada data, maka tampilkan pesan
      body: _data.isEmpty
          ? Center(child: Text('Belum ada Log masuk'))
          // jika ada data, maka tampilkan list view sesuai dengan group data
          : ListView.builder(
              itemCount: _monthlyData.keys.length,
              itemBuilder: (context, index) {
                String monthKey = _monthlyData.keys.elementAt(index);
                List monthEntries = _monthlyData[monthKey]!;
                return ExpansionTile(
                  title: Text(monthKey),
                  children: monthEntries.map<Widget>((entry) {
                    // menampilkan qty masuk dan tanggal
                    return ListTile(
                      title: Text('Qty Masuk: ${entry['qty_in']}'),
                      subtitle: Text('Tanggal: ${entry['date_in']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          _showDetailDialog(entry);
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
