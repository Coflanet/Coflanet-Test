import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Table 콘텐츠 타입 — Figma `Table/Table` Content variant.
enum AppTableContentType {
  /// 표시만 하는 일반 셀
  normal,

  /// 입력 가능한 셀
  input,
}

/// Table 컬럼 정의.
class AppTableColumn {
  const AppTableColumn({
    required this.header,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  });

  final String header;
  final int flex;
  final Alignment alignment;
}

/// Table 컴포넌트 — Figma `Table/Table`.
///
/// Content: Normal / Input
class AppTable extends StatelessWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
    this.contentType = AppTableContentType.normal,
    this.showHeader = true,
    this.onCellTap,
  });

  final List<AppTableColumn> columns;

  /// 각 row는 column 순서와 동일한 길이의 위젯 리스트.
  final List<List<Widget>> rows;

  final AppTableContentType contentType;
  final bool showHeader;
  final void Function(int row, int column)? onCellTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.colorGlobalCoolNeutral95),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (showHeader) _buildHeader(),

          // Rows
          ...List.generate(rows.length, (i) => _buildRow(i)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColor.colorGlobalCoolNeutral99,
      child: Row(
        children: List.generate(columns.length, (i) {
          return Expanded(
            flex: columns[i].flex,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space12,
                vertical: AppSpacing.space8,
              ),
              alignment: columns[i].alignment,
              child: Text(
                columns[i].header,
                style: AppTextStyles.caption1Bold.copyWith(
                  color: AppColor.colorGlobalCoolNeutral40,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRow(int rowIndex) {
    final isLast = rowIndex == rows.length - 1;
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColor.colorGlobalCoolNeutral97,
                ),
              ),
      ),
      child: Row(
        children: List.generate(columns.length, (colIndex) {
          return Expanded(
            flex: columns[colIndex].flex,
            child: GestureDetector(
              onTap: onCellTap != null
                  ? () => onCellTap!(rowIndex, colIndex)
                  : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space12,
                  vertical: AppSpacing.space8,
                ),
                alignment: columns[colIndex].alignment,
                child: rows[rowIndex][colIndex],
              ),
            ),
          );
        }),
      ),
    );
  }
}
