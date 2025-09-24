import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/providers/pasien_provider.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/providers/jadwal_pasien_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';
import 'package:toastification/toastification.dart';

import '../widgets/sheet_cari_pasien.dart';

class TambahJadwalScreen extends ConsumerStatefulWidget {
  const TambahJadwalScreen({super.key, required this.jadwalType});

  final TipeJadwal jadwalType;

  @override
  ConsumerState<TambahJadwalScreen> createState() => _TambahJadwalScreenState();
}

class _TambahJadwalScreenState extends ConsumerState<TambahJadwalScreen> {
  final _formKey = GlobalKey<FormState>();

  Pasien? _selectedPasien;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _locationController = TextEditingController();
  final _meetWithController = TextEditingController();
  final _typeDrugController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _meetWithController.dispose();
    _typeDrugController.dispose();
    super.dispose();
  }

  void _showPatientSearchModal() async {
    final selectedPatient = await showModalBottomSheet<Pasien>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _PasienListModalContent(),
    );

    if (selectedPatient != null) {
      setState(() {
        _selectedPasien = selectedPatient;
      });
    }
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid ||
        _selectedPasien == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      MyHelperFunction.showToast(
        context,
        'Data Tidak Lengkap',
        'Harap isi semua field yang wajib diisi.',
        ToastificationType.error,
      );
      return;
    }
    _formKey.currentState!.save();

    final dateOnly = DateFormat('yyyy-MM-dd', 'id_ID').format(_selectedDate!);
    final timeOnly =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00';

    if (widget.jadwalType == TipeJadwal.terapi) {
      ref
          .read(jadwalPasienUpdaterProvider.notifier)
          .addJadwalTerapi(
            id: _selectedPasien!.id,
            date: dateOnly.toString(),
            time: timeOnly,
            location: _locationController.text,
            meetWith: _meetWithController.text,
            onSuccess: () {
              if (!mounted) return;
              MyHelperFunction.showToast(
                context,
                'Sukses',
                'Jadwal terapi berhasil ditambahkan.',
                ToastificationType.success,
              );
              Navigator.of(context).pop();
            },
            onError: (error) {
              if (!mounted) return;
              MyHelperFunction.showToast(
                context,
                'Gagal',
                'Jadwal terapi gagal ditambahkan',
                ToastificationType.error,
              );
            },
          );
    } else if (widget.jadwalType == TipeJadwal.ambilObat) {
      ref
          .read(jadwalPasienUpdaterProvider.notifier)
          .addJadwalAmbilObat(
            id: _selectedPasien!.id,
            date: dateOnly,
            time: timeOnly,
            location: _locationController.text,
            meetWith: _meetWithController.text,
            typeDrug: _typeDrugController.text,
            onSuccess: () {
              if (!mounted) return;
              MyHelperFunction.showToast(
                context,
                'Sukses',
                'Jadwal ambil obat berhasil ditambahkan.',
                ToastificationType.success,
              );
              Navigator.of(context).pop();
            },
            onError: (error) {
              if (!mounted) return;
              MyHelperFunction.showToast(
                context,
                'Gagal',
                'Gagal menambah jadwal ambil obat',
                ToastificationType.error,
              );
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isTerapi = widget.jadwalType == TipeJadwal.terapi;
    final title = isTerapi ? 'Jadwal Terapi Baru' : 'Jadwal Ambil Obat Baru';

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Pasien',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: _showPatientSearchModal,
                    leading: const Icon(Icons.person_search),
                    title: Text(
                      _selectedPasien?.name ?? 'Pilih salah satu pasien',
                    ),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                Text(
                  'Detail Jadwal',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null)
                            setState(() => _selectedDate = date);
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _selectedDate == null
                              ? 'Pilih Tanggal'
                              : DateFormat(
                                  'd-MM-yyyy',
                                  'id_ID',
                                ).format(_selectedDate!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) setState(() => _selectedTime = time);
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _selectedTime == null
                            ? 'Pilih Waktu'
                            : '${_selectedTime!.format(context)} WITA',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Lokasi tidak boleh kosong.'
                      : null,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                TextFormField(
                  controller: _meetWithController,
                  decoration: const InputDecoration(
                    labelText: 'Bertemu Dengan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Field ini tidak boleh kosong.'
                      : null,
                ),

                if (!isTerapi) ...[
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    controller: _typeDrugController,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Obat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Jenis obat tidak boleh kosong.'
                        : null,
                  ),
                ],

                const SizedBox(height: TSizes.spaceBtwSections * 2),

                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    onPressed: _submit,
                    text: const Text(
                      'Simpan Jadwal',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasienListModalContent extends ConsumerWidget {
  const _PasienListModalContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPasienAsync = ref.watch(allPasienProvider);

    return allPasienAsync.when(
      loading: () => const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 300,
        child: Center(child: Text('Gagal memuat pasien: $err')),
      ),
      data: (pasienList) => SheetCariPasien(allPatients: pasienList),
    );
  }
}
