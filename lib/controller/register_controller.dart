import 'dart:async';

import 'package:class_scheduler_api/class_scheduler_api.dart';
import 'package:class_scheduler_api/model/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    final _errorMessage = _validateFields(user);

    if(_errorMessage.isNotEmpty) {
      return Response.badRequest(body: _errorMessage);
    }

    user
      ..type = UserType.values[user.userType]
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    return Response.created("", body: await Query(context, values: user).insert());
  }

  Map<String, String> _validateFields(User user) {
    if(user.name == null || user.name.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Name can't be blank",
      };
    }

    if(user.email == null || user.email.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Email can't be blank",
      };
    }

    if(user.phone == null || user.phone.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Phone can't be blank",
      };
    }

    if(user.userType == null) {
      return {
        "error": "fields_validation",
        "message": "User Type can't be blank",
      };
    }

    if(user.username == null || user.username.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Username can't be blank",
      };
    }

    if(user.password == null || user.password.isEmpty) {
      return {
        "error": "fields_validation",
        "message": "Password can't be blank",
      };
    }

    return {};
  }
}