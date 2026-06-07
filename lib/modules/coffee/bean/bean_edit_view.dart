import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/services/app_config_service.dart';
import 'package:coflanet/data/models/bean_option_model.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/bean/widgets/bean_flavor_slider.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart';
import 'package:coflanet/widgets/tags/flavor_tag.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';
import 'package:coflanet/widgets/modals/modal_utils.dart';
import 'package:coflanet/widgets/modals/unsaved_changes_modal.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// Bean Edit View (원두 추가/편집)
///
/// Form for creating or editing a coffee bean with:
/// - Brand name, bean name
/// - Flavor profile sliders
/// - Flavor tags selection
/// - Origin, roast level, process method
///
/// 슬라이더는 widgets/BeanFlavorSlider, 섹션 타이틀은 공통 SectionTitle 재사용.
/// 파일이 400줄 임계값을 초과하지만, 잔여 코드는 TextEditingController
/// 생명주기/저장 플로우/PopScope 등 폼 State 와 강결합되어 있어
/// 순수 위젯으로 추출할 수 없는 정당한 예외다.
class BeanEditView extends StatefulWidget {
  const BeanEditView({super.key});

  @override
  State<BeanEditView> createState() => _BeanEditViewState();
}

class _BeanEditViewState extends State<BeanEditView> {
  late CoffeeItem? _existingBean;
  late bool _isEditing;

  // Form controllers
  final _brandController = TextEditingController();
  final _nameController = TextEditingController();
  final _originController = TextEditingController();

  // Flavor profile values (0-100 scale, matching Supabase schema)
  double _acidity = 50;
  double _body = 50;
  double _sweetness = 50;
  double _bitterness = 50;
  double _balance = 50;
  double _aromaIntensity = 50;

  // Selected flavor tags
  final Set<String> _selectedCommonFlavors = {};
  final Set<String> _selectedCharacteristicFlavors = {};

  // Selected options — 서버 lookup 기반 (로스팅은 level_code, 가공방식은 code)
  String? _selectedRoastLevel;
  String? _selectedProcessCode;

  bool _hasChanges = false;

  final AppConfigService _config = Get.find<AppConfigService>();

  List<ProcessOption> get _processMethods => _config.processMethods;

  /// 로스팅 — 라벨(level_code) 기준 distinct 4개(라이트/미디엄/미디엄 다크/다크)만 표시.
  /// [세분화 예정] roast_point 1~10 세분화 시 _config.roastLevels 를 직접 사용.
  List<RoastOption> get _roastLevelGroups {
    final seen = <String>{};
    final groups = <RoastOption>[];
    for (final r in _config.roastLevels) {
      if (seen.add(r.levelCode)) groups.add(r);
    }
    return groups;
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _existingBean = args?['bean'] as CoffeeItem?;
    _isEditing = _existingBean != null;

    if (_isEditing && _existingBean != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final bean = _existingBean!;
    _brandController.text = bean.brand ?? '';
    _nameController.text = bean.name;
    _originController.text = bean.origin ?? '';

    if (bean.flavorProfile != null) {
      _acidity = bean.flavorProfile!.acidity;
      _body = bean.flavorProfile!.body;
      _sweetness = bean.flavorProfile!.sweetness;
      _bitterness = bean.flavorProfile!.bitterness;
      _balance = bean.flavorProfile!.balance;
    }

    _aromaIntensity = bean.aromaIntensity ?? 50;
    _selectedCommonFlavors.addAll(bean.commonFlavors ?? []);
    _selectedCharacteristicFlavors.addAll(bean.characteristicFlavors ?? []);
    _selectedRoastLevel = bean.roastLevel;
    _selectedProcessCode = bean.processMethod;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _nameController.dispose();
    _originController.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await ModalUtils.showUnsavedChanges();
    return result == UnsavedChangesResult.discardAndExit;
  }

  void _onSave() {
    // Validate required fields
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        '입력 오류',
        '원두 이름을 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.statusNegative,
        colorText: AppColor.staticLabelWhiteStrong,
      );
      return;
    }

    // Create the bean object
    final bean = CoffeeItem(
      id: _existingBean?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _generateDescription(),
      color: _existingBean?.color ?? AppColor.colorGlobalViolet50,
      brand: _brandController.text.trim().isNotEmpty
          ? _brandController.text.trim()
          : null,
      flavorProfile: FlavorProfile(
        acidity: _acidity,
        body: _body,
        sweetness: _sweetness,
        bitterness: _bitterness,
        balance: _balance,
      ),
      commonFlavors: _selectedCommonFlavors.toList(),
      characteristicFlavors: _selectedCharacteristicFlavors.toList(),
      aromaIntensity: _aromaIntensity,
      origin: _originController.text.trim().isNotEmpty
          ? _originController.text.trim()
          : null,
      roastLevel: _selectedRoastLevel,
      roastPoint: _findRoastByLevel(_selectedRoastLevel)?.point,
      processMethod: _selectedProcessCode,
    );

    // Return to previous screen with the bean data
    Get.back(result: bean);
  }

  /// 선택한 level_code 에 해당하는 대표 옵션 조회 (roast_point 저장용)
  RoastOption? _findRoastByLevel(String? code) {
    if (code == null) return null;
    for (final r in _roastLevelGroups) {
      if (r.levelCode == code) return r;
    }
    return null;
  }

  String _generateDescription() {
    final parts = <String>[];

    if (_selectedCommonFlavors.isNotEmpty) {
      parts.add(_selectedCommonFlavors.take(2).join(', '));
    }

    if (_acidity >= 70) {
      parts.add('산미가 강한');
    } else if (_body >= 70) {
      parts.add('묵직한 바디감의');
    } else if (_sweetness >= 70) {
      parts.add('달콤한');
    }

    if (parts.isEmpty) {
      return '균형 잡힌 풍미의 커피';
    }

    return '${parts.join(', ')} 커피';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.colorGlobalCommon0,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(),
                      const SizedBox(height: 32),
                      _buildFlavorProfileSection(),
                      const SizedBox(height: 32),
                      _buildFlavorTagsSection(),
                      const SizedBox(height: 32),
                      _buildDetailsSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              AssetPath.iconArrowBack,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColor.colorGlobalCommon100,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop) Get.back();
            },
          ),
          const Spacer(),
          Text(
            _isEditing ? '원두 편집' : '원두 추가',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('기본 정보'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _brandController,
          label: '브랜드명',
          hint: '브랜드명을 입력해주세요',
          isRequired: false,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          label: '원두 이름',
          hint: '원두 이름을 입력해주세요',
          isRequired: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _originController,
          label: '원산지',
          hint: '예: 에티오피아 예가체프',
          isRequired: false,
        ),
      ],
    );
  }

  Widget _buildFlavorProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('향미 프로필'),
        const SizedBox(height: 16),
        // Radar chart preview
        Center(
          child: FlavorRadarChart(
            profile: FlavorProfile(
              acidity: _acidity,
              body: _body,
              sweetness: _sweetness,
              bitterness: _bitterness,
              balance: _balance,
            ),
            size: 180,
            showLabels: true,
            showValues: false,
            animate: false,
            fillColor: AppColor.primaryNormal.withValues(alpha: 0.15),
            strokeColor: AppColor.primaryNormal,
            gridColor: AppColor.colorGlobalCoolNeutral30,
            labelColor: AppColor.colorGlobalCommon100,
          ),
        ),
        const SizedBox(height: 24),
        // 슬라이더 — setState + 변경 플래그는 클로저에 잔류 (위젯은 값/콜백만)
        BeanFlavorSlider(
          label: '산미',
          value: _acidity,
          onChanged: (v) {
            setState(() => _acidity = v);
            _markChanged();
          },
        ),
        BeanFlavorSlider(
          label: '바디감',
          value: _body,
          onChanged: (v) {
            setState(() => _body = v);
            _markChanged();
          },
        ),
        BeanFlavorSlider(
          label: '단맛',
          value: _sweetness,
          onChanged: (v) {
            setState(() => _sweetness = v);
            _markChanged();
          },
        ),
        BeanFlavorSlider(
          label: '쓴맛',
          value: _bitterness,
          onChanged: (v) {
            setState(() => _bitterness = v);
            _markChanged();
          },
        ),
        BeanFlavorSlider(
          label: '밸런스',
          value: _balance,
          onChanged: (v) {
            setState(() => _balance = v);
            _markChanged();
          },
        ),
        const SizedBox(height: 16),
        BeanFlavorSlider(
          label: '향의 진함',
          value: _aromaIntensity,
          onChanged: (v) {
            setState(() => _aromaIntensity = v);
            _markChanged();
          },
        ),
      ],
    );
  }

  Widget _buildFlavorTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('향미 태그'),
        const SizedBox(height: 16),
        // Common flavors
        Text(
          '공통 향미',
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: AppColor.colorGlobalCoolNeutral60,
          ),
        ),
        const SizedBox(height: 12),
        FlavorTagGroup(
          tags: FlavorCategories.common,
          selectedTags: _selectedCommonFlavors,
          style: FlavorTagStyle.secondary,
          onTagTap: (tag) {
            setState(() {
              if (_selectedCommonFlavors.contains(tag)) {
                _selectedCommonFlavors.remove(tag);
              } else {
                _selectedCommonFlavors.add(tag);
              }
            });
            _markChanged();
          },
        ),
        const SizedBox(height: 24),
        // Characteristic flavors
        Text(
          '특성 향미',
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: AppColor.colorGlobalCoolNeutral60,
          ),
        ),
        const SizedBox(height: 12),
        FlavorTagGroup(
          tags: FlavorCategories.characteristic,
          selectedTags: _selectedCharacteristicFlavors,
          style: FlavorTagStyle.secondary,
          onTagTap: (tag) {
            setState(() {
              if (_selectedCharacteristicFlavors.contains(tag)) {
                _selectedCharacteristicFlavors.remove(tag);
              } else {
                _selectedCharacteristicFlavors.add(tag);
              }
            });
            _markChanged();
          },
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('상세 정보'),
        const SizedBox(height: 16),
        // 로스팅 — 라벨 4단계(라이트/미디엄/미디엄 다크/다크) 표시
        _buildDropdownField<String>(
          label: '로스팅',
          value:
              _roastLevelGroups.any((r) => r.levelCode == _selectedRoastLevel)
              ? _selectedRoastLevel
              : null,
          items: _roastLevelGroups
              .map(
                (r) => DropdownMenuItem<String>(
                  value: r.levelCode,
                  child: Text(r.labelKo),
                ),
              )
              .toList(),
          onChanged: (v) {
            setState(() => _selectedRoastLevel = v);
            _markChanged();
          },
        ),
        const SizedBox(height: 16),
        // 가공 방식 — code 선택, 한국어 라벨 표시
        _buildDropdownField<String>(
          label: '가공 방식',
          value: _processMethods.any((p) => p.code == _selectedProcessCode)
              ? _selectedProcessCode
              : null,
          items: _processMethods
              .map(
                (p) => DropdownMenuItem<String>(
                  value: p.code,
                  child: Text(p.labelKo),
                ),
              )
              .toList(),
          onChanged: (v) {
            setState(() => _selectedProcessCode = v);
            _markChanged();
          },
        ),
      ],
    );
  }

  /// 섹션 타이틀 — 공통 SectionTitle 재사용 (titleStyle 명시 주입)
  Widget _buildSectionTitle(String title) {
    return SectionTitle(
      title: title,
      titleStyle: AppTextStyles.headline2Bold.copyWith(
        color: AppColor.colorGlobalCommon100,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: AppColor.statusNegative,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: (_) => _markChanged(),
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: AppColor.colorGlobalCommon100,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral50,
            ),
            filled: true,
            fillColor: AppColor.colorGlobalCoolNeutral15,
            border: OutlineInputBorder(
              borderRadius: AppRadius.lgBorder,
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: AppColor.colorGlobalCoolNeutral60,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.colorGlobalCoolNeutral15,
            borderRadius: AppRadius.lgBorder,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(
                '선택해주세요',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.colorGlobalCoolNeutral50,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColor.colorGlobalCoolNeutral60,
              ),
              dropdownColor: AppColor.colorGlobalCoolNeutral15,
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: AppColor.colorGlobalCommon100,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar.primaryButton(
      text: _isEditing ? '저장' : '추가',
      onPressed: _onSave,
      padding: const EdgeInsets.all(24),
    );
  }
}
