import 'package:class_scheduler_api/model/klass_type.dart';

import 'harness/app.dart';

class TestHelper {
  static Future<KlassType> generateKlassType(Harness harness) async {
    final ktQuery = Query<KlassType>(harness.application.channel.context)
      ..values.name = "Test";

    await ktQuery.insert();

    final query = Query<KlassType>(harness.application.channel.context);
    return query.fetchOne();
  }

  static Future<Agent> getLoggedAgent(Harness harness) async {
    return await harness.registerUser();
  }
}
