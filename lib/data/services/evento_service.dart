
import 'package:dio/dio.dart';
import '../network/requester.dart';

class EventoService {
  final Dio _dio = Requester.dio;

  Future<Response<dynamic>> buscarEventos() async {
    return await _dio.get('/eventos');
  }
}
