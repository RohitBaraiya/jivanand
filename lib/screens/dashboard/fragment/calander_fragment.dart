import 'package:intl/intl.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/case/case_list_screen.dart';
import 'package:jivanand/screens/dashboard/component/greetings_component.dart';
import 'package:jivanand/screens/dashboard/component/slider_and_location_component.dart';
import 'package:jivanand/screens/patients/add_patients_screen.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/screens/patients/patients_list_screen.dart';
import 'package:jivanand/screens/vaid/add_vaid_screen.dart';
import 'package:jivanand/screens/vaid/vaid_list_screen.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/box_widget.dart';
import '../../../component/loader_widget.dart';

class CalanderFragment extends StatefulWidget {
  const CalanderFragment({super.key});

  @override
  _CalanderFragmentState createState() => _CalanderFragmentState();
}

class _CalanderFragmentState extends State<CalanderFragment> with WidgetsBindingObserver {
 // Future<DashboardResponse>? future;
  

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    // log('Background');
    if (state == AppLifecycleState.resumed) {
      LiveStream().emit(LIVESTREAM_UPDATE_DASHBOARD);
      /*log('Background');
      if(appStore.isLogOut==true){
        log('userLogOut');
        userLogOut();
      }*/
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    setStatusColor();
    getDayMsg();
    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      init();
      setState(() {});
    });
  }

  void init() async {
    getDashboardData();
  }


  Future<void> getDashboardData() async {

  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: cardColor, shape: BoxShape.rectangle),
                  width: context.width(),
                  child: _titleBar(context, greeting),
                ),
                Column(
                  children: [
                    _buildHeader(),
                    _buildWeeks(),
                    PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentMonth = DateTime(_currentMonth.year, index + 1, 1);

                        });
                      },
                      itemCount: 12 * 10, // Show 10 years, adjust this count as needed
                      itemBuilder: (context, pageIndex) {
                        DateTime month = DateTime(_currentMonth.year, (pageIndex % 12) + 1, 1);
                        return buildCalendar(month,events);
                      },
                    ).expand(),
                  ],
                ).expand()
              ],
            ),
            Observer(builder: (context) => const LoaderWidget().visible(appStore.isLoading)),
          ],
        ),

      ),
    );
  }


  List<Event> events = [
    Event(
      title: "day",
      description: "",
      date: DateTime(2024, 12, 5), // Event on 5th December
    ),
    Event(
      title: "day_night",
      description: "",
      date: DateTime(2024, 12, 8), // Event on 5th December
    ),
    Event(
      title: "night",
      description: "",
      date: DateTime(2024, 12, 15), // Event on 15th December
    ),
    Event(
      title: "day",
      description: "",
      date: DateTime(2024, 12, 20), // Event on 20th December
    ),
  ];

  PageController _pageController =
  PageController(initialPage: DateTime.now().month - 1);

  DateTime _currentMonth = DateTime.now();
  bool selectedcurrentyear = false;

  Widget _buildHeader() {
    // Checks if the current month is the last month of the year (December)
    bool isLastMonthOfYear = _currentMonth.month == 12;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Moves to the previous page if the current page index is greater than 0
              if (_pageController.page! > 0) {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          // Displays the name of the current month
          Text(
            '${DateFormat('MMMM').format(_currentMonth)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            // Dropdown for selecting a year
            value: _currentMonth.year,
            onChanged: (int? year) {
              if (year != null) {
                setState(() {
                  // Sets the current month to January of the selected year
                  _currentMonth = DateTime(year, 1, 1);

                  // Calculates the month index based on the selected year and sets the page
                  int yearDiff = DateTime.now().year - year;
                  int monthIndex = 12 * yearDiff + _currentMonth.month - 1;
                  _pageController.jumpToPage(monthIndex);
                });
              }
            },
            items: [
              // Generates DropdownMenuItems for a range of years from current year to 10 years ahead
              for (int year = DateTime.now().year;
              year <= DateTime.now().year + 10;
              year++)
                DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Moves to the next page if it's not the last month of the year
              if (!isLastMonthOfYear) {
                setState(() {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeks() {
    return SizedBox(
      height: 30,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: 30,
        ),
        itemCount: dayList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.grey), // Consistent border width
            ),
            alignment: Alignment.center,
            child: Text(
              dayList[index].toString(),
              style: TextStyle(color: Colors.grey),
            ),
          );
        },

      ),
    );
  }
  List<String> dayList=['Mon','Tus','Wed','Thu','Fri','Sat','Sun'];


  Widget buildCalendar(DateTime month, List<Event> events) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
    firstDayOfMonth.subtract(Duration(days: 1));
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    // Function to get events for a specific day
    List<Event> getEventsForDay(DateTime date) {
      return events.where((event) {
        return event.date.year == date.year &&
            event.date.month == date.month &&
            event.date.day == date.day;
      }).toList();
    }

    // Function to get the event icon(s) based on the event type
    Widget getEventIcon(List<Event> eventsForDay) {
      bool hasDay = false;
      bool hasNight = false;

      // Check for day and night events
      for (var event in eventsForDay) {
        if (event.title == "day") {
          hasDay = true;
        } else if (event.title == "night") {
          hasNight = true;
        } else if (event.title == "day_night") {
          // If the event is "day_night", show both icons
          hasDay = true;
          hasNight = true;
        }
      }

      // If both day and night events exist, show both icons in a row
      if (hasDay && hasNight) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.wb_sunny, color: Colors.yellow, size: 16),
            SizedBox(width: 4), // Space between the two icons
            Icon(Icons.nightlight_round, color: Colors.blue, size: 16),
          ],
        );
      }

      // If only day event, show the day icon
      if (hasDay) {
        return Icon(Icons.wb_sunny, color: Colors.yellow, size: 20);
      }

      // If only night event, show the night icon
      if (hasNight) {
        return Icon(Icons.nightlight_round, color: Colors.blue, size: 20);
      }

      return SizedBox.shrink(); // No event, return an empty widget
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: 70,
      ),
      itemCount: daysInMonth + weekdayOfFirstDay - 1,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          // Displaying dates from the previous month in grey
          int previousMonthDay =
              daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.grey), // Consistent border width
            ),
            alignment: Alignment.center,
            child: Text(
              previousMonthDay.toString(),
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          // Displaying the current month's days
          DateTime date = DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
          String text = date.day.toString();

          // Get events for the current date
          List<Event> eventsForDay = getEventsForDay(date);

          return InkWell(
            onTap: () {
              // Handle tap on a date cell
              // You can show events in a dialog, navigate to a detailed page, etc.
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0, color: Colors.grey), // Consistent border width
              ),
              child: Stack(
                children: [
                  // Date number
                  Center(
                    child: Text(
                      '$text',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Icons in the top-right corner
                  Positioned(
                    right: 4,
                    top: 4,
                    child: getEventIcon(eventsForDay), // Event icon
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  List<String> bannerList = [
    Assets.bannerB1,
    Assets.bannerB2,
    Assets.bannerB3,
    Assets.bannerB4,
    Assets.bannerB5,
   // Assets.bannerB6,
  ];

  Widget _titleBar(BuildContext context,String greeting){
    return GreetingsComponent(msg: greeting,);
  }


  String greeting = "";
  Future<void> getDayMsg() async {
    DateTime now = DateTime.now();
    int hours=now.hour;
    if(hours>=1 && hours<=6){
      greeting = "Mornin' Sunshine!";
    }else if(hours>=6 && hours<=12){
      greeting = "Good Morning";
    } else if(hours>=12 && hours<=16){
      greeting = "Good Afternoon";
    } else if(hours>=16 && hours<=21){
      greeting = "Good Evening";
    } else if(hours>=21 && hours<=24){
      greeting = "Go to Bed!";
    }
  }


}
class Event {
  final String title;
  final String description;
  final DateTime date;

  Event({
    required this.title,
    required this.description,
    required this.date,
  });
}
