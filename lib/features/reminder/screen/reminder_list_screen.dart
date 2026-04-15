import 'package:flutter/material.dart';
import 'package:mapminder_mobile/core/loading.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();

}

class _ReminderListScreenState extends State<ReminderListScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      minChildSize: 0.0,
      snap: true,
      snapSizes: [0.0, 0.8],
      builder: (BuildContext context, ScrollController scrollController) {
        return Loading(
          isLoading: false, 
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  tabs: <Widget>[
                    Tab(child: Row(
                        children: [
                          Icon(Icons.all_inbox),
                          Text("All"),
                        ],
                    )),
                    Tab(text: 'Active', icon: Icon(Icons.play_arrow)),
                    Tab(text: 'Paused', icon: Icon(Icons.pause)),
                    Tab(text: 'Completed', icon: Icon(Icons.check_rounded)),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Column(children: [SizedBox(height:130, width: 150, child: Card(child: Text("test data")))]),
                    Center(child: Text("this is the active tab")),
                    Center(child: Text("this is the pause tab")),
                    Center(child: Text("this is the completed tab")),
                  ] 
                )
                )
              ]
            ),
          ),
        );
      }
    );
  }
}
