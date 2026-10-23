import 'package:flutter_bloc/flutter_bloc.dart';

import 'imt_state.dart';

class ImtCubit extends Cubit<ImtState> {
  ImtCubit() : super(const ImtState());

  double? _parseNumber(String value) {
    final text = value.trim().replaceAll(',', '.');

    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(text)) {
      return null;
    }

    return double.tryParse(text);
  }

  void changeWeight(String value) {
    emit(
      ImtState(
        weightText: value,
        heightText: state.heightText,
        agreement: state.agreement,
      ),
    );
  }

  void changeHeight(String value) {
    emit(
      ImtState(
        weightText: state.weightText,
        heightText: value,
        agreement: state.agreement,
      ),
    );
  }

  void changeAgreement(bool value) {
    emit(
      ImtState(
        weightText: state.weightText,
        heightText: state.heightText,
        agreement: value,
      ),
    );
  }

  void calculate() {
    final weight = _parseNumber(state.weightText);
    final height = _parseNumber(state.heightText);

    String? weightError;
    String? heightError;
    String? agreementError;

    if (state.weightText.trim().isEmpty) {
      weightError = 'Пожалуйста, введите вес';
    } else if (weight == null) {
      weightError = 'Введите корректное число';
    } else if (weight < 5) {
      weightError = 'Вес не может быть меньше 5 кг';
    } else if (weight > 645) {
      weightError = 'Вес не может быть больше 645 кг';
    }

    if (state.heightText.trim().isEmpty) {
      heightError = 'Пожалуйста, введите рост';
    } else if (height == null) {
      heightError = 'Введите корректное число';
    } else if (height < 54.6) {
      heightError = 'Рост не может быть меньше 54,6 см';
    } else if (height > 272) {
      heightError = 'Рост не может быть больше 272 см';
    }

    if (!state.agreement) {
      agreementError = 'Необходимо согласие на обработку данных';
    }

    if (weightError != null || heightError != null || agreementError != null) {
      emit(
        ImtState(
          weightText: state.weightText,
          heightText: state.heightText,
          agreement: state.agreement,
          weightError: weightError,
          heightError: heightError,
          agreementError: agreementError,
        ),
      );
      return;
    }

    final heightM = height! / 100;
    final bmi = weight! / (heightM * heightM);

    String category;

    if (bmi <= 16) {
      category = 'Выраженный дефицит массы тела';
    } else if (bmi < 18.5) {
      category = 'Недостаточная масса тела';
    } else if (bmi < 25) {
      category = 'Норма';
    } else if (bmi < 30) {
      category = 'Избыточная масса тела (предожирение)';
    } else if (bmi < 35) {
      category = 'Ожирение первой степени';
    } else if (bmi < 40) {
      category = 'Ожирение второй степени';
    } else {
      category = 'Ожирение третьей степени (морбидное)';
    }

    emit(
      ImtState(
        weightText: state.weightText,
        heightText: state.heightText,
        agreement: state.agreement,
        bmi: bmi,
        category: category,
      ),
    );
  }

  void reset() {
    emit(const ImtState());
  }
}
