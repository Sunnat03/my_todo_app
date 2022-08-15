import 'package:flutter/material.dart';
import 'package:my_todo_app/services/theme_service.dart';

class DueDateElement extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final bool visible;

  const DueDateElement({Key? key, required this.onTap, required this.title, this.visible = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // #icon
            const Icon(Icons.calendar_today, color: ThemeService.colorBlack,),
            const SizedBox(width: 10,),

            // #text
            Text(title, style: ThemeService.textStyleBody(),),
            Visibility(
              visible: visible,
              child: const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_forward_ios, color: ThemeService.colorBlack, size: 16,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}