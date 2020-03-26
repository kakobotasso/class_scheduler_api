import 'package:aqueduct/aqueduct.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/controller/base_controller.dart';
import 'package:class_scheduler_api/model/klass_user.dart';
import 'package:class_scheduler_api/model/user.dart';

class CheckInController extends BaseController {
  CheckInController(this.context);

  ManagedContext context;

  @Operation.post("klass_id", "user_id")
  Future<Response> createCheckIn(@Bind.path("klass_id") int klassID,
      @Bind.path("user_id") int userID) async {
    final query = Query<KlassUser>(context)
      ..values.klass.id = klassID
      ..values.user.id = userID;

    await query.insert();

    return _fetchCheckIns(klassID);
  }

  @Operation.delete("klass_id", "user_id")
  Future<Response> deleteCheckIn(@Bind.path("klass_id") int klassID,
      @Bind.path("user_id") int userID) async {
    final query = Query<KlassUser>(context)
      ..where((ku) => ku.klass.id).equalTo(klassID)
      ..where((ku) => ku.user.id).equalTo(userID);

    await query.delete();

    return _fetchCheckIns(klassID);
  }

  Future<Response> _fetchCheckIns(int klassID) async {
    final queryList = Query<KlassUser>(context)
      ..where((ku) => ku.klass.id).equalTo(klassID)
      ..join(object: (ku) => ku.user);

    final klassUserList = await queryList.fetch();

    return Response.ok(klassUserList);
  }
}
