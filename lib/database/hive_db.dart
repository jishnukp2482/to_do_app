import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/models/modeltask.dart';

class HiveDB {
  static const boxname = "modeltaskbox";
  final Box<modeltask> box = Hive.box<modeltask>(boxname);

  // add new tasks

  Future<void> addtask({required modeltask task}) async {
    await box.put(task.id, task);
  }

  //show  task

  Future<modeltask?> gettask({required String id}) async {
    return box.get(id);
  }

  //update task

  Future<void> updatetask({required modeltask task}) async {
    await task.save();
  }

  //delete a task

  Future<void> deletetask({required modeltask task}) async {
    await task.delete();
  }
//delete all tasks
Future<void>deletefulltasks()async{
   Hive.box('modeltaskbox').clear();
      
}

  ValueListenable<Box<modeltask>> listentotask() {
    return box.listenable();
  }
}
