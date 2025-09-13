import 'package:dio/dio.dart';

class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  /// Factory constructor untuk membuat instance Failure dari DioException.
  /// Ini menerjemahkan berbagai jenis error jaringan menjadi pesan yang
  /// mudah dipahami oleh pengguna.
  factory Failure.fromDioException(DioException e) {
    String errorMessage = 'Terjadi kesalahan tidak diketahui.';
    int? statusCode = e.response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Koneksi ke server terputus. Harap periksa internet Anda.';
        break;
      case DioExceptionType.badResponse:
        // Mencoba mengambil pesan error spesifik dari respons server
        if (e.response?.data != null &&
            e.response!.data is Map &&
            e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage =
              'Server memberikan respons yang tidak valid. Kode: $statusCode';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Permintaan ke server dibatalkan.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi Anda.';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = 'Terjadi kesalahan jaringan yang tidak terduga.';
        break;
    }

    return Failure(errorMessage, statusCode: statusCode);
  }

  @override
  String toString() => 'Failure (message: $message, statusCode: $statusCode)';
}
