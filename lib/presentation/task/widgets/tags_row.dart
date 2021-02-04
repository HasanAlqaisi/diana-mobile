import 'package:chips_choice/chips_choice.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:flutter/material.dart';

class TagsRow extends StatelessWidget {
  final TaskWithTags taskWithTags;

  const TagsRow({
    Key key,
    this.taskWithTags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagsList = taskWithTags?.tags?.map((tag) => tag?.name)?.toList();
    return Row(
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
    );
  }
}
