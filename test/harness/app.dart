import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:class_scheduler_api/class_scheduler_api.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

class Harness extends TestHarness<ClassSchedulerApiChannel> with TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;
  
  @override
  Future onSetUp() async {
    await resetData();
  }
}
