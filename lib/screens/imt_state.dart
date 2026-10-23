class ImtState {
  final String weightText;
  final String heightText;
  final bool agreement;

  final String? weightError;
  final String? heightError;
  final String? agreementError;

  final double? bmi;
  final String? category;

  const ImtState({
    this.weightText = '',
    this.heightText = '',
    this.agreement = false,
    this.weightError,
    this.heightError,
    this.agreementError,
    this.bmi,
    this.category,
  });

  bool get hasResult => bmi != null;
}
