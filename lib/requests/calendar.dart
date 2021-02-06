class CalendarRequests {
  final Map<String, int> date;

  CalendarRequests({this.date});

  Future<Map<String, int>> fetchData() {
    return Future.delayed(Duration(milliseconds: 300), () => this.date);
  }

}