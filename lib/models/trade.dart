class TradeModel {
  final int tradeId;
  final int initiatorId;
  final String? initiatorName;
  final int receiverId;
  final String? receiverName;
  final String status;
  final String createdAt;
  final String updatedAt;

  TradeModel({
    required this.tradeId,
    required this.initiatorId,
    this.initiatorName,
    required this.receiverId,
    this.receiverName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      tradeId: json['trade_id'],
      initiatorId: json['initiator_id'],
      initiatorName: json['initiator_name'],
      receiverId: json['receiver_id'],
      receiverName: json['receiver_name'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trade_id': tradeId,
      'initiator_id': initiatorId,
      'initiator_name': initiatorName,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class TradeResponse {
  final List<TradeModel> trades;

  TradeResponse({required this.trades});

  factory TradeResponse.fromJson(Map<String, dynamic> json) {
    var list = json['trades'] as List;
    List<TradeModel> tradesList =
        list.map((i) => TradeModel.fromJson(i)).toList();
    return TradeResponse(trades: tradesList);
  }

  Map<String, dynamic> toJson() {
    return {
      'trades': trades.map((trade) => trade.toJson()).toList(),
    };
  }
}
