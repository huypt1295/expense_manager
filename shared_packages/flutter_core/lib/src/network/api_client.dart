import 'package:dio/dio.dart';
import 'package:flutter_core/src/exception/dio_exception_mapper.dart';

enum RestMethod { get, post, put, patch, delete }

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio});

  Future<T?> request<D extends Object, T extends Object>({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
  }) async {
    try {
      final response = await _requestByMethod(
        method: method,
        path: path.startsWith(dio.options.baseUrl)
            ? path.substring(dio.options.baseUrl.length)
            : path,
        queryParameters: queryParameters,
        body: body,
        options: Options(
          headers: options?.headers,
          contentType: options?.contentType,
          responseType: options?.responseType,
          sendTimeout: options?.sendTimeout,
          receiveTimeout: options?.receiveTimeout,
        ),
      );

      if (response.data == null) {
        return null;
      }

      return response.data;
    } catch (error) {
      throw DioExceptionMapper().map(error);
    }
  }

  Future<Response<dynamic>> _requestByMethod({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
  }) {
    switch (method) {
      case RestMethod.get:
        return dio.get(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.post:
        return dio.post(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.patch:
        return dio.patch(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.put:
        return dio.put(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.delete:
        return dio.delete(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
    }
  }
}
