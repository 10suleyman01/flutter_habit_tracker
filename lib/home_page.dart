import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled/components/month_summary.dart';
import 'package:untitled/data/habit_db.dart';

import 'components/habit_tile.dart';
import 'components/my_fab.dart';
import 'components/new_habit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // data
  HabitDatabase db = HabitDatabase();

  @override
  void initState() {

    if (db.myBox.get(CURRENT_HABIT_LIST) == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateDatabase();

    super.initState();
  }

  bool habitCompleted = false;

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    showDialog(context: context, builder: (context) {
      return EnterNewHabitBox(
        initialData: "Enter the habit name",
        controller: _newHabitNameController,
        onSave: saveNewHabit,
        onCancel: cancelNewHabit,
      );
    });
  }

  void openHabitSettings(int index) {
    showDialog(context: context, builder: (context) {
      return EnterNewHabitBox(
        initialData: db.todaysHabitList[index][0],
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelNewHabit
      );
    });
  }

  void saveNewHabit() {
    setState(() {
      var text = _newHabitNameController.text;
      if(text.isNotEmpty) {
        db.todaysHabitList.add([text, false]);
      }
    });
    cancelNewHabit();
    db.updateDatabase();
  }

  void cancelNewHabit() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    cancelNewHabit();
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          MonthlySummary(datasets: db.heatMapDataSet, startDate: db.myBox.get(START_DATE)),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                editTapped: (context ) => openHabitSettings(index),
                deleteTapped: (context ) => deleteHabit(index),
              );
            },
          )
        ],
      )
      );
    }
}
