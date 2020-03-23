import 'package:class_scheduler_api/class_scheduler_api.dart';

import './klass.dart';
import './user.dart';

class KlassUser extends ManagedObject<_KlassUser> implements _KlassUser {}

class _KlassUser {
  @primaryKey
  int id;

  @Relate(#klassUser)
  Klass klass;

  @Relate(#klassUser)
  User user;
}