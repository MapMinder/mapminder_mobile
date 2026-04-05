import 'package:dio/dio.dart';
import 'package:mapminder_mobile/core/app_logger.dart';
import 'package:mapminder_mobile/core/http_client.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';
import 'package:mapminder_mobile/features/reminder/dto/update_reminder_dto.dart';

class ReminderRepository {
  static ReminderRepository? _instance;

  factory ReminderRepository() {
    _instance ??= ReminderRepository._();
    return _instance!;
  }

  ReminderRepository._();
  final client = HttpClient();

  Future<Reminder> createReminder(CreateReminderDto request) async {
    try {
      Response response = await client.dio.post(
        "/reminder",
        data: request.toJson(),
      );
      return Reminder.fromJson(response.data["result"]);
    } on DioException catch (e, s) {
      AppLogger().error("error occurred while calling the backend. ${e.error}", e, s);
      throw Exception("error occurred while calling the backend. ${e.error}");
    } catch (e, s) {
      AppLogger().error("Unexpected error occurred", e, s);
      throw Exception("Unexpected error occurred");
    }
  }

  Future<List<Reminder>> getAllReminders() async {
    try {
      Response response = await client.dio.get(
        "/reminder"
      );
      final remindersJson = response.data["result"] as List;
      List<Reminder> remindersList = remindersJson.map((json) => Reminder.fromJson(json)).toList();
      return remindersList;
    } on DioException catch (e, s) {
      AppLogger().error("error occurred while calling the backend. ${e.error}", e, s);
      throw Exception("error occurred while calling the backend. ${e.error}");
    } catch (e, s) {
      AppLogger().error("Unexpected error occurred", e, s);
      throw Exception("Unexpected error occurred");
    }
  }

  Future<Reminder> updateReminder(String reminderId, UpdateReminderDto request) async {
    try {
      Response response = await client.dio.patch(
        "/reminder/$reminderId",
        data: request.toJson(),
      );
      return Reminder.fromJson(response.data["result"]);
    } on DioException catch (e, s) {
      AppLogger().error("error occurred while calling the backend. ${e.error}", e, s);
      throw Exception("error occurred while calling the backend. ${e.error}");
    } catch (e, s) {
      AppLogger().error("Unexpected error occurred", e, s);
      throw Exception("Unexpected error occurred");
    }
  }
}
