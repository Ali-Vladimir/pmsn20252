import 'package:flutter/material.dart';

/// Widget personalizado que crea un efecto parallax en imágenes
/// Este es un widget diferente a los vistos en clase
class ParallaxImage extends StatelessWidget {
  final String imagePath;
  final double height;
  final double parallaxFactor;
  final BoxFit fit;

  const ParallaxImage({
    super.key,
    required this.imagePath,
    this.height = 200,
    this.parallaxFactor = 0.5,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              return true;
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRect(
                    child: OverflowBox(
                      maxHeight: height * (1 + parallaxFactor),
                      minHeight: height * (1 + parallaxFactor),
                      child: Image.asset(
                        imagePath,
                        fit: fit,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withOpacity(0.3),
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.white54,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Widget que crea un efecto de parallax animado con scroll
class AnimatedParallax extends StatefulWidget {
  final String imagePath;
  final double height;
  final Widget? child;

  const AnimatedParallax({
    super.key,
    required this.imagePath,
    this.height = 300,
    this.child,
  });

  @override
  State<AnimatedParallax> createState() => _AnimatedParallaxState();
}

class _AnimatedParallaxState extends State<AnimatedParallax>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -50,
      end: 50,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: Container(
                  height: widget.height + 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.child != null)
            Positioned.fill(
              child: widget.child!,
            ),
        ],
      ),
    );
  }
}
