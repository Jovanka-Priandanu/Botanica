import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  // deklare variabel yang menarik data dari lgoinpage
  final String namaLengkap;
  final String username;
  final String alamatUser;
  final String noUser;

  ProfilePage({required this.namaLengkap, required this.username, required this.alamatUser, required this.noUser});

  @override
  Widget build(BuildContext context) {
    // topbar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 94, 60, 1),
        title: Text('Profil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // scrolling biar gak overflown
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              // informasi user
              SizedBox(height: 16.0),
              Divider(),
              ListTile(
                title: Text(
                  'Nama Lengkap',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  namaLengkap.isNotEmpty ? namaLengkap : '-',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Username',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  username.isNotEmpty ? username : '-',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Alamat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  alamatUser.isNotEmpty ? alamatUser : '-',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'No. Telepon',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  noUser.isNotEmpty ? noUser : '-',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
