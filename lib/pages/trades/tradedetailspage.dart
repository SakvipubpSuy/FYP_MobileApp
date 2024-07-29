import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/trade.dart';
import '../../api/trade_service.dart';

class TradeDetailsPage extends StatefulWidget {
  final int userId;
  final VoidCallback onTradeActionCompleted;

  const TradeDetailsPage({
    Key? key,
    required this.userId,
    required this.onTradeActionCompleted,
  }) : super(key: key);

  @override
  _TradeDetailsPageState createState() => _TradeDetailsPageState();
}

class _TradeDetailsPageState extends State<TradeDetailsPage> {
  final TradeService _tradeService = TradeService();
  List<TradeModel> incomingTrades = [];
  List<TradeModel> outgoingTrades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTradeRequest();
  }

  Future<void> _fetchTradeRequest() async {
    try {
      final trades = await _tradeService.fetchTradeRequest(widget.userId);
      setState(() {
        incomingTrades = trades['incoming_trades'] ?? [];
        outgoingTrades = trades['outgoing_trades'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch trades: $e')),
      );
    }
  }

  Future<void> _acceptTrade(int tradeId) async {
    try {
      await _tradeService.acceptTradeRequest(tradeId);
      widget.onTradeActionCompleted();
      _fetchTradeRequest();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trade accepted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept trade: $e')),
      );
    }
  }

  Future<void> _denyTrade(int tradeId) async {
    try {
      await _tradeService.denyTradeRequest(tradeId);
      widget.onTradeActionCompleted();
      _fetchTradeRequest();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trade denied')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trade: $e')),
      );
    }
  }

  Future<void> _cancelTrade(int tradeId) async {
    try {
      await _tradeService.cancelTradeRequest(tradeId);
      _fetchTradeRequest();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trade canceled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deny trade: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Incoming Trades',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: incomingTrades.length,
                      itemBuilder: (context, index) {
                        final trade = incomingTrades[index];
                        return ListTile(
                          title:
                              Text('From: ${trade.initiatorName ?? 'Unknown'}'),
                          subtitle: Text('Status: ${trade.status}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => _acceptTrade(trade.tradeId),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () => _denyTrade(trade.tradeId),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Outgoing Trades',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: outgoingTrades.length,
                      itemBuilder: (context, index) {
                        final trade = outgoingTrades[index];
                        return ListTile(
                          title: Text('To: ${trade.receiverName ?? 'Unknown'}'),
                          subtitle: Text('Status: ${trade.status}'),
                          trailing: SizedBox(
                            child: TextButton(
                              child: const Text('Cancel'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red, // Button color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                textStyle: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () => _cancelTrade(trade.tradeId),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
