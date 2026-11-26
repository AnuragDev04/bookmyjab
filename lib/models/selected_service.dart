class SelectedService {
  final String title;
  final int mrp;
  final int qty;

  const SelectedService({
    required this.title,
    required this.mrp,
    required this.qty,
  });

  String get priceLabel => '₹$mrp';
}
