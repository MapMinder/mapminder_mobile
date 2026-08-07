import 'package:flutter/material.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final void Function(ReminderStatus status) onStatusChange;
  final VoidCallback onDelete;

  const ReminderCard({
    required this.reminder,
    required this.onStatusChange,
    required this.onDelete,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    bool isCompletedReminder = reminder.status == ReminderStatus.completed;

    Color statusColor = switch (reminder.status) {
      ReminderStatus.active => Color(0xFF4ade80),
      ReminderStatus.paused => Color(0xFFfbbf24),
      ReminderStatus.completed => Color(0xFF6b7280),
    };

    Icon statusIcon = switch (reminder.status) {
      ReminderStatus.active => Icon(Icons.circle, color: statusColor),
      ReminderStatus.paused => Icon(Icons.pause, color: statusColor),
      ReminderStatus.completed => Icon(Icons.check_box_rounded, color: statusColor),
    };

    Icon statusChangeIcon = switch (reminder.status) {
      ReminderStatus.active => Icon(Icons.pause),
      ReminderStatus.paused => Icon(Icons.play_arrow),
      ReminderStatus.completed => Icon(Icons.check_box_rounded, color: Colors.transparent)
    };

    ReminderStatus changeStatusTo = switch (reminder.status) {
      ReminderStatus.active => ReminderStatus.paused,
      ReminderStatus.paused => ReminderStatus.active,
      ReminderStatus.completed => ReminderStatus.completed,
    };

    return Card(
      child: Column(
        children: [
          Text(reminder.title),
          Row(
            children: [
              statusIcon,
              Text(
                reminder.status.name,
                style: TextStyle(
                  color: statusColor,
                ),
              ),
            ],
          ),
          Text(reminder.getLocationName()),
          Row(
            children: [
              if (reminder.status == ReminderStatus.completed && reminder.completedAt != null) 
                Text("Completed " + reminder.getCompletedTimeBeforeCreationTimeAgo()) 
              else
                Text(reminder.getTimeBeforeCreationTimeAgo()),
              if (!isCompletedReminder) Row(
                children: [
                  IconButton(
                    onPressed: () => onStatusChange(changeStatusTo), 
                    icon: statusChangeIcon,
                  ),
                  IconButton(
                    onPressed: () => onStatusChange(ReminderStatus.completed), 
                    icon: Icon(Icons.check_box_rounded),
                  ),
                ],
              ),
                  IconButton(
                    onPressed: onDelete, 
                    icon: Icon(Icons.delete),
                  ),
            ],
          ), 
        ],
      ),
    );
  }
}
