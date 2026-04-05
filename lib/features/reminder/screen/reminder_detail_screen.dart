import 'package:flutter/material.dart';
import 'package:mapminder_mobile/core/loading.dart';
import 'package:mapminder_mobile/features/reminder/controller/reminder_controller.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';

class ReminderDetailScreen extends StatefulWidget {
  final Reminder reminder;
  final void Function(Reminder) onUpdate;

  const ReminderDetailScreen({
    required this.reminder,
    required this.onUpdate,
    super.key
  });

  @override
  State<ReminderDetailScreen> createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Reminder _currentReminder;
  bool isEditing = false;
  bool loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final reminderController = ReminderController();

  @override
  void initState() {
    super.initState();
    _currentReminder = widget.reminder;
    _titleController.text = widget.reminder.title;
    _descriptionController.text = widget.reminder.description;
  }

  void _updateReminder () async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() {
        loading = true;
      });

      Reminder reminder = await reminderController.updateReminder(_currentReminder.reminderId, _titleController.text, _descriptionController.text);
      if (!mounted) return;
      widget.onUpdate(reminder);
      setState(() {
        _currentReminder = reminder;
        isEditing = false;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred when updating the reminder. Wait for a while and try again.")),
      );
    }
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
      builder: (BuildContext context, ScrollController scrollController){
        return Loading(
          isLoading: loading, 
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isEditing) IconButton(
                        onPressed: () {
                          _updateReminder();
                        }, 
                        icon: Icon(Icons.check)
                    ) else IconButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        }, 
                        icon: Icon(Icons.edit),
                      ),
                    ]
                  ),
                  if (isEditing) TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Reminder Title cannot be empty";
                      }
                      if (value.length > 65) {
                        return "Reminder Title cannot be longer than 65";
                      }
                      return null;
                    },
                    controller: _titleController,
                    decoration: InputDecoration(labelText: "Reminder Title"),
                  ) else Text(_currentReminder.title),
                  if (isEditing) TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Description cannot be empty";
                      }
                      return null;
                    },
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: "description"),
                  ) else Text(_currentReminder.description),
                  Text(_currentReminder.latitude.toString()),
                  Text(_currentReminder.longitude.toString()),
                  Text(_currentReminder.status.name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // currently here only for visulization will change later
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Text("pause"),
                      ),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Text("completed"),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {}, 
                    child: Text("Delete")
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
