import 'package:flutter/material.dart';
import '../models/ahp_gaussian.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _options = [];
  final Map<String, double> _criteriaWeights = {
    'ram': 0.2,
    'processor': 0.2,
    'screenSize': 0.1,
    'price': 0.2,
    'weight': 0.1,
    'storage': 0.1,
    'battery': 0.05,
    'videoMemory': 0.05,
  };

  final TextEditingController _optionController = TextEditingController();
  String? _bestOption;

  void _calculateBestOption() {
    final ahpGaussian = AhpGaussian(_options, _criteriaWeights);
    final result = ahpGaussian.calculateBestOption();
    setState(() {
      _bestOption = result['name'];
    });
  }

  void _addOption() {
    if (_optionController.text.isNotEmpty) {
      setState(() {
        _options.add({
          "name": _optionController.text,
          "ram": 8, // exemplo
          "processor": 2.8,
          "screenSize": 6.1,
          "price": 1200,
          "weight": 200,
          "storage": 128,
          "battery": 4500,
          "videoMemory": 6,
        });
      });
      _optionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AHP Gaussian Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _optionController,
              decoration: const InputDecoration(
                labelText: 'Cellphone Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addOption,
              child: const Text('Add Option'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_options[index]['name']),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _calculateBestOption,
              child: const Text('Calculate Best Option'),
            ),
            if (_bestOption != null) ...[
              const SizedBox(height: 16),
              Text(
                'Best Option: $_bestOption',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
