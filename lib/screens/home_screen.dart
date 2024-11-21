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

  final TextEditingController _nameController = TextEditingController();
  final Map<String, TextEditingController> _criteriaControllers = {
    'ram': TextEditingController(),
    'processor': TextEditingController(),
    'screenSize': TextEditingController(),
    'price': TextEditingController(),
    'weight': TextEditingController(),
    'storage': TextEditingController(),
    'battery': TextEditingController(),
    'videoMemory': TextEditingController(),
  };

  String? _bestOption;

  void _addOption() {
    if (_nameController.text.isNotEmpty) {
      Map<String, dynamic> newOption = {'name': _nameController.text};
      _criteriaControllers.forEach((key, controller) {
        newOption[key] = double.tryParse(controller.text) ?? 0.0;
      });
      setState(() {
        _options.add(newOption);
      });
      _nameController.clear();
      _criteriaControllers.forEach((key, controller) => controller.clear());
    }
  }

  void _calculateBestOption() {
    final ahpGaussian = AhpGaussian(_options, _criteriaWeights);
    final result = ahpGaussian.calculateBestOption();
    setState(() {
      _bestOption = result['name'];
    });
  }

  Widget _buildCriteriaInputs() {
    return Column(
      children: _criteriaControllers.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: entry.value,
            decoration: InputDecoration(
              labelText: entry.key,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AHP Gaussian Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cellphone Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter Criteria Values:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildCriteriaInputs(),
              ElevatedButton(
                onPressed: _addOption,
                child: const Text('Add Option'),
              ),
              const Divider(),
              const Text(
                'Options Added:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ..._options.map((option) => ListTile(
                    title: Text(option['name']),
                    subtitle: Text(option.entries
                        .where((e) => e.key != 'name')
                        .map((e) => '${e.key}: ${e.value}')
                        .join(', ')),
                  )),
              const Divider(),
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
      ),
    );
  }
}
