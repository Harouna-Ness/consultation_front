import 'package:dio/dio.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/service/dio_client.dart';

class UserService {
  final apiService = ApiService(DioClient.dio);

  Future<Utilisateur> getCurrentUser() async {
    try {
      Response response = await apiService.getData('/users/me');
      if (response.statusCode == 200) {
        dynamic data = response.data;
        return Utilisateur.fromMap(data);
      } else {
        throw Exception("Erreur lors de la récupération de l'utilisateur courant.");
      } 
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}