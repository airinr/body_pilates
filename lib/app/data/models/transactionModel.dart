enum TransactionStatus { PENDING, SUCCESS, FAILED }

class TransactionModel {
  final String transactionId;
  final String orderId;
  final int amount;
  final String paymentMethod;
  final TransactionStatus status;
  final String timestamp;

  TransactionModel({
    required this.transactionId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'orderId': orderId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status.toString().split('.').last, // Simpan string "SUCCESS"
      'timestamp': timestamp,
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      transactionId: map['transactionId'] ?? '',
      orderId: map['orderId'] ?? '',
      amount: map['amount'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => TransactionStatus.PENDING,
      ),
      timestamp: map['timestamp'] ?? '',
    );
  }
}