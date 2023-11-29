import 'package:sjekk_application/data/entities/auth_credentials.dart';

import '../../data/models/user_model.dart';

abstract class IAuthRepository{
  Future<User?> loginUser(AuthCredentials authCredentials);
}