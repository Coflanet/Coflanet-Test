import 'dart:async';

import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import '../forms/app_text_field.dart';

/// AutoComplete 결과 fetcher.
///
/// 동기 또는 비동기 모두 지원 — 동기는 `FutureOr` 패턴으로 즉시 반환.
typedef AppAutoCompleteFetch<T> = FutureOr<List<T>> Function(String query);

/// Auto Complete — Figma `Auto Complete/*`.
///
/// 텍스트 입력 → debounce → 항목 필터 → 선택 콜백.
/// `AppSelect<T>`의 오버레이 패턴을 재사용한 텍스트 입력 기반 변형.
class AppAutoComplete<T> extends StatefulWidget {
  const AppAutoComplete({
    super.key,
    required this.fetch,
    required this.itemLabel,
    this.onSelected,
    this.label,
    this.hintText = '검색',
    this.debounce = const Duration(milliseconds: 200),
    this.minLength = 1,
    this.maxOverlayHeight = 240,
    this.emptyText = '결과가 없어요',
    this.isEnabled = true,
  });

  /// query → 결과 리스트.
  final AppAutoCompleteFetch<T> fetch;

  /// 항목을 텍스트로 변환.
  final String Function(T) itemLabel;

  /// 선택 콜백. 호출 시 입력 필드는 선택값 라벨로 채워짐.
  final ValueChanged<T>? onSelected;

  final String? label;
  final String hintText;
  final Duration debounce;

  /// 이 길이 미만이면 fetch 미호출, 오버레이 닫기.
  final int minLength;

  final double maxOverlayHeight;
  final String emptyText;
  final bool isEnabled;

  @override
  State<AppAutoComplete<T>> createState() => _AppAutoCompleteState<T>();
}

class _AppAutoCompleteState<T> extends State<AppAutoComplete<T>> {
  final _layerLink = LayerLink();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;
  List<T> _results = [];
  bool _loading = false;
  int _fetchSeq = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _close();
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text;
    _debounceTimer?.cancel();
    if (query.length < widget.minLength) {
      _results = [];
      _close();
      return;
    }
    _debounceTimer = Timer(widget.debounce, () => _runFetch(query));
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // 약간의 지연으로 항목 탭 처리 후 닫기
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && !_focusNode.hasFocus) _close();
      });
    } else if (_results.isNotEmpty) {
      _open();
    }
  }

  Future<void> _runFetch(String query) async {
    final seq = ++_fetchSeq;
    setState(() => _loading = true);
    final results = await Future.value(widget.fetch(query));
    if (!mounted || seq != _fetchSeq) return;
    setState(() {
      _results = results;
      _loading = false;
    });
    _open();
  }

  void _open() {
    if (!mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;
    final overlay = Overlay.of(context);
    final size = renderObject.size;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
          child: _Overlay<T>(
            results: _results,
            itemLabel: widget.itemLabel,
            loading: _loading,
            emptyText: widget.emptyText,
            maxHeight: widget.maxOverlayHeight,
            onTap: _onItemTap,
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onItemTap(T item) {
    widget.onSelected?.call(item);
    _controller
      ..text = widget.itemLabel(item)
      ..selection = TextSelection.collapsed(offset: widget.itemLabel(item).length);
    _close();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AppTextField(
        controller: _controller,
        focusNode: _focusNode,
        label: widget.label,
        hintText: widget.hintText,
        prefixIcon: Icons.search_rounded,
        isEnabled: widget.isEnabled,
      ),
    );
  }
}

class _Overlay<T> extends StatelessWidget {
  const _Overlay({
    required this.results,
    required this.itemLabel,
    required this.loading,
    required this.emptyText,
    required this.maxHeight,
    required this.onTap,
  });

  final List<T> results;
  final String Function(T) itemLabel;
  final bool loading;
  final String emptyText;
  final double maxHeight;
  final ValueChanged<T> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: AppColor.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          boxShadow: AppShadows.shadowBlackStrong,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (loading && results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.space16),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Text(
          emptyText,
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (_, i) {
        final item = results[i];
        return InkWell(
          onTap: () => onTap(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.space12,
            ),
            child: Text(
              itemLabel(item),
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
        );
      },
    );
  }
}
