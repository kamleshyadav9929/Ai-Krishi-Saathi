import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import '../../core/constants/app_constants.dart';

class VoiceAssistantService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isSpeechInitialized = false;
  bool _isTtsInitialized = false;

  Future<bool> initSpeech() async {
    if (_isSpeechInitialized) return true;
    try {
      _isSpeechInitialized = await _speechToText.initialize();
      return _isSpeechInitialized;
    } catch (_) {
      return false;
    }
  }

  Future<void> initTts({bool isHindi = true}) async {
    if (_isTtsInitialized) return;
    try {
      await _flutterTts.setLanguage(isHindi ? 'hi-IN' : 'en-IN');
      await _flutterTts.setSpeechRate(0.48); // Slightly slower for clear rural comprehension
      await _flutterTts.setPitch(1.0);
      _isTtsInitialized = true;
    } catch (_) {}
  }

  Future<void> startListening({
    required Function(String recognizedWords) onResult,
    bool isHindi = true,
  }) async {
    final available = await initSpeech();
    if (!available) return;

    await _speechToText.listen(
      listenOptions: SpeechListenOptions(
        localeId: isHindi ? 'hi_IN' : 'en_IN',
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 3),
      ),
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  bool get isListening => _speechToText.isListening;

  Future<void> speak(String text, {bool isHindi = true}) async {
    await initTts(isHindi: isHindi);
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  /// Evaluates farmer speech for voice-controlled app navigation intents
  VoiceIntentResult parseVoiceIntent(String spokenText) {
    final lower = spokenText.toLowerCase().trim();

    // If it's explicitly an agronomy inquiry question, prioritize scientific consultation over navigation
    final isConsultationQuery = lower.contains('कैसे') ||
        lower.contains('उपचार') ||
        lower.contains('रोकथाम') ||
        lower.contains('इलाज') ||
        lower.contains('दवा') ||
        lower.contains('कितना') ||
        lower.contains('मात्रा') ||
        lower.contains('कब') ||
        lower.contains('क्यों') ||
        RegExp(r'\b(how|what|why|when|which|treatment|cure|medicine|dosage|dose)\b').hasMatch(lower);

    if (isConsultationQuery) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.none,
        speechFeedbackHindi: '',
        speechFeedbackEnglish: '',
      );
    }

    // Check for navigation action indicators
    final hasActionVerb = lower.contains('खोलो') ||
        lower.contains('खोल') ||
        lower.contains('दिखाओ') ||
        lower.contains('दिखाइए') ||
        lower.contains('जाओ') ||
        lower.contains('चलें') ||
        lower.contains('open') ||
        lower.contains('show') ||
        lower.contains('go to') ||
        lower.contains('view') ||
        lower.contains('navigate');

    // 1. Mandi Price Navigation
    if ((lower.contains('मंडी') || lower.contains('mandi')) &&
        (hasActionVerb || lower.contains('भाव') || lower.contains('रेट') || lower.contains('price') || lower.split(' ').length <= 3)) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateMandi,
        speechFeedbackHindi: 'जी, मंडी भाव स्क्रीन खोली जा रही है।',
        speechFeedbackEnglish: 'Opening Mandi Prices screen.',
      );
    }

    // 2. Crop Doctor (Camera Disease Detection)
    if ((lower.contains('डॉक्टर') || lower.contains('doctor') || lower.contains('कैमरा') || lower.contains('स्कैन')) &&
        (hasActionVerb || lower.split(' ').length <= 4)) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateCropDoctor,
        speechFeedbackHindi: 'जी, फसल डॉक्टर कैमरा स्क्रीन खोली जा रही है।',
        speechFeedbackEnglish: 'Opening Crop Doctor screen.',
      );
    }

    // 3. Sowing Advisor
    if ((lower.contains('बुवाई') || lower.contains('sowing')) &&
        (hasActionVerb || lower.contains('सलाहकार') || lower.contains('advisor') || lower.split(' ').length <= 3)) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateSowing,
        speechFeedbackHindi: 'जी, बुवाई सलाहकार खोला जा रहा है।',
        speechFeedbackEnglish: 'Opening Sowing Advisor.',
      );
    }

    // 4. Crop Calendar
    if (lower.contains('कैलेंडर') || lower.contains('calendar') || lower.contains('स्टेज') || lower.contains('अवस्था')) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateCalendar,
        speechFeedbackHindi: 'जी, फसल कैलेंडर खोला जा रहा है।',
        speechFeedbackEnglish: 'Opening Crop Calendar.',
      );
    }

    // 5. Soil Card & Fertilizer Calculator
    if (lower.contains('सॉइल') || lower.contains('soil') || lower.contains('मिट्टी जांच') || lower.contains('खाद कैलकुलेटर')) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateSoilCard,
        speechFeedbackHindi: 'जी, सॉइल हेल्थ कार्ड व खाद कैलकुलेटर खोला जा रहा है।',
        speechFeedbackEnglish: 'Opening Soil Card & Fertilizer calculator.',
      );
    }

    // 6. Govt Schemes & Subsidies
    if (lower.contains('योजना') || lower.contains('सब्सिडी') || lower.contains('scheme') || lower.contains('subsidy') || lower.contains('पीएम किसान') || lower.contains('कुसुम')) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateSchemes,
        speechFeedbackHindi: 'जी, सरकारी योजनाएं व सब्सिडी स्क्रीन खोली जा रही है।',
        speechFeedbackEnglish: 'Opening Government Schemes screen.',
      );
    }

    // 7. Farm Manager & Ledger
    if (lower.contains('खाता') || lower.contains('लेजर') || lower.contains('ledger') || lower.contains('खर्च') || lower.contains('expense')) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateFarmManager,
        speechFeedbackHindi: 'जी, फार्म लेजर व खर्च खाता खोला जा रहा है।',
        speechFeedbackEnglish: 'Opening Farm Manager ledger.',
      );
    }

    // 8. Crop Profile & Field Diary
    if (lower.contains('प्रोफ़ाइल') || lower.contains('मेरी फसल') || lower.contains('खेत डायरी') || lower.contains('profile') || lower.contains('my crop')) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateCropProfile,
        speechFeedbackHindi: 'जी, आपकी फसल प्रोफ़ाइल खोली जा रही है।',
        speechFeedbackEnglish: 'Opening your Crop Profile.',
      );
    }

    // 9. Weather & Pest Early Warning Center
    if (lower.contains('अलर्ट') ||
        lower.contains('चेतावनी') ||
        lower.contains('कीट अलर्ट') ||
        lower.contains('मौसम अलर्ट') ||
        lower.contains('पूर्वानुमान अलर्ट') ||
        lower.contains('alert') ||
        lower.contains('warning') ||
        lower.contains('early warning')) {
      return VoiceIntentResult(
        intent: VoiceActionIntent.navigateAlerts,
        speechFeedbackHindi: 'जी, मौसम व कीट पूर्व-चेतावनी केंद्र खोला जा रहा है।',
        speechFeedbackEnglish: 'Opening Weather & Pest Early Warning Center.',
      );
    }

    return VoiceIntentResult(
      intent: VoiceActionIntent.none,
      speechFeedbackHindi: '',
      speechFeedbackEnglish: '',
    );
  }

  /// Sends the farmer's query to Gemini 3.1 Flash-Lite with specialized agronomic prompting & profile context
  Future<String> askKrishiAI(String query, {bool isHindi = true, String? cropContext}) async {
    const apiKey = AppConstants.geminiApiKey;
    const model = AppConstants.geminiModel;

    final systemPrompt = isHindi
        ? 'आप "एआई कृषि साथी" हैं, जो भारतीय किसानों को वैज्ञानिक व सटीक कृषि सलाह देने वाले विशेषज्ञ हैं। '
          'किसान के सवाल का जवाब सरल, व्यावहारिक और स्पष्ट हिंदी में दें। '
          'जवाब 3 से 4 वाक्यों में रखें ताकि ऑडियो में सुनने में आसान हो। '
          'दवा, बीज या खाद की सही मात्रा और उपयोग का तरीका जरूर बताएं।'
        : 'You are "AI Krishi Saathi", an agricultural specialist assisting Indian farmers. '
          'Give direct, actionable, and scientific farming advice in 3 to 4 concise sentences so it sounds natural on audio. '
          'Include precise dosage, timing, and method.';

    final contextPart = cropContext != null && cropContext.isNotEmpty
        ? '\n\n$cropContext\n\n'
        : '\n\n';

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
      );

      final body = {
        'contents': [
          {
            'parts': [
              {
                'text': '$systemPrompt$contextPartकिसान का प्रश्न: "$query"\n\nआपका उत्तर:'
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 300,
        }
      };

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return (parts[0]['text'] as String).trim();
          }
        }
      }
    } catch (_) {}

    return isHindi
        ? 'माफ़ कीजिए, AI सर्वर से संपर्क नहीं हो पाया। कृपया अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।'
        : 'Could not connect to AI service. Please check your internet connection and try again.';
  }

  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
  }
}

enum VoiceActionIntent {
  navigateMandi,
  navigateCropDoctor,
  navigateSowing,
  navigateCalendar,
  navigateSoilCard,
  navigateSchemes,
  navigateFarmManager,
  navigateCropProfile,
  navigateAlerts,
  none,
}

class VoiceIntentResult {
  final VoiceActionIntent intent;
  final String speechFeedbackHindi;
  final String speechFeedbackEnglish;

  VoiceIntentResult({
    required this.intent,
    required this.speechFeedbackHindi,
    required this.speechFeedbackEnglish,
  });
}
