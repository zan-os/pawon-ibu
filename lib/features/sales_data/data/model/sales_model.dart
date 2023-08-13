class SalesModel {
  SalesModel({this.month = '', this.sales = 0, this.incomes});

  final String? month;
  final int? incomes;
  final int? sales;

  SalesModel copyWith({
    String? month,
    int? incomes,
    int? sales,
  }) {
    return SalesModel(
      month: month ?? this.month,
      incomes: incomes ?? this.incomes,
      sales: sales ?? this.sales,
    );
  }
}
