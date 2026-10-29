import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class VideoItem {
  final String id;
  final String titleHindi;
  final String titleEnglish;
  final String channel;
  final String views;
  final String duration;
  final String category;
  final String summaryHindi;
  final Color accentColor;

  const VideoItem({
    required this.id,
    required this.titleHindi,
    required this.titleEnglish,
    required this.channel,
    required this.views,
    required this.duration,
    required this.category,
    required this.summaryHindi,
    required this.accentColor,
  });
}

class KrishiVideosScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const KrishiVideosScreen({super.key, this.onNavigateTab});

  @override
  State<KrishiVideosScreen> createState() => _KrishiVideosScreenState();
}

class _KrishiVideosScreenState extends State<KrishiVideosScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<VideoItem> _videos = const [
    VideoItem(
      id: 'v1',
      titleHindi: 'गेहूं में कल्ले (Tillering) 3 गुना बढ़ाने का अचूक वैज्ञानिक तरीका',
      titleEnglish: 'Scientific methods to increase wheat tillering 3x',
      channel: 'Bayer CropScience India',
      views: '247.5K',
      duration: '06:14',
      category: 'Crop Protection',
      summaryHindi: 'बुवाई के 21-25 दिनों में पहली सिंचाई (CRI) के बाद यूरिया व जिंक के संतुलन से कल्लों का अधिकतम विकास सुनिश्चित करें।',
      accentColor: Color(0xFF15803D),
    ),
    VideoItem(
      id: 'v2',
      titleHindi: 'सरसों में माहू (Aphids) और फंगस का 100% सटीक नियंत्रण',
      titleEnglish: '100% control of aphids and blight in mustard',
      channel: 'कृषि विज्ञान केंद्र (KVK)',
      views: '189.2K',
      duration: '08:45',
      category: 'Crop Protection',
      summaryHindi: 'माहू कीट दिखने पर प्रारम्भिक अवस्था में ही नीम तेल या अनुशंसित कीटनाशक का 15 लीटर पंप में सही माप से छिड़काव करें।',
      accentColor: Color(0xFFCA8A04),
    ),
    VideoItem(
      id: 'v3',
      titleHindi: 'कृषि ड्रोन से नैनो यूरिया व कीटनाशक स्प्रे: समय और पैसे की बचत',
      titleEnglish: 'Drone spraying for Nano Urea & insecticides',
      channel: 'Smart Agri Tech',
      views: '95.4K',
      duration: '05:30',
      category: 'AgTech & Drones',
      summaryHindi: 'ड्रोन तकनीक से मात्र 7 मिनट प्रति एकड़ में एकसमान स्प्रे करें और 50% पानी व मजदूरी की बचत करें।',
      accentColor: Color(0xFF2563EB),
    ),
    VideoItem(
      id: 'v4',
      titleHindi: 'Bayer Confidor व Nativo के सही डोज और स्प्रे की सावधानियां',
      titleEnglish: 'Bayer Confidor & Nativo optimal dosage guide',
      channel: 'Bayer Academy',
      views: '312.8K',
      duration: '07:22',
      category: 'Fertilizers',
      summaryHindi: 'दवाओं का असली होलोग्राम बारकोड अवश्य जांचें। तेज धूप व दोपहर के समय स्प्रे करने से बचें।',
      accentColor: Color(0xFF0D9488),
    ),
    VideoItem(
      id: 'v5',
      titleHindi: 'PM किसान सम्मान निधि: ई-केवाईसी व 19वीं किस्त स्थिति कैसे जांचें',
      titleEnglish: 'PM-Kisan 19th installment & e-KYC status guide',
      channel: 'सरकारी कृषि योजनाएं',
      views: '450.1K',
      duration: '04:18',
      category: 'Govt Schemes',
      summaryHindi: 'घर बैठे मोबाइल से आधार कार्ड के माध्यम से ई-केवाईसी पूरा करें और बैंक खाते में डीबीटी ट्रांसफर सक्रिय रखें।',
      accentColor: Color(0xFFEA580C),
    ),
    VideoItem(
      id: 'v6',
      titleHindi: 'जैविक जीवामृत और वेस्ट डीकंपोजर तैयार करने की विधि',
      titleEnglish: 'Organic Jeevamrut & waste decomposer preparation',
      channel: 'प्राकृतिक खेती मिशन',
      views: '128.6K',
      duration: '09:50',
      category: 'Organic Farming',
      summaryHindi: 'देसी गाय के गोबर, गोमूत्र, बेसन व गुड़ से शक्तिशाली तरल खाद 7 दिनों में तैयार करने का सरल तरीका।',
      accentColor: Color(0xFF166534),
    ),
  ];

  List<VideoItem> get _filteredVideos {
    return _videos.where((v) {
      final matchesCategory = _selectedCategory == 'All' || v.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          v.titleHindi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.titleEnglish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.channel.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _showVideoDialog(VideoItem video, bool isHindi) {
    HapticHelper.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Video simulation player card
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: const Color(0xFF0F172A),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              video.accentColor.withValues(alpha: 0.8),
                              const Color(0xFF0F172A),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                LucideIcons.play,
                                color: Color(0xFF15803D),
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isHindi ? 'वीडियो चल रहा है...' : 'Playing Video...',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            video.duration,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isHindi ? video.titleHindi : video.titleEnglish,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      video.channel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(LucideIcons.eye, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    '${video.views} views',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'मुख्य कृषि सीख:' : 'Key Agri Advice:',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.summaryHindi,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticHelper.lightTap();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isHindi ? 'वीडियो लिंक कॉपी हुआ!' : 'Video link copied!'),
                            backgroundColor: const Color(0xFF15803D),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.share_2, size: 18),
                      label: Text(isHindi ? 'शेयर करें' : 'Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF15803D),
                        side: const BorderSide(color: Color(0xFFBBF7D0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticHelper.lightTap();
                        Navigator.pop(ctx);
                      },
                      icon: const Icon(LucideIcons.check, size: 18),
                      label: Text(isHindi ? 'पूर्ण' : 'Close'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isHindi = lang.isHindi;

    final categories = [
      {'key': 'All', 'label': isHindi ? 'सभी' : 'All'},
      {'key': 'Crop Protection', 'label': isHindi ? 'फसल सुरक्षा' : 'Crop Protection'},
      {'key': 'Fertilizers', 'label': isHindi ? 'उर्वरक व खाद' : 'Fertilizers'},
      {'key': 'AgTech & Drones', 'label': isHindi ? 'ड्रोन व तकनीक' : 'Drones & Tech'},
      {'key': 'Govt Schemes', 'label': isHindi ? 'सरकारी योजनाएं' : 'Govt Schemes'},
      {'key': 'Organic Farming', 'label': isHindi ? 'जैविक खेती' : 'Organic'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: CustomAppBar(titleKey: isHindi ? 'videosForYou' : 'videosForYou'),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: isHindi ? 'कृषि वीडियो या फसल खोजें...' : 'Search agri videos or crops...',
                  hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Categories Horizontal Bar
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (ctx, idx) {
                final cat = categories[idx];
                final isSelected = _selectedCategory == cat['key'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      cat['label']!,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      HapticHelper.lightTap();
                      setState(() => _selectedCategory = cat['key']!);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF15803D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Videos List
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              itemCount: _filteredVideos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (ctx, idx) {
                final video = _filteredVideos[idx];
                return BouncyTap(
                  onTap: () => _showVideoDialog(video, isHindi),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video Card Banner
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  video.accentColor.withValues(alpha: 0.85),
                                  const Color(0xFF0F172A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        LucideIcons.play,
                                        color: Color(0xFF15803D),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(LucideIcons.eye, size: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          video.views,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.75),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      video.duration,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Title & Channel Details
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHindi ? video.titleHindi : video.titleEnglish,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                  height: 1.35,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    video.channel,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    video.category,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
