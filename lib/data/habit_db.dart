import 'package:hive/hive.dart';
import 'package:untitled/datetime/date_time.dart';



const String START_DATE = "START_DATE";
const String CURRENT_HABIT_LIST = "CURRENT_HABIT_LIST";

class HabitDatabase {


  final myBox = Hive.box("habit_db");

  Map<DateTime, int> heatMapDataSet = {};
  List todaysHabitList = [];

  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Drink water", false]
    ];

    myBox.put(START_DATE, todaysDateFormatted());
  }

  void loadData() {

    if (myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = myBox.get(CURRENT_HABIT_LIST);

      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = myBox.get(todaysDateFormatted());
    }

  }

  void updateDatabase() {

    myBox.put(todaysDateFormatted(), todaysHabitList);

    myBox.put(CURRENT_HABIT_LIST, todaysHabitList);

      calculateHabitPercentage();

      loadHeadMap();
  }

  void calculateHabitPercentage() {
    int completedCount = 0;
    for(int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        completedCount++;
      }
    }

    String percent = todaysHabitList.isEmpty
    ? '0.0'
    : (completedCount / todaysHabitList.length).toStringAsFixed(1);

    myBox.put("PERCENT_${todaysDateFormatted()}", percent);
  }

  void loadHeadMap() {
    DateTime startDate = createDateTimeObject(myBox.get(START_DATE));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i))
      );

      double strength = double.parse(
        myBox.get("PERCENT_$yyyymmdd") ?? '0.0'
      );

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);

    }
  }

}