import 'package:class_scheduler_api/model/klass_type.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()
    ..install();

  final completeBody = {
    "name": "Class Type Test"
  };

  test("POST /class_type returns 201", () async {
    final response = await harness.agent.post("/class_type", body: completeBody);

    expectResponse(response, 201);
  });

  test("POST /class_type should validate name", () async {
    completeBody["name"] = "";
    final response = await harness.agent.post("/class_type", body: completeBody);

    expectResponse(response, 400);
  });

  test("GET /class_type returns 200", () async {
    final response = await harness.agent.get("/class_type");

    expectResponse(response, 200);
  });

  test("GET /class_type returns a list of Class Types", () async {
    final query = Query<KlassType>(harness.application.channel.context)
      ..values.name = "Test";

    await query.insert();

    final response = await harness.agent.get("/class_type");
    
    expectResponse(response, 200, 
      body: allOf([
        hasLength(greaterThan(0)),
        everyElement({
          "id": greaterThan(0),
          "name": isString,
        })
      ])
    );
  });

  test("GET /class_type/id returns 200", () async {
    final query = Query<KlassType>(harness.application.channel.context)
      ..values.name = "Test";

    await query.insert();

    final response = await harness.agent.get("/class_type/1");
    
    expectResponse(response, 200);
  });

  test("GET /class_type/id returns a single Class Type", () async {
    const _name = "Test";

    final query = Query<KlassType>(harness.application.channel.context)
      ..values.name = _name;

    await query.insert();

    final response = await harness.agent.get("/class_type/1");
    
    expectResponse(response, 200, body: {
      "id": greaterThan(0),
      "name": _name,
    });
  });

  test("PUT /class_type/id returns 200", () async {
    await harness.agent.post("/class_type", body: completeBody);
    
    final response = await harness.agent.put("/class_type/1", body: {"name" : "Put tested"});
    
    expectResponse(response, 200);
  });

  test("DELETE /class_type/id returns 200", () async {
    final query = Query<KlassType>(harness.application.channel.context)
      ..values.name = "Test Delete";

    await query.insert();

    final response = await harness.agent.delete("/class_type/1");
    
    expectResponse(response, 200);
  });

  test("DELETE /class_type/id delete a single Class Type", () async {
    final types = ["Test Delete", "Test", "delete"];

    for (var type in types) {
      final query = Query<KlassType>(harness.application.channel.context)
        ..values.name = type;

      await query.insert();
    }

    await harness.agent.delete("/class_type/1");

    final response = await harness.agent.get("/class_type");
    
    expectResponse(response, 200, body: allOf([
      hasLength(lessThan(3))
    ]));
  });
}