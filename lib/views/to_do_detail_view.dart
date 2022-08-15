import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_todo_app/models/todo_model.dart';
import 'package:my_todo_app/screens/detail_screen.dart';
import 'package:my_todo_app/screens/task_detail_screen.dart';
import 'package:my_todo_app/services/theme_service.dart';
import '../services/file_service.dart';

class ToDoDetailView extends StatefulWidget {
  final List<ToDo> items;
  const ToDoDetailView({Key? key, this.items = const <ToDo>[]}) : super(key: key);

  @override
  State<ToDoDetailView> createState() => _ToDoDetailViewState();
}

class _ToDoDetailViewState extends State<ToDoDetailView> {
  
  List<ToDo> items = [];
  bool isLoading = false;
  
  @override
  initState() {
    super.initState();
    _readToDo();
  }
  
  void _readToDo() {
    setState(() {
      isLoading = true;
    });

    items = widget.items;
    setState((){
      isLoading = false;
    });
  }

  void _moveToDoCompleted(bool? tapped, ToDo toDo) {
    // TODO this note moved to completed
    setState(() {
      toDo.isCompleted = tapped!;
    });
  }

  void _addOrRemoveToDoInImportant(ToDo toDo) {
    // TODO this note's isImportant field changed and changed database
    setState((){
      toDo.isImportant = !toDo.isImportant;
    });
  }

  void _deleteToDo(int index) {
    FileService.deleteToDo(items[index]);
    setState(() {
      items.removeAt(index);
    });
    Navigator.pop(context);
  }

  void _openTaskDetailPage(ToDo toDo) async {
    String? result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TaskDetailScreen(toDo: toDo)));
    if(result != null && result == "refresh" && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => DetailScreen(path: toDo.category,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            ToDo toDo = items[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.2,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showDialog(index);
                      },
                      backgroundColor: ThemeService.colorPink,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_outline,
                    ),
                  ],
                ),
                key:  ValueKey(toDo),
                child: ListTile(
                  onTap: () => _openTaskDetailPage(toDo),
                  contentPadding: const EdgeInsets.only(left: 10),
                  leading: Checkbox(
                    value: toDo.isCompleted,
                    onChanged: (tapped) => _moveToDoCompleted(tapped, toDo),
                  ),
                  title: Text(
                    toDo.taskName,
                    style: ThemeService.textStyleBody(),
                  ),
                  subtitle: Text(
                    toDo.createdDate,
                    style: ThemeService.textStyleCaption(color: ThemeService.colorSubtitle),
                  ),
                  trailing: IconButton(
                    onPressed: () => _addOrRemoveToDoInImportant(toDo),
                    icon: toDo.isImportant ? const Icon(CupertinoIcons.star_fill, color: ThemeService.colorPink) : const Icon(CupertinoIcons.star),
                  ),
                ),
              ),
            );
          },
        ),

        if(isLoading) const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  void _showDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: const Text(
            "Are you sure?",
            style: TextStyle(color: Color(0xff1C1B1F), fontSize: 22),
          ),
          content: const Text(
            "List will be permanently deleted",
            style: TextStyle(
                color: Color(0x611c1b1f),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff5946D2),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, bottom: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                  backgroundColor:
                  MaterialStateProperty.all(const Color(0xffF85977)),
                ),
                onPressed: () => _deleteToDo(index),
                child: const Text('Delete'),
              ),
            )
          ],
        );
      },
    );
  }
}
