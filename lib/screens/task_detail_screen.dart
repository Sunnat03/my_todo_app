import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/models/todo_model.dart';
import 'package:my_todo_app/services/file_service.dart';
import 'package:my_todo_app/services/util_service.dart';
import 'package:my_todo_app/views/due_date_element_view.dart';
import '../services/theme_service.dart';
class TaskDetailScreen extends StatefulWidget {
  static const id = "new_screen";
  final ToDo? toDo;
  final DetailState state;

  const TaskDetailScreen({Key? key, this.toDo, this.state = DetailState.read}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {

  bool isLoading = false;
  String title = "Task list";
  String taskTime = "Created on Mon, 28 March";
  String oldName = "For Update";
  late ToDo _toDo;
  late TextEditingController titleController;
  late TextEditingController contentController;
  DetailState detailState = DetailState.read;

  @override
  initState() {
    super.initState();
    _getTodo();
  }

  void _getTodo() {
    _toDo = widget.toDo!;
    title = _toDo.category.toString().substring(_toDo.category.toString().lastIndexOf("/") + 1);
    titleController = TextEditingController(text: _toDo.taskName);
    contentController = TextEditingController(text: _toDo.taskContent);
    detailState = widget.state;
    setState((){});
    _changeCompleted(_toDo.isCompleted);
  }

  void _addOrRemoveToDoInImportant(ToDo toDo) {
    // TODO this note's isImportant field changed and changed database
    setState((){
      toDo.isImportant = !toDo.isImportant;
    });
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectDueDate() {
    if(detailState != DetailState.read) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: ThemeService.colorBackgroundLight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text("Due", style: ThemeService.textStyleHeader(),),
                    ),
                    const Divider(color: ThemeService.colorBlack,),
                    DueDateElement(onTap: () {
                      DateTime now = DateTime.now();
                      _toDo.dueDate = DateTime(now.year, now.month, now.day, now.hour).toString();
                      setState(() {});
                      Navigator.of(context).pop();
                    }, title: "Today",),
                    DueDateElement(onTap: () {
                      DateTime now = DateTime.now();
                      _toDo.dueDate = DateTime(now.year, now.month, now.day + 1, now.hour).toString();
                      setState(() {});
                      Navigator.of(context).pop();
                    }, title: "Tomorrow",),
                    DueDateElement(onTap: () {
                      DateTime now = DateTime.now();
                      _toDo.dueDate = DateTime(now.year, now.month, now.day + 7, now.hour).toString();
                      setState(() {});
                      Navigator.of(context).pop();
                    }, title: "Next Week",),
                    DueDateElement(onTap: () => _pickADate(), title: "Pick a Date", visible: true,),
                  ],
                ),
              ),
            );
          }
      );
    }
  }

  void _pickADate() {
    Navigator.pop(context);

    showDatePicker(
      context: context,
      initialDate: _toDo.dueDate != null ? DateTime.parse(_toDo.dueDate!) : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ). then((value) => _getPickADate(value));
  }

  void _getPickADate(DateTime? value) {
    if(value != null) {
      _toDo.dueDate = value.toString();
    }
    setState(() {});
  }

  void _changeCompleted(bool? value) {
    _toDo.isCompleted = value!;
    if(value) {
      taskTime = 'Completed today!';
    } else {
      taskTime = 'Created on ${_weekName(DateTime.now().weekday)}, ${DateTime.now().day} ${_monthName(DateTime.now().month)}';
    }
    setState(() {});
  }

  String _monthName(int month) {
    switch(month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'Avgust';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      default: return 'December';
    }
  }

  String _weekName(int week) {
    switch(week) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      default: return 'Sunday';
    }
  }

  Future<void> _saveToDo() async {
    isLoading = true;
    setState(() {});
    String taskName = titleController.text.trim().toString();
    String taskContent = contentController.text.trim().toString();
    _toDo.taskName = taskName;
    _toDo.taskContent = taskContent;

    if(widget.state == DetailState.create) {
      bool isExist = await FileService.existToDo(_toDo);
      if(isExist) {
        if(mounted) Utils.fireSnackBar("The name “${_toDo.taskName}” is already taken. Please choose a different name.", context);
        isLoading = false;
        setState(() {});
        return;
      }
      await FileService.createToDo(_toDo);
    } else if(oldName == _toDo.taskName) {
      await FileService.createToDo(_toDo);
    } else {
      bool isExist = await FileService.existToDo(_toDo);
      if(isExist) {
        if(mounted) Utils.fireSnackBar("The name “${_toDo.taskName}” is already taken. Please choose a different name.", context);
        isLoading = false;
        setState(() {});
        return;
      }
      await FileService.updateTodo(oldName, _toDo);
    }

    isLoading = false;
    setState(() {});
    if(mounted) Navigator.pop(context, "refresh");
  }

  Future<void> _deleteToDo() async {
    isLoading = true;
    setState(() {});

    await FileService.deleteToDo(_toDo);

    isLoading = false;
    setState(() {});
    if(mounted) Navigator.pop(context, "refresh");
  }

  void _clearDueDate() {
    _toDo.dueDate = null;
    setState(() {});
  }

  void _readToEdit() {
    detailState = DetailState.edit;
    oldName = _toDo.taskName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: ThemeService.colorBackgroundLight,
        title: Text(
          title,
          style: ThemeService.textStyleHeader(),
        ),
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeService.colorBlack,
          ),
        ),
        actions: [
          if(detailState == DetailState.read)
            IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.edit,
                color: ThemeService.colorBlack,
              ),
              onPressed: _readToEdit,
            )
          else
            IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.done,
                color: ThemeService.colorBlack,
              ),
              onPressed: _saveToDo,
            )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 34),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [

                                  // #checkbox
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 18,
                                    ),
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      activeColor: ThemeService.colorMain,
                                      onChanged: _changeCompleted,
                                      value: _toDo.isCompleted,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 19,
                                  ),

                                  // #title
                                  SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    child: TextField(
                                      readOnly: detailState == DetailState.read,
                                      controller: titleController,
                                      style: ThemeService.textStyleHeader(),
                                      decoration: const InputDecoration(
                                        hintText: "Text Name",
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // #important
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 20),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _addOrRemoveToDoInImportant(_toDo),
                                  icon: _toDo.isImportant ? const Icon(CupertinoIcons.star_fill, color: ThemeService.colorPink) : const Icon(CupertinoIcons.star),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0x1f1c1b1f),
                          ),
                        ),

                        // #date
                        GestureDetector(
                          onTap: _selectDueDate,
                          child: _toDo.dueDate == null
                              ? Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 18,
                                  ),
                                  width: 24,
                                  height: 24,
                                  child:Icon(
                                    Icons.edit_calendar,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Add Due Date',
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                              :Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                          left: 18,
                                        ),
                                        width: 24,
                                        height: 24,
                                        child: const Icon(
                                          Icons.edit_calendar,
                                          color: Color(0xff5946D2),
                                        )
                                    ),
                                    const SizedBox(
                                      width: 19,
                                    ),
                                    Text(
                                      _toDo.dueDate.toString().substring(0, 10),
                                      style: const TextStyle(
                                          color: Color(0xff5946D2),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 33),
                                  child: IconButton(
                                    icon: Icon(Icons.backspace_outlined, color: Colors.grey.shade700, size: 20,),
                                    onPressed: _clearDueDate,
                                    splashRadius: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0x1f1c1b1f),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 248,
                          child: TextField(
                            readOnly: detailState == DetailState.read,
                            controller: contentController,
                            maxLines: 13,
                            decoration: const InputDecoration(
                                hintText: "Add Note",
                                helperStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0x991c1b1f)),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(
                            thickness: 2,
                            color: Color(0x1f1c1b1f),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 170,),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(left: 20, right: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        taskTime,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0x991c1b1f),
                        ),
                      ),
                      Visibility(
                        visible: detailState != DetailState.create,
                        child: IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.delete_outline, color: Color(0x991c1b1f)),
                          onPressed: () => _deleteToDo(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

enum DetailState {read, edit, create}
