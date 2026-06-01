import 'package:flutter/material.dart';

class DivisorHorizontal extends StatelessWidget{

  final double width;
  final GestureDragUpdateCallback onDragUpdate;

  const DivisorHorizontal({
    required this.width,
    required this.onDragUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: onDragUpdate,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: SizedBox(
          width: width,
          child: Center(
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}