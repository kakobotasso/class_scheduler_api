import 'package:aqueduct/managed_auth.dart';
import 'package:class_scheduler_api/controller/klass_type_controller.dart';
import 'package:class_scheduler_api/controller/register_controller.dart';
import 'package:class_scheduler_api/model/user.dart';
import 'package:class_scheduler_api/model/klass_type.dart';
import 'class_scheduler_api.dart';

class ClassSchedulerApiChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    final config = ClassSchedulerApiConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);

    context = ManagedContext(dataModel, persistentStore);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);

    router
        .route("/register")
        .link(() => RegisterController(context, authServer));

    router.route("/auth/login").link(() => AuthController(authServer));

    router.route("/class_type/[:id]").link(() => KlassTypeController(context));

    return router;
  }
}

class ClassSchedulerApiConfig extends Configuration {
  ClassSchedulerApiConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
  String clientId;
}
