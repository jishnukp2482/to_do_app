import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/modeltask.dart';
import 'package:to_do_app/utilits/colors.dart';
import 'package:to_do_app/views/tasks/taskview.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({Key? key, required this.task}) : super(key: key);
  final modeltask task;
  @override
  //ignore : library private types in public api
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController taskControllerForTitle = TextEditingController();
  TextEditingController taskControllerForSubtitle = TextEditingController();
  @override
  void initState() {
    super.initState();
    taskControllerForTitle.text = widget.task.title;
    taskControllerForSubtitle.text = widget.task.subtitle;
  }

  @override
  void dispose() {
    taskControllerForTitle.dispose();
    taskControllerForSubtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => TaskView(
              taskControllerForTitle: taskControllerForTitle,
              taskControllerForSubtitle: taskControllerForSubtitle,
              task: widget.task,
            ),
          ),
        );
      },
      //main card
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: widget.task.iscompleted
                ? Color.fromARGB(154, 94, 120, 206)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: Offset(0, 4),
                  blurRadius: 10),
            ]),
        child: ListTile(
          //check icon
          leading: GestureDetector(
            onTap: () {
              widget.task.iscompleted = !widget.task.iscompleted;
              widget.task.save();
            },
            child: AnimatedContainer(duration: Duration(milliseconds: 600),
            decoration: BoxDecoration(
              color: widget.task.iscompleted?mycolor.primarycolor:Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey,width: .8),
            ),
            child: Icon(Icons.check,color: Colors.white,),
            ),
          ),
          //title of task
          title: Padding(padding: EdgeInsets.only(bottom: 5,top: 3),
          child: Text(
            taskControllerForTitle.text,
            style: TextStyle(color: widget.task.iscompleted?mycolor.primarycolor:Colors.black,
            fontWeight: FontWeight.w500,
            decoration:widget.task.iscompleted?TextDecoration.lineThrough:null ),
          ),
          ),
          //description of task
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskControllerForSubtitle.text,
                style: TextStyle(
                  color: widget.task.iscompleted?mycolor.primarycolor:Color.fromARGB(255, 164, 164, 164),
                  fontWeight: FontWeight.w300,
                  decoration: widget.task.iscompleted?TextDecoration.lineThrough:null,
                ),
              ),
              //date & time of task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(padding: EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('hh:mm a').format(widget.task.createdattime),
                    style: TextStyle(fontSize: 14,color: widget.task.iscompleted?Colors.white:Colors.grey),),
                    Text(
                      DateFormat.yMMMEd().format(widget.task.createdatdate),
                      style: TextStyle(fontSize: 12,color: widget.task.iscompleted?Colors.white:Colors.grey),
                    )
                  ],
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
