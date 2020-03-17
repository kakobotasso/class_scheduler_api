import 'package:aqueduct/managed_auth.dart';
import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/model/recurrence.dart';

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

  ManagedSet<Recurrence> availableClassesUser;
}

enum UserType {
  teacher,
  student
}

extension UserTypeExtension on UserType {
  String get type {
    switch(this) {
      case UserType.student:
        return "student";
      case UserType.teacher:
        return "teacher";
      default:
        return null;
    }
  }
}