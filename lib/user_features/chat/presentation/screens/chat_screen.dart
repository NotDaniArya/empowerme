import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';

import '../../../../pendamping_features/chat/presentation/providers/nonpasien_chat_provider.dart';
import '../../../../utils/constant/colors.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String contactId;
  final String contactName;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    ref
        .read(chatMessagesProvider(widget.contactId).notifier)
        .sendMessage(_messageController.text.trim());
    _messageController.clear();
    // Scroll ke bawah setelah mengirim pesan untuk UX yang lebih baik
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper untuk membandingkan apakah dua tanggal berada di hari yang sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper untuk memformat header tanggal
  String _formatDateForSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (_isSameDay(date, today)) {
      return 'Hari Ini';
    } else if (_isSameDay(date, yesterday)) {
      return 'Kemarin';
    } else {
      return DateFormat('EEEE, d MMMM y', 'id_ID').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesState = ref.watch(chatMessagesProvider(widget.contactId));

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(widget.contactName),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('Mulai percakapan!'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Membuat pesan baru muncul dari bawah
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final showDateSeparator =
                        index == messages.length - 1 ||
                        !_isSameDay(
                          message.timestamp,
                          messages[messages.length - 2 - index].timestamp,
                        );

                    return Column(
                      children: [
                        if (showDateSeparator)
                          _DateSeparator(
                            text: _formatDateForSeparator(message.timestamp),
                          ),
                        _ChatMessageBubble(message: message),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: TColors.primaryColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET GELEMBUNG PESAN YANG TELAH DIPERBAIKI ---
class _ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.type == MessageType.sent;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        elevation: 1,
        color: isSentByMe
            ? const Color(0xFFE7FFDB) // Warna gelembung "Terkirim" ala WA
            : Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12).copyWith(
            bottomLeft: isSentByMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: Column(
            // PERBAIKAN: Sejajarkan konten di dalam bubble
            crossAxisAlignment: isSentByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message.text, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PEMISAH TANGGAL (TIDAK BERUBAH) ---
class _DateSeparator extends StatelessWidget {
  final String text;
  const _DateSeparator({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE1F3FB), // Warna latar belakang tanggal
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
