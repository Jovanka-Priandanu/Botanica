import 'dart:convert';
import 'package:http/http.dart' as http;

// API Login
// Deklarasi variabel Login
class User {
  final String username;
  final String password;
  final String namaLengkap;
  final String userClass;
  final String alamatUser;
  final String noUser;

  User({
    required this.username,
    required this.password,
    required this.namaLengkap,
    required this.userClass,
    required this.alamatUser,
    required this.noUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      namaLengkap: json['nama_lengkap'],
      userClass: json['class'],
      alamatUser: json['alamat_user'],
      noUser: json['no_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'nama_lengkap': namaLengkap,
    };
  }
}

// Menarik data login yang tersedia berdasarkan data API
class ApiLogin {
  final String baseUrl =
      'https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/user/';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/User.php'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<User> users =
          body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Gagal menarik data user');
    }
  }
}

// API Tambah User
Future<http.Response> createUser(String username, String password, String namaLengkap) async {
  String apiUrl = "https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/user/addUser.php";

  try {
    var response = await http.post(Uri.parse(apiUrl), body: {
      'username': username,
      'password': password,
      'nama_lengkap': namaLengkap,
    });
    return response;
  } catch (e) {
    throw e; 
  }
}


// Data API Supplier
// Deklarasi Variabel Supplier
class Supplier {
  final String idSupplier;
  final String namaSupplier;
  final String alamatSupplier;
  final String noSupplier;
  final String email;

  Supplier({
    required this.idSupplier,
    required this.namaSupplier,
    required this.alamatSupplier,
    required this.noSupplier,
    required this.email,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      idSupplier: json['id_supplier'],
      namaSupplier: json['nama_supplier'],
      alamatSupplier: json['alamat_supplier'],
      noSupplier: json['no_supplier'],
      email: json['email'],
    );
  }
}

// List Supplier
class ApiSupplier {
  static const String baseUrl = 'https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/supplier';

  Future<List<Supplier>> fetchSuppliers() async {
    final response = await http.get(Uri.parse('$baseUrl/listSupplier.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((supplier) => Supplier.fromJson(supplier)).toList();
    } else {
      throw Exception('Gagal mengambil data supplier');
    }
  }

  // Tambah Supplier
  Future<bool> addSupplier(String nama, String alamat, String no, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addSupplier.php'),
      body: {
        'nama_supplier': nama,
        'alamat_supplier': alamat,
        'no_supplier': no,
        'email': email,
      },
    );

    // cek response status
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Delete Supplier
   Future<void> deleteSupplier(String idSupplier) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deleteSupplier.php'),
      body: {'id_supplier': idSupplier},
    );

  // jika respon bukan code 200, maka error
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data supplier');
    }
  }

  // Detail Supplier
  Future<Supplier> detailSupplierById(String idSupplier) async {
    final response = await http.get(Uri.parse('$baseUrl/detailSupplier.php?id_supplier=$idSupplier'));
    if (response.statusCode == 200) {
      return Supplier.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menarik data berdasarkan ID Supplier');
    }
  }

  // Edit Supplier
   Future<bool> editSupplier(String idSupplier, String nama, String alamat, String no, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/editSupplier.php'),
      body: {
        'id_supplier': idSupplier,
        'nama_supplier': nama,
        'alamat_supplier': alamat,
        'no_supplier': no,
        'email': email,
      },
    );
    return response.statusCode == 200;
  }
}

// API SUPPLY Masuk
class ApiSupply {
  static const String baseUrl = 'https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/pengadaan';

  static Future<List<dynamic>> fetchSupplyData() async {
    final response = await http.get(Uri.parse('$baseUrl/listSupply.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

// fetch data tanaman
class ApiData {
  static Future<List<Map<String, dynamic>>> fetchNamaTanaman() async {
    final tanamanUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/tanaman/listTanaman.php');
    try {
      final responseTanaman = await http.get(tanamanUrl);
      if (responseTanaman.statusCode == 200) {
        final jsonData = json.decode(responseTanaman.body) as List;
        return jsonData.map((item) => {
          'id_tanaman': item['id_tanaman'],
          'nama_tanaman': item['nama_tanaman'],
        }).toList();
      } else {
        throw Exception('Failed to load nama tanaman data');
      }
    } catch (error) {
      print('Error fetching nama tanaman data: $error');
      throw error;
    }
  }


  // fetch data supplier
  static Future<List<Map<String, dynamic>>> fetchNamaSupplier() async {
    final supplierUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/supplier/listSupplier.php');
    try {
      final responseSupplier = await http.get(supplierUrl);
      if (responseSupplier.statusCode == 200) {
        final jsonData = json.decode(responseSupplier.body) as List;
        return jsonData.map((item) => {
          'id_supplier': item['id_supplier'],
          'nama_supplier': item['nama_supplier'],
        }).toList();
      } else {
        throw Exception('Failed to load nama supplier data');
      }
    } catch (error) {
      print('Error fetching nama supplier data: $error');
      throw error;
    }
  }

  // fetch data penerima yang teridentifikasi class == admin
  static Future<List<Map<String, dynamic>>> fetchNamaPenerima() async {
    final userUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/user/User.php');
    try {
      final responseUser = await http.get(userUrl);
      if (responseUser.statusCode == 200) {
        final jsonData = json.decode(responseUser.body) as List;
        return jsonData
            .where((item) => item['class'] == 'admin')
            .map((item) => {
                  'id_user': item['id_user'],
                  'nama_lengkap': item['nama_lengkap'],
                })
            .toList();
      } else {
        throw Exception('Failed to load nama penerima data');
      }
    } catch (error) {
      print('Error fetching nama penerima data: $error');
      throw error;
    }
  }

// API simpan penambahan data supply masuk
  static Future<Map<String, dynamic>> saveSupply({
    required String idTanaman,
    required String idSupplier,
    required String idPenerima,
    required String quantity,
    required String date,
  }) async {
    final addSupplyUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/pengadaan/addSupply.php');
    try {
      final response = await http.post(
        addSupplyUrl,
        body: {
          'id_tanaman': idTanaman,
          'id_supplier': idSupplier,
          'id_user': idPenerima,
          'qty_in': quantity,
          'date_in': date,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save data');
      }
    } catch (error) {
      print('Error saving data: $error');
      throw error;
    }
  }
}


// API Transaksi
// list Transaksi (view)
class ApiTransaksi {
  static const String baseUrl = 'https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/transaksi';

  static Future<List<dynamic>> fetchTransaksiData() async {
    final response = await http.get(Uri.parse('$baseUrl/listTransaksi.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

// menarik data user yang teridentifikasi class bukan admin (untuk dropdown)
  static Future<List<Map<String, dynamic>>> fetchNamaCustomer() async {
    final userUrl = Uri.parse('https://mi05421.my.id/api_uas_jovanka/API-UAS-jovanka/user/User.php');
    try {
      final responseUser = await http.get(userUrl);
      if (responseUser.statusCode == 200) {
        final jsonData = json.decode(responseUser.body) as List;
        return jsonData
            .where((item) => item['class'] != 'admin')
            .map((item) => {
                  'id_user': item['id_user'],
                  'nama_lengkap': item['nama_lengkap'],
                })
            .toList();
      } else {
        throw Exception('Failed to load nama penerima data');
      }
    } catch (error) {
      print('Error fetching nama penerima data: $error');
      throw error;
    }
  }
  
  // simpan transaksi
  static Future<Map<String, dynamic>> saveTransaksi({
    required String idTanaman,
    required String idPenerima,
    required String quantity,
    required String date,
  }) async {
    final addTransaksiUrl = Uri.parse('$baseUrl/addTransaksi.php');
    try {
      final response = await http.post(
        addTransaksiUrl,
        body: {
          'id_tanaman': idTanaman,
          'id_user': idPenerima,
          'qty_out': quantity,
          'date_out': date,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save data');
      }
    } catch (error) {
      print('Error saving data: $error');
      throw error;
    }
  }
}




