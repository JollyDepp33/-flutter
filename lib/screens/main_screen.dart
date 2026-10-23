import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'imt_cubit.dart';
import 'imt_state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => ImtCubit(), child: const ImtView());
  }
}

class ImtView extends StatelessWidget {
  const ImtView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImtCubit, ImtState>(
      builder: (context, state) {
        final cubit = context.read<ImtCubit>();

        Color resultColor = Colors.green;

        if (state.bmi != null) {
          if (state.bmi! <= 16 || state.bmi! >= 30) {
            resultColor = Colors.red;
          } else if (state.bmi! < 18.5 || state.bmi! >= 25) {
            resultColor = Colors.orange;
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Анашкин Дмитрий Владимирович')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Калькулятор ИМТ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    // Ограничиваем ввод цифрами и разделителями.
                    // Текстовые значения дополнительно проверяет Cubit.
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged: cubit.changeWeight,
                  decoration: InputDecoration(
                    labelText: 'Вес (кг)',
                    helperText: 'Допустимо от 5 до 645 кг',
                    border: const OutlineInputBorder(),
                    errorText: state.weightError,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged: cubit.changeHeight,
                  decoration: InputDecoration(
                    labelText: 'Рост (см)',
                    helperText: 'Допустимо от 54,6 до 272 см',
                    border: const OutlineInputBorder(),
                    errorText: state.heightError,
                  ),
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: state.agreement,
                  title: const Text(
                    'Я ознакомлен с документом '
                    '"Согласие на обработку персональных данных"',
                  ),
                  onChanged: (value) {
                    cubit.changeAgreement(value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                if (state.agreementError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      state.agreementError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cubit.calculate,
                    child: const Text('Рассчитать'),
                  ),
                ),

                if (state.hasResult) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Ваш ИМТ:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.bmi!.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: resultColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.category!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: resultColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Исходные данные:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Вес: ${state.weightText} кг'),
                          Text('Рост: ${state.heightText} см'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: cubit.reset,
                    child: const Text('Сбросить'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
