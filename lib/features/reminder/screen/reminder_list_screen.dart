import 'package:flutter/material.dart';
import 'package:mapminder_mobile/core/loading.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/notifier/reminder_list_notifier.dart';
import 'package:mapminder_mobile/features/reminder/widget/reminder_card.dart';
import 'package:provider/provider.dart';

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
    _tabController.addListener((){
      final notifier = Provider.of<ReminderListNotifier>(context, listen: false);
      switch (_tabController.index) {
        case 0:
          notifier.getAllReminders();
        case 1:
          notifier.getRemindersWithStatus(ReminderStatus.active);
        case 2:
          notifier.getRemindersWithStatus(ReminderStatus.paused);
        case 3:
          notifier.getRemindersWithStatus(ReminderStatus.completed);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReminderListNotifier>(context, listen: false).getAllReminders();
    });
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
                  height: MediaQuery.of(context).size.height * 0.8 - 100,
                  child: Consumer<ReminderListNotifier>(
                    builder: (context, reminderListnotifier, child) {
                      return Loading(
                        isLoading: reminderListnotifier.getReminders() == null, 
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            ListView(
                              children: (reminderListnotifier.getReminders() ?? []).map((reminder) => ReminderCard(
                                  reminder: reminder, 
                                  onStatusChange: (status) => reminderListnotifier.updateReminderStatus(reminder.reminderId, status, false), 
                                  onDelete: () => reminderListnotifier.deleteReminder(reminder.reminderId),
                              )
                              ).toList(),
                            ),
                            ListView(
                              children: (reminderListnotifier.getReminders() ?? []).map((reminder) => ReminderCard(
                                  reminder: reminder, 
                                  onStatusChange: (status) => reminderListnotifier.updateReminderStatus(reminder.reminderId, status, true), 
                                  onDelete: () => reminderListnotifier.deleteReminder(reminder.reminderId),
                              )
                              ).toList(),
                            ),
                            ListView(
                              children: (reminderListnotifier.getReminders() ?? []).map((reminder) => ReminderCard(
                                  reminder: reminder, 
                                  onStatusChange: (status) => reminderListnotifier.updateReminderStatus(reminder.reminderId, status, true), 
                                  onDelete: () => reminderListnotifier.deleteReminder(reminder.reminderId),
                              )
                              ).toList(),
                            ),
                            ListView(
                              children: (reminderListnotifier.getReminders() ?? []).map((reminder) => ReminderCard(
                                  reminder: reminder, 
                                  onStatusChange: (status) => reminderListnotifier.updateReminderStatus(reminder.reminderId, status, true), 
                                  onDelete: () => reminderListnotifier.deleteReminder(reminder.reminderId),
                              )
                              ).toList(),
                            ),
                          ] 
                        ),
                      );
                    }
                  )
                )
              ]
            ),
        );
      }
    );
  }
}
