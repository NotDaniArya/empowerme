import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/panduan/providers/panduan_provider.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/helper_functions/helper.dart';

class CreatePanduanSheet extends ConsumerStatefulWidget {
  const CreatePanduanSheet({super.key});

  @override
  ConsumerState<CreatePanduanSheet> createState() => _CreatePanduanSheetState();
}

class _CreatePanduanSheetState extends ConsumerState<CreatePanduanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _publishersController = TextEditingController();
  final _infoLinkController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _publishersController.dispose();
    _infoLinkController.dispose();
    super.dispose();
  }

  void _submitPanduan() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (_selectedDate == null) {
      MyHelperFunction.showToast(
        context,
        'Tanggal tidak ditambahkan',
        'Harap isi kapan tanggal panduan diterbitkan.',
        ToastificationType.error,
      );
      return;
    }

    final publishedDate = DateFormat(
      'yyyy-MM-dd',
      'id_ID',
    ).format(_selectedDate!);

    ref
        .read(panduanUpdaterProvider.notifier)
        .postPanduan(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          publishers: _publishersController.text.trim(),
          publishedDate: publishedDate,
          infoLink: _infoLinkController.text.trim(),
          onSuccess: () {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Sukses',
              'Panduan berhasil diunggah.',
              ToastificationType.success,
            );
            Navigator.of(context).pop();
          },
          onError: (error) {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Gagal',
              error.toString(),
              ToastificationType.error,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(panduanUpdaterProvider);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unggah Edukasi Panduan', style: textTheme.titleMedium),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Input Konten
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Panduan',
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
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Panduan',
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
                controller: _publishersController,
                decoration: const InputDecoration(
                  labelText: 'Penerbit Panduan',
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
                controller: _infoLinkController,
                decoration: const InputDecoration(
                  labelText: 'Tautan Panduan',
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
                  onPressed: isLoading ? null : _submitPanduan,
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
