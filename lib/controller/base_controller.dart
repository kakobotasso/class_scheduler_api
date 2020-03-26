import 'dart:async';

import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/model/user.dart';

abstract class BaseController extends ResourceController {
  Future<bool> invalidPermission(ManagedContext context, Authorization authorization, UserType userType) async {
    return !(await hasPermission(context, authorization, userType));
  }

  Future<bool> hasPermission(ManagedContext context, Authorization authorization, UserType userType) async {
    final query = Query<User>(context)
      ..where((u) => u.id).equalTo(authorization.ownerID);

    final user = await query.fetchOne();

    if(user.type == userType) {
      return true;
    }

    return false;
  }
}