import 'package:flutter/material.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const TabBarMaterialWidget({
    @required this.index,
    @required this.onChangedTab,
    Key key,
  }) : super(key: key);

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFF612EF3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            icon: Icons.home_outlined,
            label: 'Tasks',
          ),
          placeholder,
          buildTabItem(
            index: 1,
            icon: Icons.apps_outlined,
            label: 'Habits',
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    @required int index,
    @required IconData icon,
    String label,
  }) {
    final isSelected = index == widget.index;
    final color = isSelected ? Colors.white : Color(0xFFA585FF);

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.white : Color(0xFFA585FF),
      ),
      child: TextButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
        onPressed: () => widget.onChangedTab(index),
      ),
    );
  }
}
