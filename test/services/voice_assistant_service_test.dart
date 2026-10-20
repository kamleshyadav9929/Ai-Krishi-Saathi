import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/services/voice_assistant_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VoiceAssistantService Voice Intent Parsing Tests', () {
    late VoiceAssistantService service;

    setUp(() {
      service = VoiceAssistantService();
    });

    test('Accurately maps Mandi price commands in Hindi and English', () {
      final resHindi = service.parseVoiceIntent('मंडी भाव दिखाओ');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateMandi));
      expect(resHindi.speechFeedbackHindi, contains('मंडी भाव'));

      final resEnglish = service.parseVoiceIntent('show mandi price');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateMandi));
      expect(resEnglish.speechFeedbackEnglish, contains('Mandi Prices'));

      final resShort = service.parseVoiceIntent('आज का मंडी रेट');
      expect(resShort.intent, equals(VoiceActionIntent.navigateMandi));
    });

    test('Accurately maps Crop Doctor commands', () {
      final resHindi = service.parseVoiceIntent('फसल डॉक्टर खोलो');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateCropDoctor));

      final resCamera = service.parseVoiceIntent('कैमरा स्कैन खोलो');
      expect(resCamera.intent, equals(VoiceActionIntent.navigateCropDoctor));

      final resEnglish = service.parseVoiceIntent('open crop doctor');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateCropDoctor));
    });

    test('Accurately maps Sowing Advisor commands', () {
      final resHindi = service.parseVoiceIntent('बुवाई सलाहकार खोलो');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateSowing));

      final resEnglish = service.parseVoiceIntent('open sowing advisor');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateSowing));
    });

    test('Accurately maps Crop Calendar commands', () {
      final resHindi = service.parseVoiceIntent('फसल कैलेंडर दिखाओ');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateCalendar));

      final resEnglish = service.parseVoiceIntent('show crop calendar');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateCalendar));
    });

    test('Accurately maps Soil Card & Fertilizer Calculator commands', () {
      final resHindi = service.parseVoiceIntent('सॉइल कार्ड खोलो');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateSoilCard));

      final resKhad = service.parseVoiceIntent('खाद कैलकुलेटर दिखाओ');
      expect(resKhad.intent, equals(VoiceActionIntent.navigateSoilCard));

      final resEnglish = service.parseVoiceIntent('open soil card');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateSoilCard));
    });

    test('Accurately maps Govt Schemes commands', () {
      final resHindi = service.parseVoiceIntent('सरकारी योजनाएं दिखाओ');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateSchemes));

      final resSubsidy = service.parseVoiceIntent('सोलर पंप सब्सिडी योजना खोलो');
      expect(resSubsidy.intent, equals(VoiceActionIntent.navigateSchemes));

      final resEnglish = service.parseVoiceIntent('view govt schemes and subsidy');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateSchemes));
    });

    test('Accurately maps Farm Manager / Expense Ledger commands', () {
      final resHindi = service.parseVoiceIntent('फार्म लेजर खोलो');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateFarmManager));

      final resKhata = service.parseVoiceIntent('खर्च खाता दिखाओ');
      expect(resKhata.intent, equals(VoiceActionIntent.navigateFarmManager));

      final resEnglish = service.parseVoiceIntent('open farm expense ledger');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateFarmManager));
    });

    test('Accurately maps Crop Profile & Field Diary commands', () {
      final resHindi = service.parseVoiceIntent('मेरी फसल प्रोफ़ाइल खोलो');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateCropProfile));

      final resDiary = service.parseVoiceIntent('खेत डायरी खोलो');
      expect(resDiary.intent, equals(VoiceActionIntent.navigateCropProfile));

      final resEnglish = service.parseVoiceIntent('open my crop profile');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateCropProfile));
    });

    test('Accurately maps Weather & Pest Early Warning Center commands', () {
      final resHindi = service.parseVoiceIntent('मौसम अलर्ट दिखाओ');
      expect(resHindi.intent, equals(VoiceActionIntent.navigateAlerts));

      final resChetavani = service.parseVoiceIntent('कीट चेतावनी केंद्र खोलो');
      expect(resChetavani.intent, equals(VoiceActionIntent.navigateAlerts));

      final resEnglish = service.parseVoiceIntent('show weather alerts and warnings');
      expect(resEnglish.intent, equals(VoiceActionIntent.navigateAlerts));
    });

    test('Agronomic advisory questions are NOT misinterpreted as navigation', () {
      // Questions asking for disease treatment should go to Gemini, not jump to screen
      final q1 = service.parseVoiceIntent('सरसों में माहू (चेपा) की रोकथाम कैसे करें?');
      expect(q1.intent, equals(VoiceActionIntent.none));

      final q2 = service.parseVoiceIntent('गेहूं में पहली सिंचाई कब करनी चाहिए?');
      expect(q2.intent, equals(VoiceActionIntent.none));

      final q3 = service.parseVoiceIntent('आलू में झुलसा रोग का क्या इलाज है?');
      expect(q3.intent, equals(VoiceActionIntent.none));

      final q4 = service.parseVoiceIntent('धान में जिंक और यूरिया की कितनी मात्रा डालें?');
      expect(q4.intent, equals(VoiceActionIntent.none));

      final q5 = service.parseVoiceIntent('How to control blight disease in tomato?');
      expect(q5.intent, equals(VoiceActionIntent.none));
    });
  });
}
