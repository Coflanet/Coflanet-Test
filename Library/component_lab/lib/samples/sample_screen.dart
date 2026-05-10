/// 모듈 조립 테스트 — Foundation + Components를 조합한 샘플 로그인 화면.
///
/// 이 파일은 `import 'package:component_lab/component_lab.dart'` 한 줄로
/// 모든 Foundation 토큰과 컴포넌트를 가져와 실제 화면을 구성할 수 있는지 검증합니다.
library;

import 'package:flutter/material.dart';

// ✅ 핵심: barrel file 한 줄로 모든 토큰 + 컴포넌트 import
import 'package:component_lab/component_lab.dart';

/// 샘플 로그인 화면 — Foundation 토큰 + Component 조립 테스트.
class SampleLoginScreen extends StatefulWidget {
  const SampleLoginScreen({super.key});

  @override
  State<SampleLoginScreen> createState() => _SampleLoginScreenState();
}

class _SampleLoginScreenState extends State<SampleLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCommon100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space24,
            vertical: AppSpacing.space40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.space40),

              // ── 타이틀 영역 ──
              Text(
                'Coflanet',
                style: AppTextStyles.title1Bold.copyWith(
                  color: AppColor.colorGlobalCoolNeutral10,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.space8),
              Text(
                '커피 한 잔의 네트워크',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.colorGlobalCoolNeutral50,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.space40),

              // ── 로그인 카드 ──
              AppCard(
                variant: AppCardVariant.outlined,
                padding: EdgeInsets.all(AppSpacing.space24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 이메일 입력
                    AppTextField(
                      controller: _emailController,
                      label: '이메일',
                      hintText: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      size: AppTextFieldSize.md,
                    ),
                    SizedBox(height: AppSpacing.space16),

                    // 비밀번호 입력
                    AppTextField(
                      controller: _passwordController,
                      label: '비밀번호',
                      hintText: '비밀번호를 입력하세요',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      size: AppTextFieldSize.md,
                    ),
                    SizedBox(height: AppSpacing.space12),

                    // 로그인 유지 체크박스
                    Row(
                      children: [
                        AppCheckbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v),
                        ),
                        SizedBox(width: AppSpacing.space8),
                        Text(
                          '로그인 유지',
                          style: AppTextStyles.label1NormalRegular.copyWith(
                            color: AppColor.colorGlobalCoolNeutral40,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space24),

                    // 로그인 버튼
                    AppSolidButton(
                      label: '로그인',
                      tone: AppSolidButtonTone.primary,
                      size: AppSolidButtonSize.large,
                      onPressed: () {
                        debugPrint('Login: ${_emailController.text}');
                      },
                    ),
                    SizedBox(height: AppSpacing.space12),

                    // 비밀번호 찾기 텍스트 버튼
                    AppTextButton(
                      label: '비밀번호를 잊으셨나요?',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.space24),

              // ── 소셜 로그인 구분선 ──
              const AppDivider(),

              SizedBox(height: AppSpacing.space24),

              // ── 소셜 로그인 버튼 ──
              Text(
                '간편 로그인',
                style: AppTextStyles.caption1Regular.copyWith(
                  color: AppColor.colorGlobalCoolNeutral50,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.space16),

              // 소셜 버튼 행
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIconButton(
                    icon: Icons.apple,
                    onPressed: () {},
                  ),
                  SizedBox(width: AppSpacing.space16),
                  AppIconButton(
                    icon: Icons.g_mobiledata,
                    onPressed: () {},
                  ),
                  SizedBox(width: AppSpacing.space16),
                  AppIconButton(
                    icon: Icons.chat_bubble,
                    onPressed: () {},
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.space40),

              // ══════════════════════════════════════════
              // Foundation 토큰 통합 테스트 영역
              // ══════════════════════════════════════════

              // ── Gradient 토큰 테스트 ──
              Container(
                height: 120,
                decoration: AppGradient.decoration(
                  AppGradient.solidBottom(),
                ),
                child: Center(
                  child: Text(
                    'Gradient.solidBottom 테스트',
                    style: AppTextStyles.body2NormalRegular.copyWith(
                      color: AppColor.colorGlobalCommon100,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.space16),

              // ── Decorate Dimmer 테스트 ──
              Container(
                padding: EdgeInsets.all(AppSpacing.space16),
                decoration: BoxDecoration(
                  color: AppDecorate.dimmer,
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                ),
                child: Text(
                  'Dimmer 오버레이 테스트 (52% opacity)',
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: AppSpacing.space16),

              // ── Icon SVG 테스트 ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CoflanetIcon(
                    CoflanetIcons.home,
                    size: CoflanetIconSize.large,
                    color: AppColor.colorGlobalCoolNeutral10,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  CoflanetIcon(
                    CoflanetIcons.search,
                    size: CoflanetIconSize.normal,
                    color: AppColor.colorGlobalCoolNeutral40,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  CoflanetIcon(
                    CoflanetIcons.bell,
                    size: CoflanetIconSize.medium,
                    color: AppColor.colorGlobalCoolNeutral60,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  CoflanetIcon(
                    CoflanetIcons.person,
                    size: CoflanetIconSize.small,
                    color: AppColor.colorGlobalCoolNeutral80,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  CoflanetIcon(
                    CoflanetIcons.setting,
                    size: CoflanetIconSize.tiny,
                    color: AppColor.colorGlobalCoolNeutral90,
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.space16),

              // ── Shadow 테스트 ──
              Container(
                padding: EdgeInsets.all(AppSpacing.space16),
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCommon100,
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                  boxShadow: AppShadows.shadowPrimaryEmphasize,
                ),
                child: Text(
                  'Primary Emphasize Shadow 테스트',
                  style: AppTextStyles.body2NormalRegular,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: AppSpacing.space16),

              // ── Interaction 테스트 ──
              Container(
                padding: EdgeInsets.all(AppSpacing.space16),
                decoration: BoxDecoration(
                  color: AppDecorate.interactionColor(
                    intensity: InteractionIntensity.strong,
                    state: InteractionState.pressed,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                ),
                child: Text(
                  'Interaction Strong/Pressed 테스트',
                  style: AppTextStyles.body2NormalRegular,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
