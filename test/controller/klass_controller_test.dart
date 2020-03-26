import '../harness/app.dart';
import '../test_helper.dart';

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
    harness.agent = await TestHelper.getLoggedAgent(harness);

    await TestHelper.generateKlassType(harness);
    
    final response = await harness.agent.post("/class", body: _completeBody);

    expectResponse(response, 201);
  });
}