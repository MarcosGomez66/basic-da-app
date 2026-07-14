class ItemDraft {
  final String productId;
  final String lotId;
  String productName;
  double amount;
  double unityPrice;

  ItemDraft({
    required this.productId,
    required this.lotId,
    required this.productName,
    required this.amount,
    required this.unityPrice,
});
}