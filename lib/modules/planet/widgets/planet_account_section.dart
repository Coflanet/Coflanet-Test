import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/modules/planet/widgets/planet_text_cell.dart';
import 'package:coflanet/widgets/modals/selection_modal.dart';

/// 마이플래닛 계정 액션 컨테이너 — 테마 설정 / (게스트) 계정 연결 / 로그아웃 / 회원탈퇴.
///
/// Figma: border-radius 40px, padding 12px 24px 독립 컨테이너.
/// 구분선은 각 셀 뒤 1px (마지막 회원탈퇴 뒤에는 없음).
///
/// [themeController] 는 호출부에서 Get.find 해 주입한다 (위젯 내부 Get.find 금지
/// — HomeCarousel 의 Rx 주입 선례). mode 는 테마 셀 내부의 좁은 Obx 에서만 읽는다
/// (build 본문에서 읽으면 호출부의 외부 Obx 가 mode 변경까지 추적하므로 금지).
/// [isAnonymous] 는 비반응 SDK 읽기(plain bool) — 원본도 비반응이라 값 주입으로
/// 동작 동일. 위젯 내부에서 재조회하지 말 것.
class PlanetAccountSection extends StatelessWidget {
  const PlanetAccountSection({
    super.key,
    required this.themeController,
    required this.isAnonymous,
    required this.onAccountLink,
    required this.onLogout,
    required this.onWithdraw,
  });

  /// 전역 테마 컨트롤러 (호출부 Get.find 주입)
  final ThemeController themeController;

  /// 게스트 여부 — true 면 계정 연결 셀 노출
  final bool isAnonymous;

  /// 계정 연결 탭 콜백
  final VoidCallback onAccountLink;

  /// 로그아웃 탭 콜백
  final VoidCallback onLogout;

  /// 회원탈퇴 탭 콜백
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ), // Figma: 12px 24px
      decoration: BoxDecoration(
        color: colors.surfaceCardStrong,
        borderRadius: BorderRadius.circular(40), // Figma: 40px
      ),
      child: Column(
        children: [
          // 테마 설정 cell — 현재 모드 라벨 표시 + 선택 모달
          _buildThemeModeCell(colors),
          Container(height: 1, color: colors.lineNormalNeutral),
          // 게스트일 때만 계정 연결 표시
          if (isAnonymous) ...[
            PlanetTextCell(
              text: '계정 연결',
              color: colors.primaryNormal,
              onTap: onAccountLink,
            ),
            Container(height: 1, color: colors.lineNormalNeutral),
          ],
          // 로그아웃 cell - Figma: height 48px, padding 12px 0
          PlanetTextCell(
            text: '로그아웃',
            color: colors.labelNormal,
            onTap: onLogout,
          ),
          Container(height: 1, color: colors.lineNormalNeutral),
          // 회원탈퇴 cell - Figma: color #FF4242
          PlanetTextCell(
            text: '회원탈퇴',
            color: colors.statusNegative,
            onTap: onWithdraw,
          ),
        ],
      ),
    );
  }

  /// 테마 설정 cell — '테마' + 현재 모드 라벨(내부 Obx), 탭 시 3상태 선택 모달
  Widget _buildThemeModeCell(AppColorScheme colors) {
    return GestureDetector(
      onTap: _showThemeModeModal,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '테마',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ),
            Obx(
              () => Text(
                themeController.mode.label,
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: colors.labelAlternative),
          ],
        ),
      ),
    );
  }

  /// 테마 모드 선택 모달 (시스템 설정 / 라이트 / 다크)
  /// selectedIndex 의 mode 읽기는 onTap 시점 평가 — 빌드 구독이 아니라 안전
  Future<void> _showThemeModeModal() async {
    const modes = AppThemeMode.values;
    final result = await SelectionModal.show(
      title: '테마 설정',
      options: [for (final mode in modes) mode.label],
      selectedIndex: modes.indexOf(themeController.mode),
    );
    if (result != null && result is int) {
      themeController.setMode(modes[result]);
    }
  }
}
