import 'dart:convert';

import 'package:sjekk_application/core/constants/app_constants.dart';
import 'package:sjekk_application/core/utils/build_headers.dart';
import 'package:sjekk_application/data/entities/auth_credentials.dart';
import 'package:sjekk_application/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<User?> loginUser(AuthCredentials authCredentials) async {
    try {
      final uri = Uri.parse('$baseUrl/login');
      final response = await http.post(uri,
          headers: BuildHeaders().supportJson().finish(),
          body: jsonEncode({
            'user_identifier': authCredentials.identifier,
            'password': authCredentials.password
          }));

      print(response.statusCode);

      if(response.statusCode == 200) {
        final json = jsonDecode(response.body);
        User user = User.fromJson(json);

        return user;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    } catch (authError) {
      
      rethrow;
    }
  }
}
