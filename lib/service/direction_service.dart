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
}
