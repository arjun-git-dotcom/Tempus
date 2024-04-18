import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:tempus/Design/colors.dart';
import 'package:tempus/Design/fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tempus/db/model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Search> {
  late Box<Model> homebox;
  String _searchText = '';

  @override
  void initState() {
    super.initState();

    homebox = Hive.box<Model>('homebox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black(),
      appBar: AppBar(
        actions: [IconButton(onPressed: ()async {
              final String? result = await showSearch(
                context: context,
                delegate: HistorySearchDelegate(homebox)
              );
              if (result != null) {
                setState(() {
                  _searchText = result;
                });
              }
            }, icon:  Icon(Icons.search,color: AppColors.white(),))],
        backgroundColor: AppColors.black(),
        title: Text(
          'Session History',
          
          style: Appfonts.dancingScript(AppColors.white(), 40),
          
          
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: homebox.listenable(),
          builder: (context, Box<Model> homebox, child) {
            return ListView.builder(
              itemCount: homebox.length,
              itemBuilder: (context, index) {
                var box1 = homebox.getAt(index);

                String formattedStartTime =
                    DateFormat.yMd().add_jm().format(box1!.sessionstartTime);
                String formattedEndTime =
                    DateFormat.yMd().add_jm().format(box1.sessionendTime);

                return GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Column(
                            children: [
                              box1.title.isNotEmpty
                                  ? Text('Title:${box1.title}')
                                  : const Text('Title:nil'),
                              Text('startTime : $formattedEndTime'),
                              Text('endTime:$formattedEndTime'),
                              box1.description.isNotEmpty
                                  ? Text('Description:${box1.description}')
                                  : const Text('Description:nil'),
                            ],
                          ),
                        );
                      }),
                  child: Card(
                    color: AppColors.white(),
                    elevation: 8.0,
                    child: ListTile(
                      title: Column(
                        children: [
                          Center(
                            child: Text(
                              box1.title,
                              style:
                                  Appfonts.dancingScript(AppColors.black(), 30),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            'Start Time: $formattedStartTime',
                            style: Appfonts.kelly(20),
                          ),
                          Text(
                            'End Time: $formattedEndTime',
                            style: Appfonts.kelly(20),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Are you sure you want to delete'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                homebox.deleteAt(index);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('delete')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('cancel'))
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

class HistorySearchDelegate extends SearchDelegate<String> {
  late Box<Model> homebox;

  HistorySearchDelegate(this.homebox);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allDocuments = homebox.values.toList().cast<Model>();

    final suggestions = query.isEmpty
        ? allDocuments.map((doc) => doc.title).toList()
        : allDocuments
            .where(
                (doc) => doc.title.toLowerCase().startsWith(query.toLowerCase()))
            .map((doc) => doc.title)
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text( suggestion),
          onTap: () {
            query = suggestion;
            close(context, query);
          },
        );
      },
    );
  }
}

