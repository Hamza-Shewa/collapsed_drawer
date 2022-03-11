import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'collapsed_button.dart';

class CollapsedDrawer extends StatefulWidget {
  /// [buttons] are a list of CollapsedButton object
  /// [minWidth] is 75 by default
  /// [maxWidth] is 200 by default
  /// [duration] is 250 milliseconds by default
  /// [fontSize] is 14 by default
  /// [buttonMargin] is set to All(4.0) by default
  CollapsedDrawer({
    Key? key,
    this.leading,
    required this.icon,
    required this.buttons,
    this.divider,
    this.minWidth = 75,
    this.maxWidth = 200,
    this.duration = const Duration(milliseconds: 250),
    this.padding = const EdgeInsets.all(8),
    this.endButton,
    this.buttonMargin=const EdgeInsets.all(4.0),
  }) : super(key: key);
  final Widget? leading;
  final AnimatedIconData icon;
  final List<CollapsedButton> buttons;
  final Widget? divider;
  final double minWidth;
  final double maxWidth;
  final Duration duration;
  final EdgeInsetsGeometry padding;
  final CollapsedButton? endButton;
  final EdgeInsets buttonMargin;
  @override
  _CollapsedDrawerState createState() => _CollapsedDrawerState();
}

class _CollapsedDrawerState extends State<CollapsedDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController a;
  late Animation<double> widthAnimation;
  final List<Widget> buttons = [];
  Locale? l;

  @override
  void initState() {
    a = AnimationController(vsync: this, duration: widget.duration);
    widthAnimation =
        Tween<double>(begin: widget.minWidth, end: widget.maxWidth).animate(a);
    super.initState();
  }

  @override
  void dispose() {
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (l == null) l = Localizations.localeOf(context);
    return SizedBox(
      child: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails e) async {
          if (a.isAnimating) return;
          if (l!.languageCode == 'ar'
              ? !e.primaryDelta!.isNegative
              : e.primaryDelta!.isNegative) {
            await a.reverse();
          } else {
            await a.forward();
          }
          setState(() {});
        },
        child: SafeArea(
          child: AnimatedContainer(
            padding: widget.padding,
            duration: widget.duration,
            width: widthAnimation.value,
            color: Theme.of(context).primaryColorDark,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    if (widget.leading == null ||
                        widthAnimation.value == widget.minWidth)
                      SizedBox()
                    else
                      Expanded(
                        child: widget.leading as Widget,
                      ),
                    Expanded(
                      child: IconButton(
                        padding: l!.languageCode == 'ar'
                            ? EdgeInsets.only(right: 6)
                            : EdgeInsets.zero,
                        alignment: l!.languageCode == 'ar'
                            ? Alignment.bottomRight
                            : Alignment.center,
                        onPressed: () async {
                          if (widthAnimation.value <= widget.minWidth) {
                            await a.forward();
                          } else {
                            await a.reverse();
                          }
                          setState(() {});
                        },
                        icon: AnimatedIcon(
                          progress: a,
                          icon: widget.icon,
                        ),
                      ),
                    ),
                  ],
                ),
                widget.divider ?? SizedBox(),
                for (CollapsedButton value in widget.buttons)
                  collapseButton(value),
                Spacer(),
                widget.endButton == null
                    ? SizedBox()
                    : collapseButton(widget.endButton),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget collapseButton(value) {
    return Container(
      margin: EdgeInsets.all(4),
      child: MaterialButton(
        onPressed: value.onPressed,
        color: Theme.of(context).primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: value.icon),
            value.title.toString() == 'SizedBox'
                ? const SizedBox()
                : widthAnimation.value == widget.minWidth
                    ? const SizedBox()
                    : Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: value.title,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
