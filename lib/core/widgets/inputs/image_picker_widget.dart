import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?)? onImageSelected;
  final double width;
  final double height;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final double iconSize;
  final String? initialImagePath;

  const ImagePickerWidget({
    super.key,
    this.onImageSelected,
    this.width = 100,
    this.height = 100,
    this.borderWidth = 1,
    this.borderRadius = 16,
    this.borderColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.iconSize = 24,
    this.initialImagePath,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  /// اختيار صورة من الاستوديو
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        // إرسال الصورة المختارة للوالد
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_selectedImage);
        }
      }
    } catch (e) {
      debugPrint('خطأ في اختيار الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImageFromGallery,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: widget.borderColor,
            strokeWidth: widget.borderWidth,
            dashLength: 8,
            gapLength: 8,
            borderRadius: widget.borderRadius,
          ),
          child: Container(
            margin: EdgeInsets.all(widget.borderWidth),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(
                  widget.borderRadius - widget.borderWidth),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                        widget.borderRadius - widget.borderWidth),
                    child: Image.file(
                      _selectedImage!,
                      width: widget.width - (widget.borderWidth * 2),
                      height: widget.height - (widget.borderWidth * 2),
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: SvgPicture.asset(
                      'assets/svg/camera.svg',
                      width: widget.iconSize,
                      height: widget.iconSize,
                      color: widget.borderColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// ✅ رسام مخصص للحدود المقطعة
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(borderRadius),
    );

    _drawDashedRRect(canvas, rrect, paint);
  }

  void _drawDashedRRect(Canvas canvas, RRect rrect, Paint paint) {
    final Path path = Path()..addRRect(rrect);
    final PathMetrics pathMetrics = path.computeMetrics();

    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < pathMetric.length) {
        final double length = draw ? dashLength : gapLength;
        final double nextDistance = distance + length;

        if (draw && distance < pathMetric.length) {
          final Path extractPath = pathMetric.extractPath(
            distance,
            nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
          );
          canvas.drawPath(extractPath, paint);
        }

        distance = nextDistance;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
