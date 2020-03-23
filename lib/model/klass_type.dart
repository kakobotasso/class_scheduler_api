import 'package:class_scheduler_api/class_scheduler_api.dart';

import 'package:class_scheduler_api/model/recurrence.dart';
import 'package:class_scheduler_api/model/klass.dart';

class KlassType extends ManagedObject<_KlassType> implements _KlassType {}

class _KlassType {
  @primaryKey
  int id;

  @Column()
  String name;

  ManagedSet<Recurrence> availableClassesKlassType;
  ManagedSet<Klass> klassesWithType;
}