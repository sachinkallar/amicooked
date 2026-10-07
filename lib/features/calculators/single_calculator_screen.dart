import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shiny_button.dart';
import 'data/mini_calculators_data.dart';
import 'models/mini_calculator_model.dart';

class SingleCalculatorScreen extends StatefulWidget {
  final String typeSlug;

  const SingleCalculatorScreen({super.key, required this.typeSlug});

  @override
  State<SingleCalculatorScreen> createState() => _SingleCalculatorScreenState();
}

class _SingleCalculatorScreenState extends State<SingleCalculatorScreen> {
  MiniCalculatorDef? _calculator;
  final Map<String, dynamic> _formValues = {};
  final Map<String, TextEditingController> _controllers = {};
  MiniCalculatorResult? _result;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _loadCalculator();
  }

  @override
  void didUpdateWidget(covariant SingleCalculatorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.typeSlug != widget.typeSlug) {
      _loadCalculator();
    }
  }

  void _loadCalculator() {
    _calculator = MiniCalculatorsData.getBySlug(widget.typeSlug);
    _formValues.clear();
    _controllers.forEach((_, c) => c.dispose());
    _controllers.clear();
    _result = null;

    if (_calculator != null) {
      for (final field in _calculator!.fields) {
        if (field.type == CalculatorFieldType.dropdown) {
          _formValues[field.key] = field.defaultString ?? field.dropdownOptions?.first.value;
        } else if (field.type == CalculatorFieldType.slider) {
          _formValues[field.key] = field.defaultValue ?? field.min ?? 0;
        } else {
          final val = field.defaultValue ?? 0;
          _formValues[field.key] = val;
          _controllers[field.key] = TextEditingController(
            text: val % 1 == 0 ? val.toInt().toString() : val.toString(),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  void _calculate() async {
    if (_calculator == null) return;
    setState(() => _isCalculating = true);

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final res = _calculator!.compute(_formValues);
    setState(() {
      _result = res;
      _isCalculating = false;
    });
  }

  void _reset() {
    setState(() {
      _loadCalculator();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_calculator == null) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💀', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text('THE ALGORITHM HAS GIVEN UP 💀', style: AppTypography.headingSmall()),
                const SizedBox(height: 8),
                Text(
                  'Even our questionable mathematics couldn’t find that calculator.',
                  style: AppTypography.bodySmall(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ShinyButton(
                  text: 'Back to Calculators Hub',
                  onPressed: () => context.go('/calculators'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final calc = _calculator!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb / Back
          TextButton.icon(
            onPressed: () => context.go('/calculators'),
            icon: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textSecondary),
            label: Text('All Calculators', style: AppTypography.label(color: AppColors.textSecondary)),
          ),

          const SizedBox(height: 12),

          // Header
          Row(
            children: [
              Text(calc.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(calc.title, style: AppTypography.headingLarge(fontSize: isDesktop ? 30 : 22)),
                    Text(calc.subtitle, style: AppTypography.bodySmall()),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Calculator Input Form
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...calc.fields.map((field) => _buildFieldWidget(field)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ShinyButton(
                        text: '🔥 CALCULATE DAMAGE',
                        height: 52,
                        isLoading: _isCalculating,
                        onPressed: _calculate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ShinyButton(
                      text: 'Reset',
                      height: 52,
                      variant: ShinyButtonVariant.outline,
                      onPressed: _reset,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Result Section
          if (_result != null) ...[
            const SizedBox(height: 36),
            _buildResultCard(_result!),
          ],

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildFieldWidget(MiniCalculatorField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(field.label, style: AppTypography.label(fontSize: 14)),
              if (field.type == CalculatorFieldType.slider)
                Text(
                  '${_formValues[field.key] ?? field.min ?? 0}',
                  style: AppTypography.mono(fontSize: 14, color: AppColors.fireOrange),
                ),
            ],
          ),
          if (field.helperText != null) ...[
            const SizedBox(height: 4),
            Text(field.helperText!, style: AppTypography.bodySmall(fontSize: 12)),
          ],
          const SizedBox(height: 10),

          // Slider
          if (field.type == CalculatorFieldType.slider) ...[
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.fireOrange,
                inactiveTrackColor: AppColors.surfaceHighlight,
                thumbColor: Colors.white,
                overlayColor: AppColors.fireOrange.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: ((_formValues[field.key] as num?)?.toDouble() ?? (field.min ?? 0)).clamp(
                  field.min ?? 0,
                  field.max ?? 100,
                ),
                min: field.min ?? 0,
                max: field.max ?? 100,
                divisions: ((field.max ?? 100) - (field.min ?? 0)).round(),
                onChanged: (val) {
                  setState(() {
                    _formValues[field.key] = (val % 1 == 0) ? val.toInt() : double.parse(val.toStringAsFixed(1));
                  });
                },
              ),
            ),
          ]

          // Dropdown
          else if (field.type == CalculatorFieldType.dropdown) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  value: _formValues[field.key],
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceElevated,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                  items: field.dropdownOptions?.map((opt) {
                    return DropdownMenuItem<dynamic>(
                      value: opt.value,
                      child: Text(
                        opt.label,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _formValues[field.key] = val);
                  },
                ),
              ),
            ),
          ]

          // Currency or Number Input
          else ...[
            TextField(
              controller: _controllers[field.key],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                prefixText: field.type == CalculatorFieldType.currency ? '₹ ' : null,
                prefixStyle: const TextStyle(color: AppColors.fireAmber, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.fireOrange),
                ),
              ),
              onChanged: (text) {
                final numVal = double.tryParse(text) ?? 0;
                _formValues[field.key] = numVal;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard(MiniCalculatorResult result) {
    final color = AppColors.getTierColor(result.cookedScore);

    return GlassCard(
      padding: const EdgeInsets.all(28),
      borderColor: color.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(result.verdictEmoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Text(result.verdictTitle, style: AppTypography.headingSmall(color: color, fontSize: 19)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${result.cookedScore}% COOKED',
                  style: AppTypography.mono(
                    fontSize: 13,
                    color: color,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              result.verdictDescription,
              style: AppTypography.bodyMedium(color: Colors.white),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            result.detailedBreakdown,
            style: AppTypography.mono(fontSize: 12, color: AppColors.fireAmber),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          Text('💡 ALGORITHMIC SURVIVAL TIPS:', style: AppTypography.label(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          ...result.tips.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.fireOrange)),
                    Expanded(child: Text(t, style: AppTypography.bodySmall(color: AppColors.textSecondary))),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ShinyButton(
                  text: '📤 Share Result',
                  height: 46,
                  fontSize: 14,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: '🔥 In ${_calculator?.title}, I scored ${result.cookedScore}% Cooked (${result.verdictTitle})!\nTest yourself at amicooked.lol/calculators/${widget.typeSlug}',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.surfaceElevated,
                        content: Text('Result copied to clipboard!'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShinyButton(
                  text: 'Try Another Calculator',
                  height: 46,
                  fontSize: 14,
                  variant: ShinyButtonVariant.outline,
                  onPressed: () => context.go('/calculators'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
