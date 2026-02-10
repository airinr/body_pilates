import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/PaymentController.dart';
import '../../core/theme/app_colors.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return paymentPage();
  }

  Widget paymentPage() {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink,
      appBar: AppBar(
        title: const Text("Konfirmasi Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: AppColors.backgroundPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: AppColors.primaryPink.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        children: [
                          const Text("Total Tagihan", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text("Rp ${controller.price}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryPink)),
                          const SizedBox(height: 20),
                          const Divider(),
                          _rowItem("Kelas", controller.className),
                          const SizedBox(height: 8),
                          _rowItem("Admin Fee", "Rp 0"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Metode Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedPaymentMethod.value,
                          isExpanded: true,
                          items: [
                            'Transfer Bank (BCA)', 'Transfer Bank (Mandiri)', 'E-Wallet (Gopay)', 'QRIS'
                          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => controller.selectedPaymentMethod.value = val!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => onPayClicked(controller.selectedPaymentMethod.value),
                  child: const Text("Konfirmasi Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _rowItem(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]);
  }

  void onPayClicked(String method) {
    controller.createTransaction();
  }
  
  void showVirtualAccount(String vaNumber) {
    // Logic dialog VA jika perlu
  }
  
  void showAlert(String message) {
    Get.snackbar("Info", message);
  }
}