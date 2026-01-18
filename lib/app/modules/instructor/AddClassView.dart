import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/AddClassController.dart';

class AddClassView extends GetView<AddClassController> {
  const AddClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kelas'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            children: [
              _textField(label: 'Nama Kelas', controller: controller.titleC),

              /// TANGGAL
              _textField(
                label: 'Tanggal',
                controller: controller.dateC,
                readOnly: true,
                suffix: Icons.calendar_today,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2035),
                  );

                  if (picked != null) {
                    controller.dateC.text = picked.toIso8601String().split(
                      'T',
                    )[0];
                  }
                },
              ),

              /// WAKTU
              _textField(
                label: 'Waktu',
                controller: controller.timeC,
                readOnly: true,
                suffix: Icons.access_time,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (picked != null) {
                    controller.timeC.text =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                  }
                },
              ),

              /// HARGA
              _textField(
                label: 'Harga',
                controller: controller.priceC,
                keyboard: TextInputType.number,
                prefix: 'Rp ',
              ),

              const SizedBox(height: 24),

              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.saveClass,
                        child: const Text(
                          'Simpan Kelas',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    String? prefix,
    IconData? suffix,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix,
          suffixIcon: suffix != null ? Icon(suffix) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
