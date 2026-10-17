import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../data/mock_data.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: MockData.categories.length,
          itemBuilder: (_, i) {
            final cat = MockData.categories[i];
            return AspectRatio(
              aspectRatio: i.isEven ? 0.85 : 0.95,
              child: CategoryCard(category: cat),
            );
          },
        ),
      ),
    );
  }
}
