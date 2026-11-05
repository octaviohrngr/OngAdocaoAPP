
import 'package:dio/dio.dart';
import '../network/requester.dart';

class AnimalService {
  final Dio _dio = Requester.dio;

  Future<Response<dynamic>> buscarAnimais() async {
    return await _dio.get('/animais');
  }
}
