import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/ClassAfterController.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class ClassAfterView extends GetView<ClassAfterController> {
  const ClassAfterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tema utama (bisa disesuaikan dengan branding)
    final Color primaryColor = const Color(0xFF2563EB); // Royal Blue
    final Color accentColor = const Color(0xFFEFF6FF); // Light Blue bg

    return Scaffold(
      backgroundColor: accentColor,
      body: Stack(
        children: [
          // 1. BACKGROUND DEKORATIF (Gradient Header)
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, const Color(0xFF60A5FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Text(
                          "Tiket Kelas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer penyeimbang
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // BODY CONTENT
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final ClassModel? kelas = controller.classDetail.value;
                    if (kelas == null) {
                      return const Center(
                        child: Text(
                          "Data tidak ditemukan",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return _buildTicketLayout(kelas, primaryColor);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketLayout(ClassModel kelas, Color primaryColor) {
    final member = Get.find<MemberModel>();
    final bool isPresent = kelas.isUserPresent(member.uid);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // --- KARTU TIKET ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // BAGIAN ATAS TIKET (Detail Kelas)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildChip("PAID", Colors.green),
                          Icon(
                            Icons.sports_gymnastics,
                            color: Colors.grey[300],
                            size: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Judul Kelas
                      Text(
                        kelas.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Pastikan hadir tepat waktu",
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Info Grid (Tanggal & Waktu)
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoBox(
                              icon: Icons.calendar_month,
                              title: "TANGGAL",
                              value: kelas.date, // Format: 12 Okt 2024
                              color: Colors.blue.shade50,
                              iconColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoBox(
                              icon: Icons.access_time_filled,
                              title: "JAM",
                              value: kelas.time, // Format: 09:00 AM
                              color: Colors.orange.shade50,
                              iconColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // GARIS PUTUS-PUTUS (Divider Tiket)
                _buildDashedDivider(),

                // BAGIAN BAWAH TIKET (QR / Action Area)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white, // Tetap putih
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (isPresent)
                        _buildCheckInSuccess()
                      else
                        Column(
                          children: [
                            Text(
                              "Scan QR Code di lokasi",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildScanButtonElegant(
                              kelas.idClass,
                              primaryColor,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Footer text
          Text(
            "Scan Ticket unttuk melakukan presensi",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- WIDGET KOMPONEN ---

  Widget _buildScanButtonElegant(String idClass, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => controller.showQRScan(idClass),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.qr_code_scanner_rounded),
            SizedBox(width: 12),
            Text(
              "SCAN PRESENSI",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInSuccess() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5), // Emerald 50
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.verified, color: Color(0xFF10B981), size: 28),
          SizedBox(width: 12),
          Text(
            "SUDAH HADIR",
            style: TextStyle(
              color: Color(0xFF047857),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildDashedDivider() {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Garis putus-putus
          LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  (constraints.constrainWidth() / 10).floor(),
                  (_) => SizedBox(
                    width: 5,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                    ),
                  ),
                ),
              );
            },
          ),
          // Lingkaran "sobekan" kiri
          Positioned(
            left: -15,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color(
                  0xFFEFF6FF,
                ), // Harus sama dengan background scaffold
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Lingkaran "sobekan" kanan
          Positioned(
            right: -15,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color(
                  0xFFEFF6FF,
                ), // Harus sama dengan background scaffold
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
