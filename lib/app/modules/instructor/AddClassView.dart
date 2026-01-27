import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/AddClassController.dart';
import '../../core/theme/app_colors.dart';

class AddClassView extends GetView<AddClassController> {
  const AddClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink, // Background Biru Muda
      appBar: AppBar(
        title: const Text(
          'Buat Kelas Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryPink, // Biru Utama
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // HEADER ILLUSTRATION (Opsional, agar tidak sepi)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_calendar_rounded,
                  size: 40,
                  color: AppColors.primaryPink,
                ),
              ),

              // FORM CARD
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detail Kelas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPink,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. NAMA KELAS
                      _buildTextField(
                        label: 'Nama Kelas',
                        hint: 'Contoh: Yoga Pagi',
                        controller: controller.titleC,
                        icon: Icons.title_rounded,
                      ),

                      const SizedBox(height: 16),

                      // 2. ROW: TANGGAL & WAKTU (Side by Side)
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Tanggal',
                              controller: controller.dateC,
                              readOnly: true,
                              icon: Icons.calendar_today_rounded,
                              isClickable: true,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2035),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: AppColors.primaryPink,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  controller.dateC.text = picked
                                      .toIso8601String()
                                      .split('T')[0];
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'Waktu',
                              controller: controller.timeC,
                              readOnly: true,
                              icon: Icons.access_time_rounded,
                              isClickable: true,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: AppColors.primaryPink,
                                          onSurface:
                                              Colors.black, // Warna angka jam
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  // ignore: use_build_context_synchronously
                                  controller.timeC.text = picked.format(
                                    context,
                                  ); // Format HH:mm AM/PM sesuai locale
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 3. HARGA
                      _buildTextField(
                        label: 'Harga Tiket',
                        controller: controller.priceC,
                        keyboard: TextInputType.number,
                        icon: Icons.monetization_on_outlined,
                        prefix: 'Rp ',
                      ),

                      const SizedBox(height: 32),

                      // 4. BUTTON SIMPAN
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPink,
                            elevation: 4,
                            shadowColor: AppColors.primaryPink.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.saveData,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Simpan & Publikasikan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Input Field yang lebih cantik
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    String? prefix,
    IconData? icon,
    bool isClickable = false, // Untuk field Date/Time
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isClickable
              ? onTap
              : null, // Jika clickable, InkWell menangani tap
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: controller,
            keyboardType: keyboard,
            readOnly:
                readOnly, // Jika isClickable=true, TextField harus readonly agar keyboard tidak muncul
            enabled:
                !isClickable, // Trik UI: jika clickable (Date/Time), disable textfield native interaction
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.normal,
              ),
              prefixText: prefix,
              prefixStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              suffixIcon: icon != null
                  ? Icon(icon, color: AppColors.primaryPink)
                  : null,
              filled: true,
              fillColor: Colors.grey[50], // Background field abu sangat muda
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryPink,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                // Style saat isClickable = true (tapi TextField disabled)
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
