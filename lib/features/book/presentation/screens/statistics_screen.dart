import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê')),
      body: books.when(
        data: (list) {
          final total = list.length;
          final completed = list.where((b) => b.status == 'completed').length;
          final reading = list.where((b) => b.status == 'reading').length;
          final pages = list.fold(0, (s, b) => s + (b.pageCount ?? 0));

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Tổng sách: $total', style: Theme.of(context).textTheme.headlineSmall),
                Text('Đã đọc xong: $completed'),
                Text('Đang đọc: $reading'),
                Text('Tổng trang đã đọc: $pages'),
                const SizedBox(height: 40),
                SizedBox(
                  height: 300,
                  child: PieChart(PieChartData(sections: [
                    PieChartSectionData(value: completed.toDouble(), color: Colors.green, title: 'Đã đọc ($completed)'),
                    PieChartSectionData(value: reading.toDouble(), color: Colors.blue, title: 'Đang đọc ($reading)'),
                    PieChartSectionData(
                        value: (total - completed - reading).toDouble(), color: Colors.grey, title: 'Khác (${total - completed - reading})'),
                  ])),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Lỗi tải dữ liệu')),
      ),
    );
  }
}