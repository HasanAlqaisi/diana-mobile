import 'package:chips_choice/chips_choice.dart';
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
    return Container(
      color: taskType == TaskType.done ? Color(0xFF1ADACE) : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
              child: ChipsChoice<String>.single(
                value: null,
                onChanged: (value) => null,
                choiceItems: C2Choice.listFrom<String, String>(
                  // All tags
                  source: tagsList,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
              ),
              visible: tagsList.isNotEmpty),
        ],
      ),
    );
  }
}
