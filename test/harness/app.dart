import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:class_scheduler_api/class_scheduler_api.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';
import 'package:class_scheduler_api/model/user.dart';

class Harness extends TestHarness<ClassSchedulerApiChannel>
    with TestHarnessAuthMixin<ClassSchedulerApiChannel>, TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  AuthServer get authServer => channel.authServer;

  Agent publicAgent;

  final _username = "johndoe";
  final _password = "password";

  @override
  Future onSetUp() async {
    await resetData();
    publicAgent = await addClient("com.aqueduct.public");
  }

  Future<Agent> registerUser({Agent withClient}) async {
    withClient ??= publicAgent;

    final req = withClient.request("/register")
      ..body = {
        "name": "John Doe",
        "email": "john_doe@test.com",
        "phone": "11 11111-1111",
        "userType": UserType.admin.index,
        "username": _username,
        "password": _password
      };
    await req.post();

    return loginUser(withClient, _username, _password);
  }
}
