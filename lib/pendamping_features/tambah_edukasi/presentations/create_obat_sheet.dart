import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/obat/providers/obat_provider.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/helper_functions/helper.dart';

class CreateOBatSheet extends ConsumerStatefulWidget {
  const CreateOBatSheet({super.key});

  @override
  ConsumerState<CreateOBatSheet> createState() => _CreateObatSheetState();
}

class _CreateObatSheetState extends ConsumerState<CreateOBatSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _sourceController = TextEditingController();
  final _snippetController = TextEditingController();
  final _linkController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _snippetController.dispose();
    _sourceController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _submitObat() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (_selectedDate == null) {
      MyHelperFunction.showToast(
        context,
        'Tanggal tidak ditambahkan',
        'Harap isi kapan tanggal berita diterbitkan.',
        ToastificationType.error,
      );
      return;
    }

    final publishedDate = DateFormat(
      'yyyy-MM-dd',
      'id_ID',
    ).format(_selectedDate!);

    ref
        .read(obatUpdaterProvider.notifier)
        .postObat(
          title: _titleController.text.trim(),
          source: _sourceController.text.trim(),
          date: publishedDate,
          snippet: _snippetController.text.trim(),
          link: _linkController.text.trim(),
          onSuccess: () {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Sukses',
              'Edukasi Obat berhasil diunggah.',
              ToastificationType.success,
            );
            Navigator.of(context).pop();
          },
          onError: (error) {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Gagal',
              'Edukasi Obat Gagal diunggah',
              ToastificationType.error,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(obatUpdaterProvider);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.scaffoldPadding).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.mediumSpace,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text('Unggah Edukasi Obat', style: textTheme.titleMedium),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Input Konten
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Edukasi Obat',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _snippetController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Edukasi Obat',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deksripsi tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(
                  labelText: 'Sumber Edukasi Obat',
                  hintText: 'kompas.com',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Penerbit tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Tautan Edukasi Obat',
                  hintText: 'Tautan harus diawali dengan http atau https',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                minLines: 2,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tautan tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Input Tanggal
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null
                      ? 'Pilih Tanggal Terbit'
                      : DateFormat(
                          'd MMMM yyyy',
                          'id_ID',
                        ).format(_selectedDate!),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Tombol Aksi
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  onPressed: isLoading ? null : _submitObat,
                  text: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Unggah',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
