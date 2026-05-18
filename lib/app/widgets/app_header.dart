import 'package:flutter/material.dart';
import '../data/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  final bool isScrolled;

  const AppHeader({super.key, required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(isScrolled),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isScrolled;

  _HeaderDelegate(this.isScrolled);

  @override
  double get minExtent => 90;

  @override
  double get maxExtent => 90;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Material(
      color: AppColors.white,
      elevation: isScrolled ? 8 : 3,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Image.asset("assets/images/kotoba-logo.png", height: 45),
            const SizedBox(width: 10),
            Text(
              "Kotoba",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.isScrolled != isScrolled;
  }
}
