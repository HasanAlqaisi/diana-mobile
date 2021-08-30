import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabBarMaterialWidget extends StatelessWidget {
  final int passedIndex;
  final ValueChanged<int> onChangedTab;

  const TabBarMaterialWidget({
    required this.passedIndex,
    required this.onChangedTab,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 3.5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFF612EF3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            icon: SvgPicture.asset(
              'assets/tasks_icon.svg',
              color: passedIndex == 0 ? Colors.white : Color(0xFFA585FF),
            ),
            label: 'Tasks',
          ),
          placeholder,
          buildTabItem(
            index: 1,
            icon: SvgPicture.asset(
              'assets/habits_icon.svg',
              color: passedIndex == 1 ? Colors.white : Color(0xFFA585FF),
            ),
            label: 'Habits',
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required SvgPicture icon,
    required String label,
  }) {
    final isSelected = index == passedIndex;
    final color = isSelected ? Colors.white : Color(0xFFA585FF);

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.white : Color(0xFFA585FF),
      ),
      child: TextButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
        onPressed: () => onChangedTab(index),
      ),
    );
  }
}
