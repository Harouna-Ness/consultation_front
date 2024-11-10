import 'package:dio/dio.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/service/dio_client.dart';

class DirectionService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<Direction>> getAllDirections() async {
    try {
      Response response = await apiService.getData('admin/voirDirections');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Direction.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des directions");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<int> getDirectionCount() async {
    try {
      Response response =
          await apiService.getData('admin/voirNombreDirections');
      return response.data;
    } catch (e) {
      throw Exception("Erreur lors de la requête GET direction_count: $e");
    }
  }

  // Créer une nouvelle direction
  Future<void> createDirection(Direction direction) async {
    try {
      Map<String, dynamic> data = direction.toMap();
      await apiService.postData('admin/creerDirection', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  // Mettre à jour une direction
  Future<void> updateDirection(Direction direction) async {
    try {
      Map<String, dynamic> data = direction.toMap();
      await apiService.putData('admin/modifierDirection', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  // Supprimer une direction
  Future<void> deleteDirection(int directionId) async {
    try {
      await apiService.deleteData('admin/supprimeDirection/$directionId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}
