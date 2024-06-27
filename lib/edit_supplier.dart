// import 'package:flutter/material.dart';
// import 'data.dart';

// class EditSupplier extends StatefulWidget {
//   final Supplier supplier;

//   EditSupplier({required this.supplier});

//   @override
//   _EditSupplierState createState() => _EditSupplierState();
// }

// class _EditSupplierState extends State<EditSupplier> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _namaController;
//   late TextEditingController _alamatController;
//   late TextEditingController _noController;
//   late TextEditingController _emailController;

//   @override
//   void initState() {
//     super.initState();
//     _namaController = TextEditingController(text: widget.supplier.namaSupplier);
//     _alamatController = TextEditingController(text: widget.supplier.alamatSupplier);
//     _noController = TextEditingController(text: widget.supplier.noSupplier);
//     _emailController = TextEditingController(text: widget.supplier.email);
//   }

//   Future<void> _editSupplier() async {
//     if (_formKey.currentState!.validate()) {
//       String nama = _namaController.text;
//       String alamat = _alamatController.text;
//       String no = _noController.text;
//       String email = _emailController.text;

//       ApiSupplier apiSupplier = ApiSupplier();
//       bool isSuccess = await apiSupplier.updateSupplier(
//         widget.supplier.idSupplier,
//         nama,
//         alamat,
//         no,
//         email,
//       );

//       if (isSuccess) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Supplier berhasil diperbarui')),
//         );
//         Navigator.of(context).pop();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Gagal memperbarui supplier')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Supplier', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _namaController,
//                 decoration: InputDecoration(
//                   labelText: 'Nama Supplier',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Nama supplier tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _alamatController,
//                 decoration: InputDecoration(
//                   labelText: 'Alamat Supplier',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Alamat supplier tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _noController,
//                 decoration: InputDecoration(
//                   labelText: 'No Supplier',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'No supplier tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email Supplier',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email supplier tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               GestureDetector(
//                 onTap: _editSupplier,
//                 child: Container(
//                   width: double.infinity,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.green,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Update',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
