import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор индекса массы тела',
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  bool _agreement = false;

  final List<TextInputFormatter> _numberFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ];

  double? _parseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final text = value.trim().replaceAll(',', '.');

    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(text)) {
      return null;
    }

    return double.tryParse(text);
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите вес';
    }

    final weight = _parseNumber(value);

    if (weight == null) {
      return 'Введите корректное число';
    }

    if (weight < 5) {
      return 'Вес не может быть меньше 5 кг';
    }

    if (weight > 645) {
      return 'Вес не может быть больше 645 кг';
    }

    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите рост';
    }

    final height = _parseNumber(value);

    if (height == null) {
      return 'Введите корректное число';
    }

    if (height < 54.6) {
      return 'Рост не может быть меньше 54,6 см';
    }

    if (height > 272) {
      return 'Рост не может быть больше 272 см';
    }

    return null;
  }

  void _onCalculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreement) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Необходимо согласие на обработку данных'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final weight = _parseNumber(_weightController.text)!;
    final heightCm = _parseNumber(_heightController.text)!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(weight: weight, heightCm: heightCm),
      ),
    );
  }
  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Анашкин Дмитрий Владимирович')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Калькулятор ИМТ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: _numberFormatters,
                decoration: const InputDecoration(
                  labelText: 'Вес (кг)',
                  helperText: 'Допустимо от 5 до 645 кг',
                  border: OutlineInputBorder(),
                ),
                validator: _validateWeight,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: _numberFormatters,
                decoration: const InputDecoration(
                  labelText: 'Рост (см)',
                  helperText: 'Допустимо от 54,6 до 272 см',
                  border: OutlineInputBorder(),
                ),
                validator: _validateHeight,
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _agreement,
                title: const Text(
                  'Я ознакомлен с документом '
                  '"Согласие на обработку персональных данных"',
                ),
                onChanged: (bool? value) {
                  setState(() {
                    _agreement = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onCalculate,
                  child: const Text('Рассчитать'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final double weight;
  final double heightCm;

  const SecondScreen({super.key, required this.weight, required this.heightCm});

  
  double get _heightM => heightCm / 100;

  double get _index => weight / (_heightM * _heightM);

  String get _category {
    if (_index <= 16) {
      return 'Выраженный дефицит массы тела';
    }
    if (_index < 18.5) {
      return 'Недостаточная масса тела';
    }
    if (_index < 25) {
      return 'Норма';
    }
    if (_index < 30) {
      return 'Избыточная масса тела (предожирение)';
    }
    if (_index < 35) {
      return 'Ожирение первой степени';
    }
    if (_index < 40) {
      return 'Ожирение второй степени';
    }
    return 'Ожирение третьей степени (морбидное)';
  }

  Color get _categoryColor {
    if (_index <= 16) return Colors.red;
    if (_index < 18.5) return Colors.orange;
    if (_index < 25) return Colors.green;
    if (_index < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Ваш ИМТ:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      _index.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _categoryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _category,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: _categoryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Исходные данные:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Вес: ${weight.toStringAsFixed(2)} кг'),
                    Text('Рост: ${heightCm.toStringAsFixed(1)} см'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
