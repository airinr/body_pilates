import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/ClassBeforeController.dart';
import '../../data/models/classModel.dart';
import '../../core/theme/app_colors.dart';

class ClassBeforeView extends GetView<ClassBeforeController> {
  const ClassBeforeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink, // Background biru muda
      appBar: AppBar(
        title: const Text(
          "Detail Booking",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryPink),
          );
        }

        final ClassModel? kelas = controller.classDetail.value;

        // ⛔ SAFETY CHECK
        if (kelas == null) {
          return const Center(child: Text("Data kelas tidak ditemukan"));
        }

        return Column(
          children: [
            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // KARTU UTAMA (Preview Kelas)
                    _buildMainCard(kelas),

                    const SizedBox(height: 20),

                    // KARTU BENEFIT / INFO TAMBAHAN (Opsional)
                    _buildInfoNote(),
                  ],
                ),
              ),
            ),

            // BOTTOM ACTION BAR (Tombol Bayar)
            _buildBottomPaymentBar(kelas),
          ],
        );
      }),
    );
  }

  // =============================
  // WIDGETS KOMPONEN
  // =============================

  Widget _buildMainCard(ClassModel kelas) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER IMAGE / ICON
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.softPink.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fitness_center_rounded,
                size: 60,
                color: AppColors.primaryPink.withOpacity(0.5),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // JUDUL KELAS
                Text(
                  kelas.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Segera amankan slotmu sekarang!",
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 24),

                // GRID INFO (Tanggal & Waktu)
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.calendar_month_rounded,
                        "Tanggal",
                        kelas.date,
                      ),
                    ),
                    Container(height: 40, width: 1, color: Colors.grey[200]),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.access_time_filled_rounded,
                        "Waktu",
                        kelas.time,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryPink, size: 28),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.grey[400]),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Pembayaran akan diverifikasi otomatis oleh sistem.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPaymentBar(ClassModel kelas) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ROW TOTAL HARGA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Pembayaran",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Rp ${kelas.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryPink, // Warna Biru Utama
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // TOMBOL BAYAR
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink, // Warna Biru Utama
                  elevation: 5,
                  shadowColor: AppColors.primaryPink.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () =>
                    controller.payClass(controller.userId, controller.idClass),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bayar & Gabung Kelas",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
