import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const Loading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1500))..repeat(reverse: true);
    animation = Tween<double>(begin: 0.5, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading) Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: AnimatedBuilder(
              animation: animation, 
              builder: (context, child) {
                return Opacity(
                  opacity: animation.value,
                  child: SvgPicture.asset("assets/images/mapminder_logo.svg", height: 80, width: 80),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
