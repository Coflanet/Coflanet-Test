import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';
import 'package:coflanet/widgets/modals/time_picker_modal.dart';

/// Detail screen for adjusting a single recipe parameter (RS-03 ~ RS-05).
///
/// Receives the parameter key via `Get.arguments['param']`:
///   - `'beanAmount'`       → 원두량 (10-30g)
///   - `'waterTemperature'` → 물 온도 (80-100°C)
///   - `'extractionTime'`   → 추출 시간 (time picker)
///   - `'waterAmount'`      → 물 양 (100-400ml)
class CoffeeSettingDetailView extends GetView<CoffeeController> {
  const CoffeeSettingDetailView({super.key});

  // ── helpers to derive config from param key ──────────────────────────

  String get _paramKey =>
      (Get.arguments as Map<String, dynamic>?)?['param'] as String? ??
      'beanAmount';

  _ParamConfig get _config {
    switch (_paramKey) {
      case 'beanAmount':
        return _ParamConfig(
          title: '원두량',
          unit: 'g',
          icon: Icons.coffee_outlined,
          min: 10,
          max: 30,
          getValue: () => controller.coffeeAmount,
          onSliderChanged: (v) => controller.updateBeanAmount(v),
          modalTitle: '원두량 설정',
          modalMessage: '원두량을 그램 단위로 입력하세요',
          modalHint: '예: 18',
          modalValidator: _rangeValidator(10, 30, 'g'),
          onModalResult: (v) => controller.updateBeanAmount(v),
        );
      case 'waterTemperature':
        return _ParamConfig(
          title: '물 온도',
          unit: '°C',
          icon: Icons.thermostat_outlined,
          min: 80,
          max: 100,
          getValue: () => controller.waterTemperature,
          onSliderChanged: (v) => controller.updateWaterTemperature(v),
          modalTitle: '물 온도 설정',
          modalMessage: '물 온도를 섭씨 단위로 입력하세요',
          modalHint: '예: 93',
          modalValidator: _rangeValidator(80, 100, '°C'),
          onModalResult: (v) => controller.updateWaterTemperature(v),
        );
      case 'extractionTime':
        return _ParamConfig(
          title: '추출 시간',
          unit: '',
          icon: Icons.timer_outlined,
          min: 15,
          max: 600,
          getValue: () => controller.extractionTime,
          onSliderChanged: (v) => controller.updateExtractionTime(v),
          isTimePicker: true,
          modalTitle: '추출 시간 설정',
          onModalResult: (v) => controller.updateExtractionTime(v),
        );
      case 'waterAmount':
        return _ParamConfig(
          title: '물 양',
          unit: 'ml',
          icon: Icons.water_drop_outlined,
          min: 100,
          max: 400,
          getValue: () => controller.waterAmount,
          onSliderChanged: (v) => controller.updateWaterAmount(v),
          modalTitle: '물 양 설정',
          modalMessage: '물 양을 ml 단위로 입력하세요',
          modalHint: '예: 250',
          modalValidator: _rangeValidator(100, 400, 'ml'),
          onModalResult: (v) => controller.updateWaterAmount(v),
        );
      default:
        return _ParamConfig(
          title: '원두량',
          unit: 'g',
          icon: Icons.coffee_outlined,
          min: 10,
          max: 30,
          getValue: () => controller.coffeeAmount,
          onSliderChanged: (v) => controller.updateBeanAmount(v),
          modalTitle: '원두량 설정',
          modalMessage: '원두량을 그램 단위로 입력하세요',
          modalHint: '예: 18',
          modalValidator: _rangeValidator(10, 30, 'g'),
          onModalResult: (v) => controller.updateBeanAmount(v),
        );
    }
  }

  static String? Function(String?) _rangeValidator(
    int min,
    int max,
    String unit,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return '값을 입력하세요';
      final parsed = int.tryParse(value);
      if (parsed == null || parsed < min || parsed > max) {
        return '$min~$max$unit 사이의 값을 입력하세요';
      }
      return null;
    };
  }

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cfg = _config;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.labelNormal),
          onPressed: () => Get.back(),
        ),
        title: Text(
          cfg.title,
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // ── icon badge ──
                    _buildIconBadge(cfg),

                    const SizedBox(height: 32),

                    // ── large value display ──
                    _buildValueDisplay(cfg),

                    const SizedBox(height: 48),

                    // ── slider ──
                    _buildSlider(cfg),

                    const SizedBox(height: 32),

                    // ── "직접 입력" button ──
                    _buildDirectInputButton(cfg),

                    const SizedBox(height: 24),

                    // ── range hint ──
                    _buildRangeHint(cfg),
                  ],
                ),
              ),
            ),

            // ── bottom save bar ──
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── UI pieces ────────────────────────────────────────────────────────

  Widget _buildIconBadge(_ParamConfig cfg) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primaryLight,
            AppColor.primaryLight.withOpacity(0.5),
          ],
        ),
        borderRadius: AppRadius.xxxlBorder,
        boxShadow: AppShadows.shadowPrimaryEmphasize,
      ),
      child: Icon(cfg.icon, color: AppColor.primaryNormal, size: 32),
    );
  }

  Widget _buildValueDisplay(_ParamConfig cfg) {
    return Obx(() {
      final value = cfg.getValue();
      final displayText = cfg.isTimePicker
          ? controller.extractionTimeFormatted
          : '$value${cfg.unit}';

      return Column(
        children: [
          Text(
            displayText,
            style: AppTextStyles.display2Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cfg.title,
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSlider(_ParamConfig cfg) {
    return Obx(() {
      final current = cfg.getValue().toDouble();

      return Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: AppColor.primaryNormal,
              inactiveTrackColor: AppColor.lineNormalAlternative,
              thumbColor: AppColor.primaryNormal,
              overlayColor: AppColor.primaryNormal.withOpacity(0.15),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: current.clamp(cfg.min.toDouble(), cfg.max.toDouble()),
              min: cfg.min.toDouble(),
              max: cfg.max.toDouble(),
              divisions: cfg.max - cfg.min,
              onChanged: (v) => cfg.onSliderChanged(v.round()),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cfg.isTimePicker
                    ? _formatSeconds(cfg.min)
                    : '${cfg.min}${cfg.unit}',
                style: AppTextStyles.caption1Regular.copyWith(
                  color: AppColor.labelAssistive,
                ),
              ),
              Text(
                cfg.isTimePicker
                    ? _formatSeconds(cfg.max)
                    : '${cfg.max}${cfg.unit}',
                style: AppTextStyles.caption1Regular.copyWith(
                  color: AppColor.labelAssistive,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDirectInputButton(_ParamConfig cfg) {
    return GestureDetector(
      onTap: () => _openDirectInput(cfg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(color: AppColor.lineNormalAlternative, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              cfg.isTimePicker ? Icons.access_time : Icons.edit_outlined,
              color: AppColor.primaryNormal,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '직접 입력',
              style: AppTextStyles.headline2Medium.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeHint(_ParamConfig cfg) {
    final range = cfg.isTimePicker
        ? '${_formatSeconds(cfg.min)} ~ ${_formatSeconds(cfg.max)}'
        : '${cfg.min}${cfg.unit} ~ ${cfg.max}${cfg.unit}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalAlternative,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColor.labelAssistive, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '설정 가능 범위: $range',
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: SafeArea(
        child: PrimaryButton(text: '저장', onPressed: () => Get.back()),
      ),
    );
  }

  // ── input modals ─────────────────────────────────────────────────────

  Future<void> _openDirectInput(_ParamConfig cfg) async {
    if (cfg.isTimePicker) {
      final initial = Duration(seconds: cfg.getValue());
      final result = await TimePickerModal.show(
        title: cfg.modalTitle,
        initialDuration: initial,
        maxMinutes: 10,
        maxSeconds: 59,
      );
      if (result != null) {
        cfg.onModalResult(result.inSeconds);
      }
    } else {
      final result = await InputModal.show(
        title: cfg.modalTitle,
        message: cfg.modalMessage,
        hint: cfg.modalHint,
        initialValue: cfg.getValue().toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: cfg.modalValidator,
      );
      if (result != null) {
        cfg.onModalResult(int.parse(result));
      }
    }
  }

  // ── formatting ───────────────────────────────────────────────────────

  static String _formatSeconds(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

// ── param config VO ──────────────────────────────────────────────────────

class _ParamConfig {
  final String title;
  final String unit;
  final IconData icon;
  final int min;
  final int max;
  final int Function() getValue;
  final void Function(int) onSliderChanged;
  final bool isTimePicker;
  final String modalTitle;
  final String? modalMessage;
  final String? modalHint;
  final String? Function(String?)? modalValidator;
  final void Function(int) onModalResult;

  const _ParamConfig({
    required this.title,
    required this.unit,
    required this.icon,
    required this.min,
    required this.max,
    required this.getValue,
    required this.onSliderChanged,
    this.isTimePicker = false,
    required this.modalTitle,
    this.modalMessage,
    this.modalHint,
    this.modalValidator,
    required this.onModalResult,
  });
}
