import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/features/reminder/controller/reminder_controller.dart';

class ReminderFormScreen extends StatefulWidget {
  final LatLng latLang;
  final String displayName;

  const ReminderFormScreen({
    required this.latLang,
    required this.displayName,
    super.key,
  });

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final reminderController = ReminderController();

  void createReminder () async {
    if (!_formKey.currentState!.validate()) return;
    final double latitude = widget.latLang.latitude;
    final double longitude = widget.latLang.longitude;
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    try {
      await reminderController.createReminder(title, description, latitude, longitude);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong when creating')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController)  {
        return SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(widget.displayName),
                Text(widget.latLang.latitude.toString()),
                Text(widget.latLang.longitude.toString()),
                SizedBox(height: 10),
                Text("200m radius trigger zone"),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Reminder Title cannot be empty';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Reminder Title"),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed:() {Navigator.pop(context);}, child: Text("cancel")),
                    ElevatedButton(onPressed:createReminder, child: Text("create"))
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
