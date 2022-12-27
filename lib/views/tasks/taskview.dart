//ignore for file: prefer typing uninitialized variables
//ignore: must be immutable

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/modeltask.dart';
import 'package:to_do_app/utilits/colors.dart';
import 'package:to_do_app/utilits/constanst.dart';
import 'package:to_do_app/utilits/mystrings.dart';
import 'package:to_do_app/views/home/homeview.dart';
import 'package:to_do_app/database/hive_db.dart';

class TaskView extends StatefulWidget {
  TaskView({
    Key? key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  }) : super(key: key);
  TextEditingController? taskControllerForTitle;
  TextEditingController? taskControllerForSubtitle;
  final modeltask? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;
  //show selected time as string format
  String showtime(DateTime? time) {
    if (widget.task?.createdattime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdattime)
          .toString();
    }
  }

//show selected time as datetime formt
  DateTime showtimeasdatetime(DateTime? time) {
    if (widget.task?.createdattime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdattime;
    }
  }

//show selected date as string format
  String showdate(DateTime? date) {
    if (widget.task?.createdatdate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdatdate).toString();
    }
  }

//show selected date as datetime format
  DateTime showdateasdatetime(DateTime? date) {
    if (widget.task?.createdatdate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdatdate;
    }
  }

  //if any task already exist return true otherwise false
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

//if any task already exist app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title;
        widget.taskControllerForSubtitle?.text = subtitle;
        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        nothingenteronupdatetaskmode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = modeltask.create(
            title: title,
            subtitle: subtitle,
            createdatdate: date,
            createdattime: time);
        MainWidget.of(context).dataStore.addtask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyfieldswarning(context);
      }
    }
  }

  //delete selected task
  dynamic deletetask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //new/update task text
                  _buildTopText(textTheme),

                  //middle two textfields,time and date selection box
                  _buildMiddleTextFieldsAndTimeAndDateSelection(
                      context, textTheme),
                  //all bottom buttons
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //all bottom buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExistBool()
              ? Container()
              //delete task button
              : Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.red, ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: 150,
                    height: 55,
                    onPressed: () {
                      deletetask();
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          mystring.deletetask,
                          style: TextStyle(color:Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
          //add or update task button
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              isTaskAlreadyExistUpdateTask();
            },
            color: mycolor.primarycolor,
            child: Text(
              isTaskAlreadyExistBool()
                  ? mystring.addtaskString
                  : mystring.updatetaskString,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //middle two textfields and time and date selection box
  SizedBox _buildMiddleTextFieldsAndTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 520,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title of textfield
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              mystring.titleoftitletextfield,
              style: textTheme.headline4,
            ),
          ),
          //title textfield
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 6,
                cursorHeight: 60,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          ///note textfield
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForSubtitle,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.bookmark_border,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: mystring.addnote,
                ),
                onFieldSubmitted: (value) {
                  subtitle = value;
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),
          //time picker
          GestureDetector(
            onTap: () {
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  showSecondsColumn: false,
                  onChanged: (_) {}, onConfirm: (selectedtime) {
                setState(() {
                  if (widget.task?.createdattime == null) {
                    time = selectedtime;
                  } else {
                    widget.task!.createdattime = selectedtime;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showtimeasdatetime(time));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      mystring.timeString,
                      style: textTheme.headline5,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showtime(time),
                        style: textTheme.subtitle2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          //date picker

          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2050, 12, 25),
                  onChanged: (_) {}, onConfirm: (selectedDate) {
                setState(() {
                  if (widget.task?.createdatdate == null) {
                    date = selectedDate;
                  } else {
                    widget.task?.createdatdate = selectedDate;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showdateasdatetime(date));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      mystring.dateString,
                      style: textTheme.headline5,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showdate(date),
                        style: textTheme.subtitle2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //new update task text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Divider(
              color: mycolor.primarycolor,
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExistBool()
                    ? mystring.addnewtask
                    : mystring.updatecurrenttask,
                style: textTheme.headline6,
                children: [
                  TextSpan(
                    text: mystring.taskString,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ]),
          ),
          SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
              color: mycolor.primarycolor,
            ),
          ),
        ],
      ),
    );
  }
}

//my appbar
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  MyAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  
  Size get preferredSize => Size.fromHeight(100);
}
