extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());

  Duration get ms => Duration(milliseconds: round());

  Duration get milliseconds => ms;

  Duration get seconds => Duration(seconds: round());

  Duration get minutes => Duration(minutes: round());

  Duration get hours => Duration(hours: round());

  Duration get days => Duration(days: round());
}
