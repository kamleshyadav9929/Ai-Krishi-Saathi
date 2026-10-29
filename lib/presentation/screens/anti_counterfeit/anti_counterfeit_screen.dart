import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/product_scan_model.dart';
import '../../../data/services/anti_counterfeit_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class AntiCounterfeitScreen extends StatefulWidget {
  const AntiCounterfeitScreen({super.key});

  @override
  State<AntiCounterfeitScreen> createState() => _AntiCounterfeitScreenState();
}

class _AntiCounterfeitScreenState extends State<AntiCounterfeitScreen> with SingleTickerProviderStateMixin {
  final AntiCounterfeitService _service = AntiCounterfeitService();
  final ImagePicker _picker = ImagePicker();
  ProductScanResult? _scannedResult;
  bool _isScanning = false;
  late AnimationController _animController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleScan(ImageSource source) async {
    HapticHelper.mediumImpact();
    try {
      final image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() => _isScanning = true);
      await Future.delayed(const Duration(milliseconds: 800));

      final result = _service.verifyBarcode('8901234567890');
      if (!mounted) return;
      setState(() {
        _scannedResult = result;
        _isScanning = false;
      });
      HapticHelper.mediumConfirm();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isScanning = false);
    }
  }

  void _selectSample(ProductScanResult sample) {
    HapticHelper.lightImpact();
    setState(() => _scannedResult = sample);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: CustomAppBar(
        titleKey: lang.isHindi ? 'antiCounterfeit' : 'antiCounterfeit',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top FarmRise Viewfinder Target
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.035),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Scanner Reticle Box
                  Container(
                    width: 220,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF22C55E), width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            LucideIcons.qr_code,
                            size: 72,
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _scanAnimation,
                          builder: (context, _) {
                            return Positioned(
                              top: 180 * _scanAnimation.value,
                              left: 12,
                              right: 12,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4ADE80),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4ADE80).withValues(alpha: 0.8),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // Corner Guides
                        Positioned(top: 8, left: 8, child: _corner(true, true)),
                        Positioned(top: 8, right: 8, child: _corner(true, false)),
                        Positioned(bottom: 8, left: 8, child: _corner(false, true)),
                        Positioned(bottom: 8, right: 8, child: _corner(false, false)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lang.isHindi
                        ? 'बीज, खाद या कीटनाशक के पैकेट का QR / बारकोड स्कैन करें'
                        : 'Align seed or chemical packet QR / barcode within frame',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: BouncyTap(
                          onTap: () => _handleScan(ImageSource.camera),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF15803D),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isScanning) ...[
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    lang.isHindi ? 'सत्यापन हो रहा है...' : 'Verifying...',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ] else ...[
                                  const Icon(LucideIcons.camera, color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    lang.isHindi ? 'कैमरा से स्कैन करें' : 'Scan with Camera',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BouncyTap(
                        onTap: () => _handleScan(ImageSource.gallery),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: const Icon(LucideIcons.image, color: Color(0xFF15803D), size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Demo Sample Strip (FarmRise Fast Testing)
            Text(
              lang.isHindi ? 'डेमो उत्पाद जांचें (1-टैप परीक्षण):' : 'Sample Verified Products (1-Tap Test):',
              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _service.getSampleCatalog().map((prod) {
                  final isSelected = _scannedResult?.barcode == prod.barcode;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(lang.isHindi ? prod.productNameHindi.split('(').first : prod.productName.split('(').first),
                      selected: isSelected,
                      selectedColor: const Color(0xFF15803D),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => _selectSample(prod),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Verified Result Card
            if (_scannedResult != null) ...[
              _buildVerificationCard(lang, _scannedResult!),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _corner(bool isTop, bool isLeft) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFF22C55E), width: 3) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFF22C55E), width: 3) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFF22C55E), width: 3) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF22C55E), width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildVerificationCard(LanguageProvider lang, ProductScanResult item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Authenticity Badge Ribbon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.shield_check, color: Color(0xFF15803D), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.isHindi ? '100% प्रमाणित मूल उत्पाद' : '100% Genuine Verified Product',
                      style: const TextStyle(
                        color: Color(0xFF15803D),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${lang.isHindi ? 'निर्माता' : 'Manufacturer'}: ${item.manufacturer}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),

          // Product Name
          Text(
            lang.isHindi ? item.productNameHindi : item.productName,
            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Batch & Expiry Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang.isHindi ? 'बैच संख्या' : 'Batch No', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text(item.batchNumber, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang.isHindi ? 'निर्माण' : 'Mfg Date', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text(item.mfgDate, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang.isHindi ? 'वैधता (Expiry)' : 'Expiry', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text(item.expiryDate, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: item.isExpired ? Colors.red : const Color(0xFF15803D))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // FarmRise Signature Dosage Recommendation Pill
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.droplets, color: Color(0xFF1D4ED8), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.isHindi ? 'अनुशंसित प्रयोग मात्रा (15L टंकी हेतु)' : 'Recommended Spray Dosage',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lang.isHindi ? item.dosageHindi : item.dosage,
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF1E3A8A)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Safety Instruction
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.shield_alert, color: Color(0xFFD97706), size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  lang.isHindi ? item.warningHindi : item.warning,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
