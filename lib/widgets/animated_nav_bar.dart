import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../utils/bottom_navbar_tabs.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIdx;
  final Color unselectedColor, selectedColor;
  final void Function(int) onPressed;
  final EdgeInsets itemPadding;
  final PageController navigationConroller = PageController(initialPage: 0);
  BottomNavBar({
    required Key key,
    this.selectedIdx = 0,
    required this.onPressed,
    required this.unselectedColor,
    required this.selectedColor,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  }) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIdx;

  @override
  void initState() {
    super.initState();
    _selectedIdx = widget.selectedIdx;
  }
  @override
  Widget build(BuildContext context) {
    final navBarCurrentIndex =
        Provider.of<BottomNavigationBarProvider>(context);
    _selectedIdx = navBarCurrentIndex.currentIndex;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(bottomNavBarData.length, (idx) {
        return TweenAnimationBuilder<double>(
            tween: Tween(end: (idx == _selectedIdx) ? 1 : 0),
            curve: Curves.easeInOutSine,
            duration: const Duration(milliseconds: 250),
            builder: (ctx, isSelected, _) {
              return Material(
                color: Color.lerp(
                  widget.selectedColor.withOpacity(0.0),
                  widget.selectedColor.withOpacity(0.1),
                  isSelected,
                ),
                shape: StadiumBorder(),
                child: Padding(
                  padding: widget.itemPadding -
                      EdgeInsets.only(
                          right: widget.itemPadding.right * isSelected),
                  child: InkWell(
                    hoverColor: widget.selectedColor.withOpacity(0.1),
                    focusColor: widget.selectedColor.withOpacity(0.1),
                    splashColor: widget.selectedColor.withOpacity(0.1),
                    highlightColor: widget.selectedColor.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        _selectedIdx = idx;
                        navBarCurrentIndex.getCurrentIndex(index: idx);
                      });
                      widget.onPressed.call(idx);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            color: Color.lerp(widget.unselectedColor,
                                widget.selectedColor, isSelected),
                          ),
                          child: SvgPicture.asset(
                            bottomNavBarData[idx]['svg']!,
                            width: 30,
                            height: 30,
                            color: (_selectedIdx == idx)
                                ? Theme.of(context).colorScheme.secondary
                                : kTextColor,
                          ),
                        ),
                        Align(
                          alignment: Alignment(-0.2, 0.0),
                          widthFactor: isSelected,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.itemPadding.left / 2,
                                right: widget.itemPadding.right),
                            child: Text(
                              bottomNavBarData[idx]['title']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.lerp(
                                    Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.0),
                                    Theme.of(context).colorScheme.secondary,
                                    isSelected),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
