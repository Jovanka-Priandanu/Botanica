import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String username;
  final String password;
  final String namaLengkap;

  User({
    required this.username,
    required this.password,
    required this.namaLengkap,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      namaLengkap: json['nama_lengkap'],
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







