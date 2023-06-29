class HistoricUpdate {
  int id;
  int status;
  String paymentType;

  HistoricUpdate(this.id, this.status, this.paymentType);
}

class HistoricUpdateConverter {
  static const String idPurchase= 'id_purchase';
  static const String status = 'status';
  static const String paymentType = 'payment_type';
  

  static HistoricUpdate fromJson(Map<String, dynamic> json) {
    return HistoricUpdate(
      json[idPurchase] as int,
      json[status] as int,
      json[paymentType],
    );
  }

  static Map<String, dynamic> toJson(HistoricUpdate item) {
    return {
      idPurchase: item.id,
      status: item.status,
      paymentType: item.paymentType,
    };
  }
}