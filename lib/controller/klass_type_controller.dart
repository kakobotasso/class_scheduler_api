import 'package:aqueduct/aqueduct.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/controller/base_controller.dart';
import 'package:class_scheduler_api/model/klass_type.dart';
import 'package:class_scheduler_api/model/user.dart';

class KlassTypeController extends BaseController {
  KlassTypeController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllKlassType() async {
    final query = Query<KlassType>(context);
    final klassTypeList = await query.fetch();

    return Response.ok(klassTypeList);
  }

  @Operation.get('id')
  Future<Response> getKlassTypeByID(@Bind.path("id") int id) async {
    final query = Query<KlassType>(context)..where((kt) => kt.id).equalTo(id);

    final klassType = await query.fetchOne();

    if (klassType == null) {
      return Response.notFound();
    }

    return Response.ok(klassType);
  }

  @Operation.post()
  Future<Response> insertKlassType(
      @Bind.body(ignore: ['id']) KlassType inputKlassType) async {
    if (await invalidPermission(
        context, request.authorization, UserType.admin)) {
      return Response.unauthorized();
    }

    if (inputKlassType.name == null || inputKlassType.name.isEmpty) {
      return Response.badRequest(body: {
        "error": "fields_validation",
        "message": "Name can't be blank",
      });
    }

    final query = Query<KlassType>(context)..values = inputKlassType;

    final insertedKlassType = await query.insert();

    return Response.created("", body: insertedKlassType);
  }

  @Operation.put('id')
  Future<Response> editKlassType(@Bind.path("id") int id,
      @Bind.body(ignore: ['id']) KlassType inputKlassType) async {
    if (await invalidPermission(
        context, request.authorization, UserType.admin)) {
      return Response.unauthorized();
    }

    if (inputKlassType.name == null || inputKlassType.name.isEmpty) {
      return Response.badRequest(body: {
        "error": "fields_validation",
        "message": "Name can't be blank",
      });
    }

    final query = Query<KlassType>(context)
      ..where((kt) => kt.id).equalTo(id)
      ..values = inputKlassType;

    return Response.ok(await query.updateOne());
  }

  @Operation.delete('id')
  Future<Response> deleteKlassType(@Bind.path("id") int id) async {
    if (await invalidPermission(
        context, request.authorization, UserType.admin)) {
      return Response.unauthorized();
    }

    final query = Query<KlassType>(context)..where((kt) => kt.id).equalTo(id);

    await query.delete();

    final queryList = Query<KlassType>(context);
    final klassTypeList = await queryList.fetch();

    return Response.ok(klassTypeList);
  }
}
