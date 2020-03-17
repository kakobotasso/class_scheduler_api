import 'package:class_scheduler_api/model/klass_type.dart';
import 'package:class_scheduler_api/model/recurrence.dart';
import 'package:class_scheduler_api/model/user.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()
    ..install();

  test("GET /recurrence returns 200", () async {
    final response = await harness.agent.get("/recurrence");

    expectResponse(response, 200);
  });

  test("GET /recurrence returns a list of Recurrence", () async {
    await _generateRecurrence(harness);

    final response = await harness.agent.get("/recurrence");
    
    expectResponse(response, 200, 
      body: allOf([
        hasLength(greaterThan(0)),
      ])
    );
  });

  test("GET /recurrence/id returns 200", () async {
    await _generateRecurrence(harness);

    final response = await harness.agent.get("/recurrence/1");
    
    expectResponse(response, 200);
  });

  test("DELETE /recurrence/id returns 200", () async {
    await _generateRecurrence(harness);

    final response = await harness.agent.delete("/recurrence/1");
    
    expectResponse(response, 200);
  });

  test("DELETE /recurrence/id delete a single Recurrence", () async {
    await _generateRecurrence(harness);

    await harness.agent.delete("/recurrence/1");

    final response = await harness.agent.get("/recurrence");
    
    expectResponse(response, 200, body: allOf([
      hasLength(lessThan(3))
    ]));
  });
}

_generateRecurrence(Harness harness, {bool isStudent= false}) async {
    final User _user = await _generateUser(harness, isStudent: isStudent);
    final KlassType _klassType = await _generateKlassType(harness);

    final query = Query<Recurrence>(harness.application.channel.context)
      ..values.dateBegin = DateTime.now()
      ..values.recurrence = "Mon"
      ..values.hour = DateTime.now().hour.toString()
      ..values.user = _user
      ..values.type = _klassType;

    await query.insert();
  }

  Future<User> _generateUser(Harness harness, {bool isStudent= false}) async {
    final completeBody = {
      "name": "John Doe",
      "email": "john_doe@test.com",
      "phone": "11 11111-1111",
      "userType": isStudent ? UserType.student.index : UserType.teacher.index,
      "username": "johndoe",
      "password": "password"
    };
    
    await harness.agent.post("/register", body: completeBody);
    
    final query = Query<User>(harness.application.channel.context);
    return query.fetchOne();
  }

  Future<KlassType> _generateKlassType(Harness harness) async {
    final ktQuery = Query<KlassType>(harness.application.channel.context)
      ..values.name = "Test";

    await ktQuery.insert();

    final query = Query<KlassType>(harness.application.channel.context);
    return query.fetchOne();
  }