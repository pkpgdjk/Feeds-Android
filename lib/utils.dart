import 'package:timeago/timeago.dart' as _timeago;
import 'package:intl/intl.dart';

class Utils {
  String timeago(int timestamp) {
    _timeago.setLocaleMessages('th', _timeago.ThMessages());
    var date1 = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var now = new DateTime.now();
    if (date1.isBefore(now.subtract(Duration(hours: 24)))) {
      DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
      String formatted = formatter.format(date1);
      return formatted;
    }
    return _timeago.format(date1, locale: "en");
  }
}
