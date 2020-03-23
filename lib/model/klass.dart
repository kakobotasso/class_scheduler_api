import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/model/klass_type.dart';
import 'package:class_scheduler_api/model/klass_user.dart';
import 'package:class_scheduler_api/model/user.dart';

class Klass extends ManagedObject<_Klass> implements _Klass {
  @Serialize(input: true, output: false)
  String dateAndTime;
}

class _Klass {
  @primaryKey
  int id;

  DateTime date;

  @Relate(#klasses)
  User teacher;

  @Relate(#klassesWithType)
  KlassType type;

  ManagedSet<KlassUser> klassUser;
}