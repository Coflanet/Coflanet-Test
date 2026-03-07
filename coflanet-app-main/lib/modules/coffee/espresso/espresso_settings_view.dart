import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/data/models/extraction_step_model.dart';
import 'package:coflanet/modules/coffee/espresso/espresso_settings_controller.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';

/// 에스프레소 머신 추출 설정 카드 화면 (Figma: 에스프레소 머신 추출 설정 카드 추가 삭제 순서)
class EspressoSettingsView extends GetView<EspressoSettingsController> {
  const EspressoSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ReorderableListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.steps.length + 1, // +1 for add button
                  buildDefaultDragHandles: false,
                  onReorder: controller.onReorder,
                  itemBuilder: (context, index) {
                    if (index == controller.steps.length) {
                      return _buildAddStepButton(
                        key: const ValueKey('add_button'),
                      );
                    }
                    final step = controller.steps[index];
                    return _StepCard(
                      key: ValueKey(step.id),
                      step: step,
                      index: index,
                      isEditing: controller.isEditing,
                      onEdit: () => controller.editStep(step),
                      onDelete: () => controller.deleteStep(step),
                      canDelete: !step.isRequired,
                    );
                  },
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.backgroundNormalNormal,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        '추출 설정',
        style: AppTextStyles.headline1Bold.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.toggleEditing,
            child: Text(
              controller.isEditing ? '완료' : '편집',
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddStepButton({required Key key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: controller.showAddStepOptions,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.componentFillNormal,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(
              color: AppColor.lineNormalNeutral,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColor.primaryNormal,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '단계 추가',
                style: AppTextStyles.body1NormalMedium.copyWith(
                  color: AppColor.primaryNormal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar(
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryNormal,
            foregroundColor: AppColor.staticLabelWhiteStrong,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
          ),
          child: Text('저장', style: AppTextStyles.headline2Bold),
        ),
      ),
    );
  }
}

/// Step Card Widget
class _StepCard extends StatelessWidget {
  final ExtractionStep step;
  final int index;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool canDelete;

  const _StepCard({
    super.key,
    required this.step,
    required this.index,
    required this.isEditing,
    required this.onEdit,
    required this.onDelete,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.xlBorder,
        border: Border.all(color: AppColor.lineNormalNeutral),
        boxShadow: AppShadows.shadowBlackNormal,
      ),
      child: Column(
        children: [
          // Header with step name and drag handle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getStepColor().withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _getStepColor(),
                    borderRadius: AppRadius.smBorder,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.label1NormalBold.copyWith(
                        color: AppColor.staticLabelWhiteStrong,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.name,
                        style: AppTextStyles.headline2Bold.copyWith(
                          color: AppColor.labelNormal,
                        ),
                      ),
                      Text(
                        _getStepTypeLabel(),
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAssistive,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isEditing) ...[
                  if (canDelete)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppColor.statusNegative,
                      ),
                      onPressed: onDelete,
                    ),
                  ReorderableDragStartListener(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.drag_handle,
                        color: AppColor.labelAssistive,
                      ),
                    ),
                  ),
                ] else
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: AppColor.labelAlternative,
                    ),
                    onPressed: onEdit,
                  ),
              ],
            ),
          ),
          // Settings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSettingRow('시간', _formatDuration(step.duration)),
                const SizedBox(height: 8),
                _buildSettingRow(
                  '압력',
                  '${step.pressure.toStringAsFixed(1)} bar',
                ),
                const SizedBox(height: 8),
                _buildSettingRow('온도', '${step.temperature}°C'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ],
    );
  }

  Color _getStepColor() {
    switch (step.type) {
      case ExtractionStepType.preInfusion:
        return AppColor.colorGlobalBlue50;
      case ExtractionStepType.blooming:
        return AppColor.colorGlobalGreen50;
      case ExtractionStepType.mainExtraction:
        return AppColor.primaryNormal;
      case ExtractionStepType.additionalExtraction:
        return AppColor.colorGlobalOrange50;
    }
  }

  String _getStepTypeLabel() {
    switch (step.type) {
      case ExtractionStepType.preInfusion:
        return '사전 추출';
      case ExtractionStepType.blooming:
        return '뜸 들이기';
      case ExtractionStepType.mainExtraction:
        return '메인 추출';
      case ExtractionStepType.additionalExtraction:
        return '추가 추출';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes분 ${seconds}초';
    }
    return '${seconds}초';
  }
}
