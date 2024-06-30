import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'tambah_supply.dart'; // Import the TambahSupplyPage

class InLogPage extends StatefulWidget {
  @override
  _InLogPageState createState() => _InLogPageState();
}

class _InLogPageState extends State<InLogPage> {
  List _data = [];
  Map<String, List> _monthlyData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/pengadaan/listSupply.php'));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _groupDataByMonth();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _groupDataByMonth() {
    Map<String, List> groupedData = {};

    for (var entry in _data) {
      DateTime date = DateTime.parse(entry['date_in']);
      String monthYear = DateFormat('MMMM yyyy').format(date);

      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = [];
      }

      groupedData[monthYear]!.add(entry);
    }

    setState(() {
      _monthlyData = groupedData;
    });
  }

  void _showDetailDialog(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Supply'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nama Tanaman: ${entry['nama_tanaman']}'),
              Text('Jenis Tanaman: ${entry['jenis_tanaman']}'),
              Text('Nama Supplier: ${entry['nama_supplier']}'),
              Text('Stok: ${entry['stok']}'),
              Text('Quantity: ${entry['qty_in']}'),
              Text('Date: ${entry['date_in']}'),
              Text('Nama Lengkap: ${entry['nama_lengkap']}'),
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

  void _navigateToAddSupply() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahSupply()),
    );
  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 40),
            onPressed: _navigateToAddSupply,
          ),
        ],
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _monthlyData.keys.length,
              itemBuilder: (context, index) {
                String monthKey = _monthlyData.keys.elementAt(index);
                List monthEntries = _monthlyData[monthKey]!;
                return ExpansionTile(
                  title: Text(monthKey),
                  children: monthEntries.map<Widget>((entry) {
                    return ListTile(
                      title: Text('Quantity: ${entry['qty_in']}'),
                      subtitle: Text('Date: ${entry['date_in']}'),
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
