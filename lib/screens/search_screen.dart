import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/services/theme_service.dart';
import 'package:my_todo_app/views/search_view.dart';
class SearchScreen extends SearchDelegateCustom {

  SearchScreen() : super(
    searchFieldLabel: "Search",
  );

  List<String> searchResults = [
    'Islam',
    'Yoqub',
    'Muhammadjon',
    'Bobur',
    'Jamshid aka',
    'Abdulazim',
  ];

  @override
  Widget? buildActions(BuildContext context) {
    return IconButton(
      color: ThemeService.colorBlack,
      onPressed: () {
        query = '';
      },
      icon: const Icon(CupertinoIcons.xmark,),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: ThemeService.colorBlack,
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    appBarTheme(context);
    List<String> suggestions = searchResults.where(
          (element) {
        final result = element.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      },
    ).toList();

    return Center(
      child: suggestions.isNotEmpty ?  Text(
        query,
        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
      ) : Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Task not found", style: TextStyle(fontSize: 22, fontFamily: "Roboto", color: ThemeService.colorSubtitle),),
          SizedBox(height: 10,),
          Text("We searched high and low but couldn't find\nwhat you're looking for", style: TextStyle(fontSize: 14, fontFamily: "Roboto", color: ThemeService.colorSubtitle, fontWeight: FontWeight.w500, wordSpacing: 2.5), textAlign: TextAlign.center,)
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where(
          (element) {
        final result = element.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      },
    ).toList();
    return ListView.builder(

        itemCount: suggestions.length,
        padding: EdgeInsets.symmetric(vertical: 5),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
            child: ListTile(
              contentPadding: EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
              leading: Checkbox(
                onChanged: (value) {},
                activeColor: ThemeService.colorMain,
                value: true,
              ),
              tileColor: ThemeService.colorBackgroundLight,
              title: Text(suggestion),
              subtitle: Text(suggestion),
              onTap: () {
                query = suggestion;
              },
              trailing: Icon(Icons.star_outline),
            ),
          );
        });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
            toolbarHeight: 100,
            elevation: 0.0,
            backgroundColor: ThemeService.colorBackgroundLight
        )
    );
  }
}