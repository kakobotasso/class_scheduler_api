import 'package:class_scheduler_api/model/user.dart';

import '../harness/app.dart';
import '../test_helper.dart';

void main() {
  final harness = Harness()..install();

  final completeBody = {
    "name": "John Doe 123",
    "email": "john_doe123@test.com",
    "phone": "11 11111-2222",
    "userType": UserType.student.index,
    "username": "johndoe123",
    "password": "password123"
  };

  test("GET /user returns 200", () async {
    harness.agent = await TestHelper.getLoggedAgent(harness);
    final response = await harness.agent.get("/user");

    expectResponse(response, 200);
  });

  test("GET /user returns a list of User", () async {
    harness.agent = await TestHelper.getLoggedAgent(harness);
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.get("/user");

    expectResponse(response, 200,
        body: allOf([
          hasLength(greaterThan(0)),
        ]));
  });

  test("GET /user/id returns 200", () async {
    harness.agent = await TestHelper.getLoggedAgent(harness);
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.get("/user/2");

    expectResponse(response, 200);
  });

  test("GET /user/id returns a single User", () async {
    harness.agent = await TestHelper.getLoggedAgent(harness);
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.get("/user/2");

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
    harness.agent = await TestHelper.getLoggedAgent(harness);
    await harness.agent.post("/register", body: completeBody);

    final response = await harness.agent.delete("/user/2");

    expectResponse(response, 200);
  });

  test("DELETE /user/id delete a single User", () async {
    harness.agent = await TestHelper.getLoggedAgent(harness);
    await harness.agent.post("/register", body: completeBody);

    await harness.agent.delete("/user/2");

    final response = await harness.agent.get("/user");

    expectResponse(response, 200, body: allOf([hasLength(equals(1))]));
  });
}
