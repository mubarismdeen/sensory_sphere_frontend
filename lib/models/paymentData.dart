class PaymentData {
  final String name;
  final double amount;
  bool isPaid;

  PaymentData({required this.name, required this.amount, this.isPaid = false});
}