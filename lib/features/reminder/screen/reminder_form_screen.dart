import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/features/reminder/controller/reminder_controller.dart';

class ReminderFormScreen extends StatefulWidget {
  final LatLng latLang;

  const ReminderFormScreen({
    required this.latLang,
    super.key,
  });

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
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
    final double latitude = widget.latLang.latitude;
    final double longitude = widget.latLang.longitude;
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    try {
      await reminderController.createReminder(title, description, latitude, longitude);
      if (!mounted) return;
      Navigator.pushNamed(context, '/map');
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
      initialChildSize: 0.5,
      minChildSize: 0.0,
      maxChildSize: 0.8,
      snap: true,
      snapSizes: [0.5, 0.8],
      builder: (BuildContext context, ScrollController scrollController)  {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(height: 50),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 2,
              ),
              ElevatedButton(onPressed:createReminder, child: Text("create"))
            ],
          ),
        );
      }
    );
  }
}
