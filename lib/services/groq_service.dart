import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ai_service.dart';

class GroqService implements AiService {
  GroqService({
    required this.apiKey,
    http.Client? client,
    this.model = 'llama-3.1-8b-instant',
    this.requestTimeout = const Duration(seconds: 30),
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final String apiKey;
  final String model;
  final Duration requestTimeout;
  final http.Client _client;
  final bool _ownsClient;

  @override
  Future<String> generateReply(String userMessage) async {
    if (apiKey.trim().isEmpty) {
      throw const AiServiceException('Groq API key is not configured.');
    }
    final normalizedApiKey = apiKey.trim();
    final normalizedMessage = userMessage.trim();
    if (normalizedApiKey.isEmpty) {
      throw const AiServiceException(
        'Groq is not configured. Add Groq_API_KEY and restart the app.',
      );
    }
    if (normalizedMessage.isEmpty) {
      throw const AiServiceException('Please enter a message first.');
    }
    late final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
            headers: {
              'Authorization': 'Bearer ${apiKey.trim()}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'messages': [
                {
                  'role': 'system',
                  'content': 'You are AIDA, an AI philosophy discussion companion. '
                      'Your purpose is to help users explore, question, and discuss philosophy. '
                      'Focus on philosophy and closely related areas such as ethics, logic, '
                      'metaphysics, epistemology, existentialism, political philosophy, '
                      'philosophy of mind, aesthetics, and the history of philosophical thought. '
                      'Do not act as a general-purpose assistant for unrelated topics. '
                      '\n\n'
                      'Engage with the user as a thoughtful philosophical discussion partner, '
                      'not merely as a teacher giving answers. Explain philosophical ideas '
                      'clearly in plain language while preserving their nuance. When appropriate, '
                      'present multiple philosophical perspectives and explain the reasoning '
                      'behind each position. Do not present one philosophical position as '
                      'objectively correct when the issue is genuinely open to philosophical debate. '
                      '\n\n'
                      'Challenge the user respectfully when their reasoning contains questionable '
                      'assumptions, contradictions, weak arguments, or logical fallacies. '
                      'Ask thought-provoking questions when they can deepen the discussion, '
                      'but answer directly when a direct answer is appropriate. Encourage the '
                      'user to examine their assumptions and develop their own philosophical position. '
                      '\n\n'
                      'Use thought experiments, analogies, examples, and philosophical scenarios '
                      'when they help clarify an idea. When discussing philosophers, accurately '
                      'distinguish between what the philosopher actually argued and your own '
                      'interpretation. Do not invent philosophical arguments, books, ideas, '
                      'or quotations. '
                      '\n\n'
                      'When the user asks for a philosophical quote, provide relevant quotes '
                      'from philosophers or philosophical works when you can do so accurately. '
                      'Include the philosopher’s name and, when known, the work or source. '
                      'Never invent or falsely attribute a quote. If the exact wording is '
                      'uncertain, clearly identify it as a paraphrase rather than presenting '
                      'it as an exact quotation. '
                      '\n\n'
                      'You may discuss famous philosophers, philosophical schools, arguments, '
                      'thought experiments, and historical philosophical debates. When comparing '
                      'philosophers, explain both their similarities and differences fairly. '
                      '\n\n'
                      'Do not begin with a greeting, repeat the user’s question, or merely '
                      'offer to help. Keep the conversation natural, intellectually curious, '
                      'respectful, and open-minded. Avoid unnecessary academic jargon, but '
                      'introduce important philosophical terms when useful and explain them briefly. '
                      'Use short paragraphs and Markdown formatting. Normal responses should '
                      'be under 400 words unless the user asks for a deeper or more detailed analysis.',
                },
                {'role': 'user', 'content': normalizedMessage},
              ],
              'temperature': 0.7,
              'max_completion_tokens': 2048,
            }),
          )
          .timeout(requestTimeout);
    } on http.ClientException {
      throw const AiServiceException(
        'Could not connect to Groq. Check your connection and try again.',
      );
    } on Exception {
      throw const AiServiceException(
        'Could not connect to Groq. Check your connection and try again.',
      );
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices']?[0]?['message']?['content'];
      if (content is String && content.isNotEmpty) {
        return content;
      }
      throw const AiServiceException('Groq returned an empty reply.');
    }

    throw const AiServiceException(
      'Could not connect to Groq. Check your connection and try again.',
    );
  }

  @override
  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
