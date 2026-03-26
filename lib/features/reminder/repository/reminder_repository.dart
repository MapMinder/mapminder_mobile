import 'package:dio/dio.dart';
import 'package:mapminder_mobile/core/app_logger.dart';
import 'package:mapminder_mobile/core/http_client.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';

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
        "/reminder/",
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
