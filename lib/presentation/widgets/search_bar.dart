import 'package:andrew_wommack/data/teaching_model.dart';
import 'package:andrew_wommack/data/teaching_data.dart';
import 'package:andrew_wommack/presentation/screens/feed_details.dart';
import 'package:flutter/material.dart';

class SearchBar extends SearchDelegate<String>{

  final List<TeachingModel> allList = TeachingCategory.allList;
  List<TeachingModel> _filteredList = [];


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.close), onPressed: () {
      query = '';
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: () {
      close(context, '');
    },);
  }

  @override
  Widget buildResults(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if(_filteredList.isNotEmpty){
      return ListView.builder(
          itemCount: _filteredList.length>15?15:_filteredList.length,
          itemBuilder: (context,index){
            final item = _filteredList[index];
            return ListTile(
              dense: true,
              title: RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(color: isDark?Colors.white:Colors.black),
                    children: highlightOccurrences(item.tTitle, query,isDark)
                ),
              ),
              onTap: (){
                close(context, '');
                Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(item)));
                // Navigator.push(context, PageRouteBuilder(
                //     transitionDuration: const Duration(milliseconds: 700),
                //     transitionsBuilder: (context,a1,a2,child){
                //       return FadeTransition(
                //         opacity: a1,
                //         child: child,
                //       );
                //     },
                //     pageBuilder: (context,  a1, a2) {
                //       return FeedDetails(item);
                //     }));
              },

            );
          });
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("No Results"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filteredList = allList.where((element) => element.tTitle.toLowerCase().contains(query.toLowerCase())).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if(_filteredList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No results"),
      );
    }
    return ListView.separated(
      itemCount: _filteredList.length>15?15:_filteredList.length,
        itemBuilder: (context,index){
        final item = _filteredList[index];
      return ListTile(
        dense: true,
        trailing: const Icon(Icons.chevron_right),
        title: RichText(
          text: TextSpan(
              text: '',
              style: TextStyle(color: isDark?Colors.white:Colors.black),
              children: highlightOccurrences(item.tTitle, query,isDark)
              ),
        ),
        onTap: (){
          close(context, '');
          Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedDetails(item)));
          // Navigator.push(context, PageRouteBuilder(
          //     transitionDuration: const Duration(milliseconds: 700),
          //     transitionsBuilder: (context,a1,a2,child){
          //       return FadeTransition(
          //         opacity: a1,
          //         child: child,
          //       );
          //     },
          //     pageBuilder: (context,  a1, a2) {
          //       return FeedDetails(item);
          //     }));
        },

      );
    }, separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 0.5,height: 0);
    },);
  }


  List<InlineSpan> highlightOccurrences(String source, String query, bool isDark) {
    if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [ TextSpan(text: source) ];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<InlineSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: isDark?Colors.white:Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}