import 'package:class_scheduler_api/model/user.dart';

import '../harness/app.dart';

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

  test("POST /register returns 201", () async {
    final response = await harness.agent.post("/register", body: completeBody);

    expectResponse(response, 201);
  });

  test("POST /register should validate name", () async {
    final _body = completeBody["name"] = "";
    final response = await harness.agent.post("/register", body: _body);

    expectResponse(response, 400);
  });

  test("POST /register should validate email", () async {
    final _body = completeBody["email"] = "";
    final response = await harness.agent.post("/register", body: _body);

    expectResponse(response, 400);
  });

  test("POST /register should validate phone", () async {
    final _body = completeBody["phone"] = "";
    final response = await harness.agent.post("/register", body: _body);

    expectResponse(response, 400);
  });

  test("POST /register should validate userType", () async {
    final _body = completeBody["userType"] = "";
    final response = await harness.agent.post("/register", body: _body);

    expectResponse(response, 400);
  });

  test("POST /register should validate username", () async {
    final _body = completeBody["username"] = "";
    final response = await harness.agent.post("/register", body: _body);

    expectResponse(response, 400);
  });

  test("POST /register should validate password", () async {
    final _body = completeBody["password"] = "";
    final response = await harness.agent.post("/register", body: _body);

    expectResponse(response, 400);
  });
}
