import 'package:class_scheduler_api/class_scheduler_api.dart';

class KlassType extends ManagedObject<_KlassType> implements _KlassType {}

class _KlassType {
  @primaryKey
  int id;

  @Column()
  String name;
}