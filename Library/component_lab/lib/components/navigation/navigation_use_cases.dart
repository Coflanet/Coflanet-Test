import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/app_spacing.dart';
import 'app_top_navigation.dart';
import 'app_bottom_navigation.dart';
import 'app_gnb.dart';
import 'app_footer.dart';

/// Navigation 컴포넌트 미리보기 화면.
class NavigationUseCases extends StatefulWidget {
  const NavigationUseCases({super.key});

  @override
  State<NavigationUseCases> createState() => _NavigationUseCasesState();
}

class _NavigationUseCasesState extends State<NavigationUseCases> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('GNB'),
              AppGnb(
                logo: const Text(
                  'Coflanet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  GnbAction(icon: Icons.search, onPressed: () {}),
                  GnbAction(
                    icon: Icons.notifications_none,
                    onPressed: () {},
                    showBadge: true,
                  ),
                  GnbAction(icon: Icons.settings_outlined, onPressed: () {}),
                ],
              ),

              const Divider(height: 32),

              _sectionTitle('Top Navigation — Normal'),
              AppTopNavigation(
                title: '제목',
                variant: TopNavigationVariant.normal,
                leadingIcon: Icons.arrow_back_ios_new,
                onLeadingPressed: () {},
                trailingActions: [
                  TopNavAction(icon: Icons.search, onPressed: () {}),
                ],
              ),

              const SizedBox(height: 16),

              _sectionTitle('Top Navigation — Extended'),
              AppTopNavigation(
                title: '제목',
                variant: TopNavigationVariant.extended,
                leadingIcon: Icons.arrow_back_ios_new,
                onLeadingPressed: () {},
                trailingActions: [
                  TopNavAction(icon: Icons.search, onPressed: () {}),
                  TopNavAction(
                    icon: Icons.notifications_none,
                    showBadge: true,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _sectionTitle('Top Navigation — Floating'),
              Container(
                height: 100,
                color: AppColor.backgroundNormalAlternative,
                child: Stack(
                  children: [
                    const Center(child: Text('콘텐츠 영역')),
                    AppTopNavigation(
                      variant: TopNavigationVariant.floating,
                      leadingIcon: Icons.arrow_back_ios_new,
                      onLeadingPressed: () {},
                      trailingActions: [
                        TopNavAction(icon: Icons.share_outlined),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              _sectionTitle('Bottom Navigation (Tab Bar)'),
              AppBottomNavigation(
                currentIndex: _tabIndex,
                onTap: (i) => setState(() => _tabIndex = i),
                useSafeArea: false,
                items: const [
                  BottomNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: '홈',
                  ),
                  BottomNavItem(
                    icon: Icons.coffee_outlined,
                    activeIcon: Icons.coffee,
                    label: '원두',
                  ),
                  BottomNavItem(
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    label: '커뮤니티',
                  ),
                  BottomNavItem(
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                    label: '쇼핑',
                  ),
                  BottomNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: '마이',
                  ),
                ],
              ),

              const Divider(height: 32),

              _sectionTitle('Footer'),
              AppFooter(
                snsItems: [
                  FooterSnsItem(icon: Icons.camera_alt_outlined),
                  FooterSnsItem(icon: Icons.chat_bubble_outline),
                  FooterSnsItem(icon: Icons.play_circle_outline),
                ],
                customerServiceTitle: '고객센터 (평일 오전 9시 ~ 오후 5시 운영)',
                customerServiceBody:
                    '문의전화 0000-0000\n고객전용 메일 : help.info@gmail.com\n사업제휴 메일 : coplanet.biz@gmail.com',
                businessInfoTitle: '커플래닛 사업자 정보',
                businessInfoBody:
                    '대표이사: 홍길동\n사업자등록번호: 000-00-00000\n통신판매업 신고번호: 2024-서울강남-00000',
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space8,
      ),
      child: Text(
        text,
        style: AppTextStyles.headline1Bold.copyWith(
          color: AppColor.labelStrong,
        ),
      ),
    );
  }
}
