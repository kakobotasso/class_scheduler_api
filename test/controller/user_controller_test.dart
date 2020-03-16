import 'package:class_scheduler_api/model/user.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()
    ..install();

  final completeBody = {
    "name": "John Doe",
    "email": "john_doe@test.com",
    "phone": "11 11111-1111",
    "userType": UserType.student.index,
    "username": "johndoe",
    "password": "password"
  };

  test("GET /class_type returns 200", () async {
    final response = await harness.agent.get("/user");

    expectResponse(response, 200);
  });

  test("GET /class_type returns a list of User", () async {
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.get("/user");
    
    expectResponse(response, 200, 
      body: allOf([
        hasLength(greaterThan(0)),
      ])
    );
  });

  test("GET /user/id returns 200", () async {
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.get("/user/1");
    
    expectResponse(response, 200);
  });

  test("GET /user/id returns a single User", () async {
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.get("/user/1");
    
    expectResponse(response, 200, body: {
      "id": greaterThan(0),
      "name": completeBody['name'],
      "email": completeBody['email'],
      "phone": completeBody['phone'],
      "type": UserType.student.type,
      "username": completeBody['username'],
    });
  });

  test("DELETE /user/id returns 200", () async {
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.delete("/user/1");
    
    expectResponse(response, 200);
  });

  test("DELETE /user/id delete a single User", () async {
    await harness.agent.post("/register", body: completeBody);

    await harness.agent.delete("/user/1");

    final response = await harness.agent.get("/user");
    
    expectResponse(response, 200, body: allOf([
      hasLength(equals(0))
    ]));
  });
}