class TableOption {
  final double price;
  final int allowed;

  TableOption.fromJson(Map<String, dynamic> json)
      : allowed = json['allowed'] as int,
        price = double.parse(json['price'].toString());
}
