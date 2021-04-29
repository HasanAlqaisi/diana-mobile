import 'package:diana/core/constants/enums.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:flutter/material.dart';

class TagsRow extends StatelessWidget {
  final TaskWithTags taskWithTags;
  final TaskType taskType;

  const TagsRow({Key key, this.taskWithTags, this.taskType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagsList = taskWithTags?.tags?.map((tag) => tag?.name)?.toList();
    print('tags' + tagsList.toString());
    return Container(
      color: taskType == TaskType.done ? Color(0xFF1ADACE) : Colors.white,
      child: Wrap(
        spacing: 6.0,
        children: tagsList
            .map((tag) => Chip(
                  label: Text(tag, style: TextStyle(color: Color(0xFF8E8E8E))),
                  labelPadding: EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: Color(0xFFEDEDED),
                ))
            .toList(),
      ),
    );
  }
}
