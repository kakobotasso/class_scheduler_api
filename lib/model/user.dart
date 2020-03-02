import 'package:aqueduct/managed_auth.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;

  @Serialize(input: true, output: false)
  int userType;
}

class _User extends ResourceOwnerTableDefinition {
  @Column()
  String name;

  @Column()
  String email;

  @Column()
  String phone;

  @Column()
  UserType type;
}

enum UserType {
  teacher,
  student
}