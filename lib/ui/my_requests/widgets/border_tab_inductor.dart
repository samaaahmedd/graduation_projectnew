import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: TabBar(
        indicator: BorderTabIndicator(
          indicatorHeight: 32,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        ),
        controller: tabController,
        labelPadding: const EdgeInsets.symmetric(horizontal: 32),
        isScrollable: true,
        labelStyle: TextStyles.bold(fontSize: 15),
        labelColor: AppColors.neutral_600,
        unselectedLabelColor: AppColors.neutral_600,
        physics: const BouncingScrollPhysics(),
        onTap: (index) => tabController.animateTo(
          index,
          duration: const Duration(milliseconds: 300),
        ),
        tabs: const [
          Tab(text: 'Waiting'),
          Tab(text: 'Accepted'),
          Tab(text: 'Canceled'),
        ],
      ),
    );
  }
}

class BorderTabIndicator extends Decoration {
  const BorderTabIndicator({
    required this.indicatorHeight,
    required this.textScaleFactor,
  }) : super();

  final double indicatorHeight;
  final double textScaleFactor;

  @override
  BorderPainter createBoxPainter([VoidCallback? onChanged]) {
    return BorderPainter(this, indicatorHeight, textScaleFactor, onChanged);
  }
}

class BorderPainter extends BoxPainter {
  BorderPainter(
    this.decoration,
    this.indicatorHeight,
    this.textScaleFactor,
    VoidCallback? onChanged,
  )   : assert(indicatorHeight >= 0),
        super(onChanged);

  final BorderTabIndicator decoration;
  final double indicatorHeight;
  final double textScaleFactor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final horizontalInset = 16 - 4 * textScaleFactor;
    final rect = Offset(offset.dx + horizontalInset,
            (configuration.size!.height / 2) - indicatorHeight / 2 - 1) &
        Size(configuration.size!.width - 2 * horizontalInset, indicatorHeight);
    final paint = Paint();
    paint.color = AppColors.neutral_600;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(56)),
      paint,
    );
  }
}
