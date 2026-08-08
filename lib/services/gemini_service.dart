import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_service.dart';

String extractGeminiText(Map<String, dynamic> json) {
  final candidates = json['candidates'];
  if (candidates is! List || candidates.isEmpty) {
    final promptFeedback = json['promptFeedback'];
    final blockReason =
        promptFeedback is Map ? promptFeedback['blockReason'] : null;
    if (blockReason is String && blockReason.isNotEmpty) {
      throw FormatException('Gemini blocked the prompt: $blockReason.');
    }
    throw const FormatException('Gemini returned no candidates.');
  }

  final candidate = candidates.first;
  final content = candidate is Map ? candidate['content'] : null;
  final parts = content is Map ? content['parts'] : null;
  if (parts is! List || parts.isEmpty) {
    throw const FormatException('Gemini returned no text parts.');
  }

  final text = parts
      .whereType<Map>()
      .map((part) => part['text'])
      .whereType<String>()
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join('\n');
  if (text.isEmpty) {
    throw const FormatException('Gemini returned empty text.');
  }

  return text;
}

class GeminiService implements AiService {
  GeminiService({
    required this.apiKey,
    http.Client? client,
    this.model = 'gemini-3.6-flash',
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
    final normalizedApiKey = apiKey.trim();
    final normalizedMessage = userMessage.trim();
    if (normalizedApiKey.isEmpty) {
      throw const AiServiceException(
        'Gemini is not configured. Add GEMINI_API_KEY and restart the app.',
      );
    }
    if (normalizedMessage.isEmpty) {
      throw const AiServiceException('Please enter a message first.');
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/'
      'models/$model:generateContent',
    );

    late final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': normalizedApiKey,
            },
            body: jsonEncode({
              'system_instruction': {
                'parts': [
                  {
                    'text': 'You are AIDA, an AI philosophy discussion companion. '
                        'Your purpose is to help users explore, question, and discuss philosophical ideas. '
                        'Focus only on philosophy and closely related topics such as ethics, logic, metaphysics, epistemology, existentialism, political philosophy, philosophy of mind, aesthetics, and the history of philosophical thought. '
                        'Do not act as a general-purpose assistant or tutor for unrelated subjects. '
                        '\n\n'
                        'Engage with the user as a thoughtful discussion partner rather than simply giving answers. '
                        'Explain philosophical concepts clearly in plain language, but preserve their nuance and complexity. '
                        'When appropriate, present multiple philosophical perspectives and explain the reasoning behind each one. '
                        'Do not treat one philosophical position as objectively correct unless the claim is a matter of established logic or factual scholarship. '
                        '\n\n'
                        'Challenge the user respectfully when their reasoning contains assumptions, contradictions, weak arguments, or logical fallacies. '
                        'Ask thought-provoking questions when they can deepen the discussion, but do not ask unnecessary questions when a direct answer is appropriate. '
                        'Build on the user’s ideas and encourage them to examine their own assumptions. '
                        'Use thought experiments, analogies, examples, and philosophical scenarios when they make an idea easier to understand. '
                        '\n\n'
                        'When discussing philosophers or philosophical traditions, accurately distinguish between what a philosopher actually argued and your own interpretation. '
                        'Do not invent quotations, arguments, books, or philosophical positions. '
                        'If you are uncertain about a historical or scholarly claim, say so rather than presenting it as fact. '
                        '\n\n'
                        'Do not begin with a greeting, repeat the user’s question, or merely offer to help. '
                        'Keep the conversation natural, intellectually curious, respectful, and open-minded. '
                        'Avoid unnecessary academic jargon, but introduce important philosophical terms when useful and explain them briefly. '
                        'Use short paragraphs and practical examples. '
                        'Normal responses should be under 400 words unless the user explicitly asks for a deeper or more detailed analysis.'
                        'When the user asks for a philosophical quote, provide relevant quotes from philosophers or philosophical works when you can do so accurately. Include the philosopher’s name and, when known, the work or source. Never invent or falsely attribute a quote. If you are uncertain about the exact wording, clearly say that it is a paraphrase rather than presenting it as an exact quotation.',
                  },
                ],
              },
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': normalizedMessage},
                  ],
                },
              ],
              'generationConfig': {
                'maxOutputTokens': 2048,
                'thinkingConfig': {'thinkingLevel': 'minimal'},
              },
            }),
          )
          .timeout(requestTimeout);
    } on TimeoutException {
      throw const AiServiceException(
        'Gemini took too long to respond. Please try again.',
      );
    } on http.ClientException {
      throw const AiServiceException(
        'Could not connect to Gemini. Check your connection and try again.',
      );
    }

    final json = _decodeResponse(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = json['error'];
      final apiMessage = error is Map ? error['message'] : null;
      throw AiServiceException(
        apiMessage is String && apiMessage.trim().isNotEmpty
            ? apiMessage.trim()
            : 'Gemini returned an error. Please try again.',
        statusCode: response.statusCode,
      );
    }

    try {
      return extractGeminiText(json);
    } on FormatException {
      throw const AiServiceException(
        'Gemini returned an unexpected response. Please try again.',
      );
    }
  }

  Map<String, dynamic> _decodeResponse(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }

  @override
  void close() {
    if (_ownsClient) _client.close();
  }
}
