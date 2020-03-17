import 'package:class_scheduler_api/class_scheduler_api.dart';

import './klass_type.dart';
import './user.dart';


class Recurrence extends ManagedObject<_Recurrence> implements _Recurrence {}

class _Recurrence {
  @primaryKey
  int id;

  DateTime dateBegin;

  @Column(nullable: true)
  DateTime dateEnd;

  String recurrence;
  String hour;

  @Relate(#availableClassesUser)
  User user;

  @Relate(#availableClassesKlassType)
  KlassType type;
}