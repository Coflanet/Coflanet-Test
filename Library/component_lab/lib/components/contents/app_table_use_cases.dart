import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_table.dart';

// ═══════════════════════════════════════════════════════════════
// TABLE — Figma `Contents / Table`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> tableUseCases = [
  WidgetbookComponent(
    name: 'Table — Basic',
    useCases: [
      WidgetbookUseCase(
        name: 'Simple Table',
        builder: (context) => _bg(
          context,
          AppTable(
            columns: const [
              AppTableColumn(header: 'Name'),
              AppTableColumn(header: 'Email'),
              AppTableColumn(header: 'Status'),
            ],
            rows: [
              [
                const Text('John Doe'),
                const Text('john@example.com'),
                const Text('Active'),
              ],
              [
                const Text('Jane Smith'),
                const Text('jane@example.com'),
                const Text('Inactive'),
              ],
              [
                const Text('Bob Johnson'),
                const Text('bob@example.com'),
                const Text('Active'),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Table with Input',
        builder: (context) => _bg(
          context,
          AppTable(
            columns: const [
              AppTableColumn(header: 'Product'),
              AppTableColumn(header: 'Quantity'),
              AppTableColumn(header: 'Price'),
            ],
            rows: [
              [
                const Text('Laptop'),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                ),
                const Text('\$999'),
              ],
              [
                const Text('Mouse'),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                ),
                const Text('\$29'),
              ],
            ],
            contentType: AppTableContentType.input,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Table — Interactive',
    useCases: [
      WidgetbookUseCase(
        name: 'Tappable Rows',
        builder: (context) => _bg(
          context,
          AppTable(
            columns: const [
              AppTableColumn(header: 'Item'),
              AppTableColumn(header: 'Category'),
              AppTableColumn(header: 'Price'),
            ],
            rows: [
              [
                const Text('Coffee'),
                const Text('Beverage'),
                const Text('\$3.50'),
              ],
              [
                const Text('Bread'),
                const Text('Bakery'),
                const Text('\$2.00'),
              ],
              [
                const Text('Milk'),
                const Text('Dairy'),
                const Text('\$2.50'),
              ],
            ],
            onCellTap: (rowIndex, colIndex) {
              print('Row $rowIndex, Column $colIndex tapped');
            },
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Table — Data Types',
    useCases: [
      WidgetbookUseCase(
        name: 'Mixed Content',
        builder: (context) => _bg(
          context,
          AppTable(
            columns: const [
              AppTableColumn(header: 'User'),
              AppTableColumn(header: 'Score'),
              AppTableColumn(header: 'Status'),
            ],
            rows: [
              [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Text('JD'),
                    ),
                    const SizedBox(width: 8),
                    const Text('John Doe'),
                  ],
                ),
                const Text('95/100'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Pass',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
              [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Text('JS'),
                    ),
                    const SizedBox(width: 8),
                    const Text('Jane Smith'),
                  ],
                ),
                const Text('88/100'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Pass',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
              [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Text('BJ'),
                    ),
                    const SizedBox(width: 8),
                    const Text('Bob Johnson'),
                  ],
                ),
                const Text('72/100'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Fail',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.space16),
    color: Theme.of(context).canvasColor,
    child: SingleChildScrollView(
      child: child,
    ),
  );
}
