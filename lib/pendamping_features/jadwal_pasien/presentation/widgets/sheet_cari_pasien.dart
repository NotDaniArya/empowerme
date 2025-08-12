import 'package:flutter/material.dart';

import '../../../daftar_pasien/domain/entities/pasien.dart';

class SheetCariPasien extends StatefulWidget {
  const SheetCariPasien({required this.allPatients});

  final List<Pasien> allPatients;

  @override
  State<SheetCariPasien> createState() => _SheetCariPasien();
}

class _SheetCariPasien extends State<SheetCariPasien> {
  final _searchController = TextEditingController();
  List<Pasien> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = widget.allPatients;
    _searchController.addListener(_filter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = widget.allPatients.where((pasien) {
        return pasien.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          // Judul
          Text('Cari Pasien', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          // Search Bar
          TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ketik nama pasien...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Daftar Hasil Pencarian
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = _filteredPatients[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(patient.name),
                  subtitle: Text(patient.email),
                  onTap: () {
                    // Kirim pasien yang dipilih kembali dan tutup modal
                    Navigator.of(context).pop(patient);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
