import 'package:aqueduct/aqueduct.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/controller/base_controller.dart';
import 'package:class_scheduler_api/model/recurrence.dart';
import 'package:class_scheduler_api/model/user.dart';

class RecurrenceController extends BaseController {
  RecurrenceController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllRecurrences() async {
    final query = Query<Recurrence>(context)
      ..join(object: (u) => u.user)
      ..join(object: (kt) => kt.type);
    final list = await query.fetch();

    return Response.ok(list);
  }

  @Operation.get('id')
  Future<Response> getRecurrenceByID(@Bind.path("id") int id) async {
    final query = Query<Recurrence>(context)
      ..where((r) => r.id).equalTo(id)
      ..join(object: (u) => u.user)
      ..join(object: (kt) => kt.type);

    final recurrence = await query.fetchOne();

    if (recurrence == null) {
      return Response.notFound();
    }

    return Response.ok(recurrence);
  }

  @Operation.post()
  Future<Response> createRecurrence(
      @Bind.body(ignore: ['id']) Recurrence inputRecurrence) async {
    if (await invalidPermission(
        context, request.authorization, UserType.admin)) {
      return Response.unauthorized();
    }

    final _errorMessage = _validateFields(inputRecurrence);

    if (_errorMessage.isNotEmpty) {
      return Response.badRequest(body: _errorMessage);
    }

    final query = Query<Recurrence>(context)..values = inputRecurrence;

    final insertedRecurrence = await query.insert();

    return Response.created("", body: insertedRecurrence);
  }

  @Operation.delete('id')
  Future<Response> deleteRecurrence(@Bind.path("id") int id) async {
    if (await invalidPermission(
        context, request.authorization, UserType.admin)) {
      return Response.unauthorized();
    }

    final query = Query<Recurrence>(context)..where((r) => r.id).equalTo(id);

    await query.delete();

    final queryList = Query<Recurrence>(context)
      ..join(object: (u) => u.user)
      ..join(object: (kt) => kt.type);
    final recurrenceList = await queryList.fetch();

    return Response.ok(recurrenceList);
  }

  Map<String, String> _validateFields(Recurrence recurrence) {
    if (recurrence.dateBegin == null) {
      return {
        "error": "fields_validation",
        "message": "Date Begin can't be blank",
      };
    }

    if (recurrence.dateBegin.isBefore(DateTime.now())) {
      return {
        "error": "fields_validation",
        "message": "Date Begin can't be earlier than today",
      };
    }

    if (recurrence.dateEnd != null) {
      if (recurrence.dateEnd.isBefore(DateTime.now())) {
        return {
          "error": "fields_validation",
          "message": "Date End can't be earlier than today",
        };
      }
    }

    if (recurrence.recurrence == null || recurrence.recurrence.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Recurrence can't be blank",
      };
    }

    if (recurrence.hour == null || recurrence.hour.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Hour can't be blank",
      };
    }

    if (recurrence.user == null) {
      return {
        "error": "fields_validation",
        "message": "User can't be blank",
      };
    }

    if (recurrence.type == null) {
      return {
        "error": "fields_validation",
        "message": "Type can't be blank",
      };
    }

    return {};
  }
}
