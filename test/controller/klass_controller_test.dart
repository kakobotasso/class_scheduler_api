import 'package:class_scheduler_api/model/klass.dart';
import 'package:class_scheduler_api/model/user.dart';
import 'package:class_scheduler_api/model/klass_type.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()
    ..install();

  final _completeBody = {
    "teacher": {
      "id": 1
    },
    "type": {
      "id": 1
    },
    "dateAndTime": "2020-03-29 17:00:00",
    "klassUser": [
      {
        "user": {
          "id": 1
        }
      }
    ]
  };

  test("POST /class returns 201", () async {
    await _generateUser(harness);
    await _generateKlassType(harness);
    
    final response = await harness.agent.post("/class", body: _completeBody);

    expectResponse(response, 201);
  });
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