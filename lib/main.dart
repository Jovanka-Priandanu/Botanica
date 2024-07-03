import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart'; // Import halaman admin
import 'storepage.dart'; // import halaman non admin
import 'data.dart'; 
import 'register.dart'; 

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter
}

class MyApp extends StatelessWidget {
  // Kelas utama aplikasi Flutter
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Memeriksa status login
  }

  Future<String?> _getNamaLengkap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('namaLengkap'); // Mendapatkan nama lengkap dari SharedPreferences
  }

  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username'); // Mendapatkan username dari SharedPreferences
  }

  Future<String?> _getUserClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userClass'); // Mendapatkan kelas pengguna dari SharedPreferences
  }

  Future<String?> _getAlamatUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('alamatUser'); // Mendapatkan alamat pengguna dari SharedPreferences
  }

  Future<String?> _getNoUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('noUser'); // Mendapatkan nomor pengguna dari SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Botanica', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(), // Mengecek status login pengguna
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat memeriksa status
          } else {
            if (snapshot.data == true) {
              return FutureBuilder<String?>(
                future: _getUserClass(), // Mendapatkan kelas pengguna
                builder: (context, userClassSnapshot) {
                  if (userClassSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat memeriksa kelas pengguna
                  } else {
                    if (userClassSnapshot.hasData && userClassSnapshot.data != null) {
                      // menidentifikasikan class user, jika userClass = admin maka akan masuk ke homepage, jika tidak maka akan masuk ke stoepage
                      String? userClass = userClassSnapshot.data;
                      if (userClass == 'admin') {
                        return FutureBuilder<String?>(
                          future: _getNamaLengkap(), // Mendapatkan nama lengkap admin
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat mendapatkan nama lengkap
                            } else {
                              if (snapshot.hasData && snapshot.data != null) {
                                return HomePage(namaLengkap: snapshot.data!); // Menampilkan halaman utama untuk admin
                              } else {
                                return LoginPage(); // Kembali ke halaman login jika tidak ada data
                              }
                            }
                          },
                        );
                      } else {
                        return FutureBuilder<String?>(
                          future: _getNamaLengkap(), // Mendapatkan nama lengkap pengguna biasa
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat mendapatkan nama lengkap
                            } else {
                              if (snapshot.hasData && snapshot.data != null) {
                                return FutureBuilder<String?>(
                                  future: _getUsername(), // Mendapatkan username pengguna
                                  builder: (context, usernameSnapshot) {
                                    if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat mendapatkan username
                                    } else {
                                      return FutureBuilder<String?>(
                                        future: _getAlamatUser(), // Mendapatkan alamat pengguna
                                        builder: (context, alamatUserSnapshot) {
                                          if (alamatUserSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat mendapatkan alamat pengguna
                                          } else {
                                            return FutureBuilder<String?>(
                                              future: _getNoUser(), // Mendapatkan nomor pengguna
                                              builder: (context, noUserSnapshot) {
                                                if (noUserSnapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat mendapatkan nomor pengguna
                                                } else {
                                                  return StorePage(
                                                    namaLengkap: snapshot.data!, // Menampilkan halaman toko untuk pengguna biasa
                                                    username: usernameSnapshot.data!,
                                                    alamatUser: alamatUserSnapshot.data!,
                                                    noUser: noUserSnapshot.data!,
                                                  );
                                                }
                                              },
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              } else {
                                return LoginPage(); // Kembali ke halaman login jika tidak ada data
                              }
                            }
                          },
                        );
                      }
                    } else {
                      return LoginPage(); // Kembali ke halaman login jika tidak ada data
                    }
                  }
                },
              );
            } else {
              return LoginPage(); // Kembali ke halaman login jika tidak ada data
            }
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiLogin _apiLogin = ApiLogin(); // Menginisialisasi objek untuk API login

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Username dan password harus diisi'), // Memeriksa apakah username dan password kosong
      ));
      return;
    }

    List<User> users = await _apiLogin.fetchUsers(); // Mengambil daftar pengguna dari API
    bool isAuthenticated = false;
    String? namaLengkap;
    String? userClass; // Mengasumsikan kelas pengguna dalam model User
    String? alamatUser;
    String? noUser;

    for (var user in users) {
      if (user.username == username && user.password == password) {
        isAuthenticated = true;
        namaLengkap = user.namaLengkap; // Mengisi nama lengkap jika autentikasi berhasil
        userClass = user.userClass; // Mengisi kelas pengguna jika autentikasi berhasil
        alamatUser = user.alamatUser; // Mengisi alamat pengguna jika autentikasi berhasil
        noUser = user.noUser; // Mengisi nomor pengguna jika autentikasi berhasil
        break;
      }
    }

    if (isAuthenticated) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Menyimpan status login sebagai true
      await prefs.setString('namaLengkap', namaLengkap!); // Menyimpan nama lengkap pengguna
      await prefs.setString('userClass', userClass!); // Menyimpan kelas pengguna
      await prefs.setString('username', username); // Menyimpan username
      await prefs.setString('alamatUser', alamatUser!); // Menyimpan alamat pengguna
      await prefs.setString('noUser', noUser!); // Menyimpan nomor pengguna

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Selamat datang $namaLengkap'), // Menampilkan snackbar selamat datang
      ));

      // Tunggu SnackBar ditampilkan
      await Future.delayed(Duration(seconds: 1));

      // Tentukan halaman tujuan berdasarkan kelas pengguna
      if (userClass == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(namaLengkap: namaLengkap!)), // Pindah ke halaman utama untuk admin
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StorePage(namaLengkap: namaLengkap!, username: username, alamatUser: alamatUser!, noUser: noUser!)), // Pindah ke halaman toko untuk pengguna biasa
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Username atau Password salah'), // Menampilkan snackbar jika autentikasi gagal
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login-bg.png'), // Mengatur gambar latar belakang
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Text(
                        'Welcome Botanica', 
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Ketik Username...', 
                      labelStyle: TextStyle(color: Colors.white),
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Ketik Password...', 
                      labelStyle: TextStyle(color: Colors.white),
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login, // Tombol untuk melakukan login
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text('Login', style: TextStyle(color: Colors.green)),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RegisterPage()), // Navigasi ke halaman pendaftaran
                        );
                      },
                      child: Text(
                        'Belum punya akun?', // Teks untuk mendaftar
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Opacity(
              opacity: 0.8,
              child: Text(
                '© 2024 Biotanic made by Jovanka', // Teks kredit
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
