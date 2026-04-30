import 'package:flutter/material.dart';
import 'package:weather/Service/history_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final Function(String city) onCitySelected;
  const HistoryScreen({super.key, required this.onCitySelected});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _historyService = HistoryService();
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _historyService.getHistory();
    setState(() {
      _history = data;
      _isLoading = false;
    });
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    return DateFormat('d MMM, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Search History",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Text(
                    "No search history yet",
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                )
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return ListTile(
                      leading: Icon(Icons.location_city,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text(
                        "${item['city_name']}${item['country'].isNotEmpty ? ', ${item['country']}' : ''}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      subtitle: Text(
                        _formatDate(item['searched_at']),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () async {
                          await _historyService.deleteHistory(item['id']);
                          _loadHistory();
                        },
                      ),
                      onTap: () {
                        widget.onCitySelected(item['city_name']);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
    );
  }
}