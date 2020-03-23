import 'package:aqueduct/aqueduct.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/model/klass.dart';
import 'package:class_scheduler_api/model/klass_user.dart';
import 'package:class_scheduler_api/model/recurrence.dart';
import 'package:class_scheduler_api/model/user.dart';

class KlassController extends ResourceController {
  KlassController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllKlasses() async{
    final query = Query<Klass>(context)
      ..join(object: (u) => u.teacher)
      ..join(object: (kt) => kt.type)
      ..join(set: (k) => k.klassUser).join(object: (ku) => ku.user)
      ;
    final list = await query.fetch();

    for(Klass item in list) {
      item.date = item.date.toLocal();
    }

    return Response.ok(list);
  }

  @Operation.get('id')
  Future<Response> getKlassByID(@Bind.path("id") int id) async {
    final query = Query<Klass>(context)
      ..where((k) => k.id).equalTo(id)
      ..join(object: (u) => u.teacher)
      ..join(object: (kt) => kt.type)
      ..join(set: (k) => k.klassUser).join(object: (ku) => ku.user);

    final klass = await query.fetchOne();

    if(klass == null) {
      return Response.notFound();
    }

    klass.date = klass.date.toLocal();

    return Response.ok(klass);
  }

  @Operation.post()
  Future<Response> createKlass(@Bind.body(ignore: ['id']) Klass inputKlass) async {
    final _errorMessage = _validateFields(inputKlass);

    if(_errorMessage.isNotEmpty) {
      return Response.badRequest(body: _errorMessage);
    }

    final query = Query<Klass>(context)
      ..values = inputKlass
      ..values.date = DateTime.parse(inputKlass.dateAndTime).toLocal();

    final insertedKlass = await query.insert();

    for(KlassUser klassUser in inputKlass.klassUser) {
      final queryUser = Query<User>(context)
        ..where((u) => u.id).equalTo(klassUser.user.id);

      final _user = await queryUser.fetchOne();

      final query = Query<KlassUser>(context)
        ..values.klass = insertedKlass
        ..values.user = _user;

      await query.insert();
    }

    insertedKlass.date = insertedKlass.date.toLocal();

    return Response.created("", body: insertedKlass);
  }

  Map<String, String> _validateFields(Klass klass) {
    return {};
  }
}