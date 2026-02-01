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
      backgroundColor: AppColors.backgroundPink,
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

        if (kelas == null) {
          return const Center(child: Text("Data kelas tidak ditemukan"));
        }

        // Panggil Method Tampilan
        return showClassDetailBefore(kelas);
      }),
    );
  }

  // ==========================================
  // METHOD SESUAI CLASS DIAGRAM
  // ==========================================

  Widget showClassDetailBefore(ClassModel kelas) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // --- CARD INFO KELAS ---
                Container(
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
                      // Header Icon
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
                      
                      // Content Text
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kelas.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Segera amankan slotmu sekarang sebelum kehabisan!",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(height: 1),
                            const SizedBox(height: 24),
                            
                            // Info Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailItem(
                                    Icons.calendar_month_rounded,
                                    "Tanggal",
                                    kelas.date,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.grey[200],
                                ),
                                Expanded(
                                  child: _buildDetailItem(
                                    Icons.access_time_filled_rounded,
                                    "Waktu",
                                    kelas.time,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                             Row(
                              children: [
                                Expanded(
                                  child: _buildDetailItem(
                                    Icons.monetization_on_rounded,
                                    "Harga Kelas",
                                    "Rp ${kelas.price}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- BOTTOM BAR ---
        Container(
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
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  elevation: 5,
                  shadowColor: AppColors.primaryPink.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // Panggil onPayClick (Navigasi Langsung)
                onPressed: () => onPayClick(controller.userId, kelas.idClass),
                
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lanjut ke Pembayaran",
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
          ),
        ),
      ],
    );
  }

  // 2. Method Navigasi Langsung (Tanpa Controller)
  void onPayClick(String idUser, String idClass) {
    // Ambil detail kelas dari controller untuk dikirim ke Payment
    final kelas = controller.classDetail.value;
    
    if (kelas != null) {
      // 🔥 LANGSUNG NAVIGASI DI SINI (VIEW LOGIC)
      Get.toNamed(
        '/payment',
        arguments: {
          'idClass': idClass,
          'className': kelas.title,
          'price': kelas.price,
          'idUser': idUser,
        },
      );
    }
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryPink, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
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
}