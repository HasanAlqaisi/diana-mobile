import 'package:chips_choice/chips_choice.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter/material.dart';

class TagChips extends StatelessWidget {
  const TagChips({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TagData>>(
        stream: TaskController.to.watchAllTags(),
        initialData: [],
        builder: (context, snapshot) {
          final data = snapshot?.data;
          if (data != null && data.isNotEmpty) {
            return ChipsChoice<String>.multiple(
              // choiceStyle: C2ChoiceStyle(color: Colors.red),
              // value is list of clicked tags (with mark on it)
              value: [],
              // onChanged will generate a list with selected tags, u need to assign it
              // to the value above
              onChanged: (tags) => ['tag two'],
              choiceItems: C2Choice.listFrom<String, String>(
                // All tags
                source: data.map((tag) => tag.name).toList(),
                value: (i, v) => v,
                label: (i, v) => v,
              ),
            );
          } else {
            print('TAGS UI: data is empty ${data?.isEmpty}');
            return Container();
          }
        });
  }
}
