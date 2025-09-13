import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/data/datasources/auth_local_datasource.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/utils/constant/texts.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<void> connect(String userId);
  void disconnect();
  Future<void> sendMessage(ChatMessageModel message);
  Stream<ChatMessageModel> get incomingMessages;
  Future<List<ChatMessageModel>> getMessageHistory(
    String currentUserId,
    String contactId,
  );
  Future<List<ChatContact>> getChatContacts(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;
  StompClient? _stompClient;
  String? _currentUserId;

  final _incomingMessagesController =
      StreamController<ChatMessageModel>.broadcast();

  @override
  Stream<ChatMessageModel> get incomingMessages =>
      _incomingMessagesController.stream;

  ChatRemoteDataSourceImpl(this.dio, this.authLocalDataSource);

  @override
  Future<void> connect(String userId) async {
    // ... (kode koneksi tidak berubah)
    _currentUserId = userId;
    if (_stompClient?.connected ?? false) return;

    final token = await authLocalDataSource.getToken();
    if (token == null) {
      print('Error: Auth token not found for WebSocket connection.');
      return;
    }

    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://31.97.222.109:8080/chat-websocket',
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    _stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    if (_currentUserId != null) {
      _stompClient?.subscribe(
        destination: '/topic/private.$_currentUserId',
        callback: (frame) {
          if (frame.body != null) {
            try {
              final messageJson = json.decode(frame.body!);
              final message = ChatMessageModel.fromJson(
                messageJson,
                _currentUserId!,
              );
              _incomingMessagesController.add(message);
            } catch (e) {
              print('Error decoding incoming message: $e');
            }
          }
        },
      );
    }
  }

  @override
  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
  }

  @override
  Future<void> sendMessage(ChatMessageModel message) async {
    if (_stompClient?.connected ?? false) {
      _stompClient?.send(
        destination: '/app/chat',
        body: json.encode(message.toJson()),
      );
    } else {
      throw const Failure('Not connected to WebSocket.');
    }
  }

  // --- FUNGSI getChatContacts YANG TELAH DIPERBAIKI ---
  @override
  Future<List<ChatContact>> getChatContacts(String userId) async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/list/$userId');

      // 1. Validasi bahwa respons tidak null dan merupakan sebuah List.
      //    Jika tidak, kembalikan list kosong untuk mencegah error.
      if (response.data == null || response.data is! List) {
        return [];
      }

      // 2. Lakukan casting yang aman.
      final List<dynamic> contactIdsRaw = response.data;
      final List<String> contactIds = List<String>.from(contactIdsRaw);

      return contactIds.map((id) => ChatContact(id: id, name: id)).toList();
    } on DioException catch (e) {
      // Menangkap error jaringan spesifik dari Dio.
      throw Failure.fromDioException(e);
    } catch (e) {
      // 3. Tambahkan blok catch generik untuk menangkap error lain,
      //    seperti TypeError saat casting.
      print('Error parsing contacts: $e');
      throw const Failure('Gagal memproses data kontak dari server.');
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessageHistory(
    String currentUserId,
    String contactId,
  ) async {
    // ... (kode ini sudah benar dari perbaikan sebelumnya, tidak perlu diubah)
    try {
      final response = await dio.get(
        '${TTexts.baseUrl}/chat/$currentUserId/$contactId',
      );
      if (response.data == null ||
          response.data is! Map ||
          !response.data.containsKey('data')) {
        return [];
      }
      final List<dynamic> messagesJson = response.data['data'];
      return messagesJson
          .map((json) => ChatMessageModel.fromJson(json, currentUserId))
          .toList();
    } on DioException catch (e) {
      throw Failure.fromDioException(e);
    } catch (e) {
      throw const Failure('Gagal memproses data riwayat chat.');
    }
  }
}
