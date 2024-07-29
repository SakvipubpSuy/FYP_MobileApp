import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api/trade_service.dart';
import '../../api/user_service.dart';
import 'tradedetailspage.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final TextEditingController _searchController = TextEditingController();
  final TradeService _tradeService = TradeService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? userID;
  int _incomingTradeCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _getUserID();
    _countIncomingTrades();
  }

  Future<void> _getUserID() async {
    userID = await _storage.read(key: 'userID');
    setState(() {});
  }

  Future<void> _countIncomingTrades() async {
    try {
      int count = await _tradeService.countIncomingTrades();
      setState(() {
        _incomingTradeCount = count;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error appropriately, maybe show a SnackBar
    }
  }

  void _navigateToTradeDetailsPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TradeDetailsPage(
                  userId: int.parse(userID!),
                  onTradeActionCompleted: () => _countIncomingTrades(),
                )))
        .then((_) =>
            _countIncomingTrades()); // Refresh incoming trade count after returning
  }

  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  void _onSearchChanged() {
    setState(() {
      _isSearching = true;
    });

    UserService().getAllUsers().then((users) {
      final currentUserID = userID;
      setState(() {
        _isSearching = false;
        _searchResults = _searchController.text.isEmpty
            ? []
            : users.where((user) {
                final username = user['name'].toLowerCase();
                final searchQuery = _searchController.text.toLowerCase();
                final userID = user['id'].toString();
                return username.contains(searchQuery) &&
                    userID != currentUserID;
              }).toList();
      });
    }).catchError((error) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch users: $error')),
      );
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _sendTradeRequest(int initiatorId, int receiverId) async {
    await _tradeService.sendTradeRequest(context, initiatorId, receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trade Page'),
        actions: [
          Stack(
            children: [
              Transform.scale(
                scale: 1.5, // Adjust this value to make the button bigger
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, size: 30),
                  onPressed: _navigateToTradeDetailsPage,
                ),
              ),
              if (_incomingTradeCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '$_incomingTradeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Players',
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Players',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isSearching)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_searchResults.isEmpty)
              Center(
                child: _searchController.text.isEmpty
                    ? const Text('Enter player name to start searching')
                    : const Text('No players found'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          '${user['name'][0]}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(user['name']),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Trade Request'),
                            content:
                                Text('Initiate trade with ${user['name']}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _sendTradeRequest(
                                    int.parse(userID!),
                                    user['id'],
                                  );
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                      },
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
