import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/services/voice_assistant_service.dart';

class VoiceAssistantSheet extends StatefulWidget {
  final String? customContext;
  final String? initialQuery;
  final Function(VoiceActionIntent intent)? onVoiceAction;

  const VoiceAssistantSheet({
    super.key,
    this.customContext,
    this.initialQuery,
    this.onVoiceAction,
  });

  static Future<void> show(
    BuildContext context, {
    String? customContext,
    String? initialQuery,
    Function(VoiceActionIntent intent)? onVoiceAction,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VoiceAssistantSheet(
        customContext: customContext,
        initialQuery: initialQuery,
        onVoiceAction: onVoiceAction,
      ),
    );
  }

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  final TextEditingController _textController = TextEditingController();

  bool _isListening = false;
  bool _isLoading = false;
  bool _isSpeaking = false;
  String _currentQuery = '';
  String? _aiResponse;

  final List<String> _quickPromptsHindi = [
    'सरसों में माहू (चेपा) की रोकथाम कैसे करें?',
    'गेहूं में पहली सिंचाई (CRI) कब करनी चाहिए?',
    'आलू में झुलसा रोग के लक्षण व उपचार',
    'धान में जिंक और यूरिया की सही मात्रा',
  ];

  final List<String> _quickPromptsEnglish = [
    'How to control aphids in mustard?',
    'When to schedule 1st irrigation in wheat?',
    'Symptoms and treatment of potato blight',
    'Recommended dose of Zinc & Urea in Paddy',
  ];

  @override
  void initState() {
    super.initState();
    _initVoice();
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentQuery = widget.initialQuery!;
        _textController.text = widget.initialQuery!;
        _submitQuery(widget.initialQuery!);
      });
    }
  }

  Future<void> _initVoice() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    await _voiceService.initSpeech();
    await _voiceService.initTts(isHindi: lang.isHindi);
  }

  Future<void> _toggleListening() async {
    HapticHelper.mediumImpact();
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
      if (_currentQuery.trim().isNotEmpty) {
        _submitQuery(_currentQuery.trim());
      }
    } else {
      setState(() {
        _isListening = true;
        _currentQuery = '';
        _aiResponse = null;
      });

      await _voiceService.startListening(
        isHindi: lang.isHindi,
        onResult: (words) {
          setState(() {
            _currentQuery = words;
            _textController.text = words;
          });
        },
      );
    }
  }

  Future<void> _submitQuery(String query) async {
    if (query.trim().isEmpty) return;

    final lang = Provider.of<LanguageProvider>(context, listen: false);
    await _voiceService.stopListening();

    // 1. Check if user spoke a voice navigation command to control the app
    final intentResult = _voiceService.parseVoiceIntent(query);
    if (intentResult.intent != VoiceActionIntent.none && widget.onVoiceAction != null) {
      final feedback = lang.isHindi ? intentResult.speechFeedbackHindi : intentResult.speechFeedbackEnglish;
      setState(() {
        _isListening = false;
        _isLoading = false;
        _aiResponse = feedback;
        _isSpeaking = true;
      });

      HapticHelper.mediumImpact();
      await _voiceService.speak(feedback, isHindi: lang.isHindi);
      if (mounted) {
        Navigator.pop(context);
        widget.onVoiceAction!(intentResult.intent);
      }
      return;
    }

    // 2. Otherwise, treat as an agronomic query with personalized crop context
    setState(() {
      _isListening = false;
      _isLoading = true;
      _aiResponse = null;
    });

    final answer = await _voiceService.askKrishiAI(
      query,
      isHindi: lang.isHindi,
      cropContext: widget.customContext,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _aiResponse = answer;
      _isSpeaking = true;
    });

    HapticHelper.lightImpact();
    await _voiceService.speak(answer, isHindi: lang.isHindi);
    if (mounted) {
      setState(() => _isSpeaking = false);
    }
  }

  Future<void> _toggleAudioPlayback() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    if (_isSpeaking) {
      await _voiceService.stopSpeaking();
      setState(() => _isSpeaking = false);
    } else if (_aiResponse != null) {
      setState(() => _isSpeaking = true);
      await _voiceService.speak(_aiResponse!, isHindi: lang.isHindi);
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final quickPrompts = lang.isHindi ? _quickPromptsHindi : _quickPromptsEnglish;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.sparkles, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.isHindi ? 'बोलकर पूछें (AI वॉयस साथी)' : 'Voice Krishi Assistant',
                        style: AppTypography.headingMedium(isHindi: lang.isHindi),
                      ),
                      Text(
                        widget.customContext != null
                            ? (lang.isHindi ? 'आपकी फसल प्रोफ़ाइल से जुड़ा हुआ' : 'Connected to your Crop Profile')
                            : (lang.isHindi ? 'अपनी भाषा में कोई भी कृषि सवाल पूछें' : 'Speak any agricultural question'),
                        style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                          color: widget.customContext != null ? const Color(0xFF15803D) : AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: widget.customContext != null ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, size: 20, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Central Microphone Button
          Center(
            child: GestureDetector(
              onTap: _toggleListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? AppColors.error : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? AppColors.error : AppColors.primary).withValues(alpha: 0.35),
                      blurRadius: _isListening ? 24 : 12,
                      spreadRadius: _isListening ? 6 : 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? LucideIcons.square : LucideIcons.mic,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isListening)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(LucideIcons.radio, size: 14, color: AppColors.error),
                ),
              Text(
                _isListening
                    ? (lang.isHindi ? 'सुन रहा हूँ... बोलिए' : 'Listening... Speak now')
                    : (lang.isHindi ? 'बोलने के लिए माइक बटन दबाएं' : 'Tap mic to start speaking'),
                style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                  color: _isListening ? AppColors.error : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Query Transcript or Input
          if (_currentQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.message_square_quote, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentQuery,
                      style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // AI Response Card
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    lang.isHindi ? 'कृषि विशेषज्ञ AI उत्तर तैयार कर रहा है...' : 'AI Krishi Saathi is analyzing...',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi),
                  ),
                ],
              ),
            )
          else if (_aiResponse != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryContainer, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.bot, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            lang.isHindi ? 'AI वैज्ञानिक सलाह:' : 'AI Agronomist Advice:',
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: _toggleAudioPlayback,
                        icon: Icon(
                          _isSpeaking ? LucideIcons.volume_x : LucideIcons.volume_2,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _aiResponse!,
                    style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0),

          // Quick Questions Chips
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              lang.isHindi ? 'अक्सर पूछे जाने वाले सवाल:' : 'Frequently Asked Questions:',
              style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quickPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(
                      prompt,
                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 11,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      _textController.text = prompt;
                      setState(() => _currentQuery = prompt);
                      _submitQuery(prompt);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
