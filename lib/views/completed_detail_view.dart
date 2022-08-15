import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/models/todo_model.dart';
import 'package:my_todo_app/screens/detail_screen.dart';
import 'package:my_todo_app/screens/task_detail_screen.dart';
import 'package:my_todo_app/services/file_service.dart';
import 'package:my_todo_app/services/theme_service.dart';

class CompletedDetailView extends StatefulWidget {
  final List<ToDo> items;
  const CompletedDetailView({Key? key, this.items = const <ToDo>[]}) : super(key: key);

  @override
  State<CompletedDetailView> createState() => _CompletedDetailViewState();
}

class _CompletedDetailViewState extends State<CompletedDetailView> {
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
              child: Dismissible(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  color: ThemeService.colorPink,
                  child: const Icon(Icons.delete_outline, color: ThemeService.colorBackgroundLight,),
                ),
                onDismissed: (DismissDirection direction) => _deleteToDo(index),
                key: ValueKey<int>(toDo.hashCode),
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
                    icon: toDo.isImportant
                        ? const Icon(CupertinoIcons.star_fill, color
                        : ThemeService.colorPink) : const Icon(CupertinoIcons.star),
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
}
