import 'package:aqueduct/aqueduct.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/model/user.dart';

class UserController extends ResourceController {
  UserController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllUsers() async {
    final query = Query<User>(context);
    final usersList = await query.fetch();

    return Response.ok(usersList);
  }

  @Operation.get('id')
  Future<Response> getUserID(@Bind.path("id") int id) async {
    final query = Query<User>(context)
      ..where((u) => u.id).equalTo(id);

    final user = await query.fetchOne();

    if(user == null) {
      return Response.notFound();
    }

    return Response.ok(user);
  }

  @Operation.delete('id')
  Future<Response> deleteUser(@Bind.path("id") int id) async {
    final query = Query<User>(context)
      ..where((u) => u.id).equalTo(id);

    await query.delete();

    final queryList = Query<User>(context);
    final userList = await queryList.fetch();

    return Response.ok(userList);    
  }
}