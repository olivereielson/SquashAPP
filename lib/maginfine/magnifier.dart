import 'dart:ui';

import 'magnifier_painter.dart';
import 'package:flutter/material.dart';

class Magnifier extends StatefulWidget {
  const Magnifier(
      {@required this.child,
      @required this.position,
      this.visible = true,
      this.scale = 1.5,
      this.size = const Size(160, 160)
      })
      : assert(child != null);

  final Widget child;
  final Offset position;
  final bool visible;
  final double scale;
  final Size size;

  @override
  _MagnifierState createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  Size _magnifierSize;
  double _scale;
  Matrix4 _matrix;

  @override
  void initState() {
    _magnifierSize = widget.size;
    _scale = widget.scale;
    super.initState();

    _calculateMatrix();

  }

  @override
  void didUpdateWidget(Magnifier oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateMatrix();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.visible && widget.position != null)
               _getMagnifier(context)
      ],
    );
  }

  void _calculateMatrix() {
    if (widget.position == null) {
      return;
    }

    setState(() {
      double newX = widget.position.dx - (_magnifierSize.width / 2 / _scale)-(((MediaQuery.of(context).size.width-widget.size.width)/2)/_scale);
      double newY = widget.position.dy - (_magnifierSize.height / 2 / _scale)-(100/_scale);



      final Matrix4 updatedMatrix = Matrix4.identity()
        ..scale(_scale, _scale)
        ..translate(-newX, -newY);

      _matrix = updatedMatrix;
    });

  }

  Widget _getMagnifier(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width-widget.size.width)/2,vertical: 100),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.matrix(_matrix.storage),
          child: CustomPaint(
            painter: MagnifierPainter(
                color: Theme.of(context).accentColor
            ),
            size: _magnifierSize,
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    if (_bubbleCrossesMagnifier()) {
      return Alignment.topLeft;
    }
    return Alignment.topLeft;
  }
  bool _bubbleCrossesMagnifier() => widget.position.dx < widget.size.width &&
      widget.position.dy < widget.size.height;

}
