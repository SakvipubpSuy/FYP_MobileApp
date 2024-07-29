import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:fyp_mobileapp/models/user.dart';
import 'package:fyp_mobileapp/models/trade.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_url.dart';

class TradeService {
  String baseUrl = ApiURL.baseUrl;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> sendTradeRequest(
      BuildContext context, int initiatorId, int receiverId) async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authorization token not found')),
      );
      return;
    }

    var url = Uri.parse('$baseUrl/trade/send-trade-request');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'initiator_id': initiatorId,
          'receiver_id': receiverId,
        }),
      );

      // Decode the response
      final responseData = jsonDecode(response.body);

      // print('Response Status: ${response.statusCode}');
      // print('Response Body: $responseData');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  responseData['message'] ?? 'Trade created successfully')),
        );
      } else {
        String errorMessage =
            responseData['message'] ?? 'Failed to create trade';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Handle exceptions such as network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<int> countIncomingTrades() async {
    final url = Uri.parse('$baseUrl/trade/count-trade-request');

    String? token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['total_trade_request'];
    } else {
      throw Exception('Failed to fetch incoming trades');
    }
  }

  Future<Map<String, List<TradeModel>>> fetchTradeRequest(int userId) async {
    final url = Uri.parse('$baseUrl/trade/trade-request');
    String? token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      List<TradeModel> incomingTrades =
          (responseData['incoming_trades'] as List)
              .map((data) => TradeModel.fromJson(data))
              .toList();
      List<TradeModel> outgoingTrades =
          (responseData['outgoing_trades'] as List)
              .map((data) => TradeModel.fromJson(data))
              .toList();
      return {
        'incoming_trades': incomingTrades,
        'outgoing_trades': outgoingTrades,
      };
    } else {
      throw Exception('Failed to fetch trades');
    }
  }

  Future<void> acceptTradeRequest(int tradeId) async {
    final url = Uri.parse('$baseUrl/trade/accept-trade/$tradeId');
    String? token = await _storage.read(key: 'auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Failed to accept trade';
      if (response.statusCode == 404) {
        errorMessage = 'Trade not found';
      } else if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        }
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> denyTradeRequest(int tradeId) async {
    final url = Uri.parse('$baseUrl/trade/deny-trade/$tradeId');
    String? token = await _storage.read(key: 'auth_token');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Failed to deny trade';
      if (response.statusCode == 404) {
        errorMessage = 'Trade not found';
      } else if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        }
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> cancelTradeRequest(int tradeId) async {
    final url = Uri.parse('$baseUrl/trade/cancel-trade/$tradeId');
    String? token = await _storage.read(key: 'auth_token');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Failed to cancel trade';
      if (response.statusCode == 404) {
        errorMessage = 'Trade not found';
      } else if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        }
      }
      throw Exception(errorMessage);
    }
  }
}
