class CouponModel {
  double? percentOff;
  double maxAmount;
  double minAmountRequired;
  int maxCoupons;
  int remainingCoupons;

  CouponModel({
    this.percentOff,
    required this.maxAmount,
    required this.minAmountRequired,
    required this.maxCoupons,
    required this.remainingCoupons,
  });

  CouponModel.fromJson(Map<String, dynamic> json)
      : percentOff = json['percentOff'] as double?,
        maxAmount = json['maxAmount'] as double,
        minAmountRequired = json['minAmountRequired'] as double,
        maxCoupons = json['maxCoupons'] as int,
        remainingCoupons = json['remainingCoupons'] as int;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentOff'] = percentOff;
    data['maxAmount'] = maxAmount;
    data['minAmountRequired'] = minAmountRequired;
    data['maxCoupons'] = maxCoupons;
    data['remainingCoupons'] = remainingCoupons;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
