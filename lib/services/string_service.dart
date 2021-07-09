import 'package:cloud_firestore/cloud_firestore.dart';

class StringService {
  String capitalize(String str) {
    return "${str.substring(0, 1).toUpperCase()}${str.substring(1)}";
  }

  String formatLongMessage(String str) {
    if (str.length > 25) {
      return "${str.substring(0, 25)}....";
    } else
      return str;
  }

  String getTimeString(Timestamp timestamp) {
    String timeString;
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    DateTime thisMonth = DateTime(DateTime.now().year, DateTime.now().month);
    DateTime thisYear = DateTime(DateTime.now().year);
    DateTime time = timestamp.toDate();

    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    int hour = (time.hour) % 12;
    if (hour == 0) {
      hour = 12;
    }
    bool am = (time.hour <= 12);
    int minute = time.minute;
    int year = time.year;
    int day = time.day;
    String month = months[time.month - 1];

    if (time.compareTo(today) >= 0) {
      timeString = "$hour:$minute";
    } else if (time.compareTo(thisMonth) >= 0) {
      timeString = "$day\t $hour:$minute";
    } else if (time.compareTo(thisYear) >= 0) {
      timeString = "$day-$month\t $hour:$minute";
    } else
      timeString = "$day-$month-$year\t $hour:$minute";

    if (am) {
      timeString += " AM";
    } else
      timeString += " PM";

    return timeString;
  }
}
