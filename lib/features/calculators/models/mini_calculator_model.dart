enum CalculatorFieldType {
  number,
  currency, // INR
  slider,
  dropdown,
}

class DropdownOption {
  final String label;
  final dynamic value;

  const DropdownOption({required this.label, required this.value});
}

class MiniCalculatorField {
  final String key;
  final String label;
  final String? placeholder;
  final CalculatorFieldType type;
  final double? min;
  final double? max;
  final double? defaultValue;
  final String? defaultString;
  final List<DropdownOption>? dropdownOptions;
  final String? helperText;

  const MiniCalculatorField({
    required this.key,
    required this.label,
    this.placeholder,
    this.type = CalculatorFieldType.number,
    this.min,
    this.max,
    this.defaultValue,
    this.defaultString,
    this.dropdownOptions,
    this.helperText,
  });
}

class MiniCalculatorResult {
  final int cookedScore; // 0 to 100
  final String verdictTitle;
  final String verdictEmoji;
  final String verdictDescription;
  final String detailedBreakdown;
  final List<String> tips;

  const MiniCalculatorResult({
    required this.cookedScore,
    required this.verdictTitle,
    required this.verdictEmoji,
    required this.verdictDescription,
    required this.detailedBreakdown,
    required this.tips,
  });
}

typedef CalculatorComputeFn = MiniCalculatorResult Function(Map<String, dynamic> inputs);

class MiniCalculatorDef {
  final String slug;
  final String title;
  final String emoji;
  final String subtitle;
  final String category;
  final List<MiniCalculatorField> fields;
  final CalculatorComputeFn compute;

  const MiniCalculatorDef({
    required this.slug,
    required this.title,
    required this.emoji,
    required this.subtitle,
    required this.category,
    required this.fields,
    required this.compute,
  });
}
