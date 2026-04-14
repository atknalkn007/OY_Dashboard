import 'package:oy_site/models/parsed_scan_report.dart';

class ScanReportTextParser {
  const ScanReportTextParser();

  ParsedScanReport parse(String rawText) {
    final text = _normalize(rawText);

    return ParsedScanReport(
      reportNo: _extractSingleValue(text, 'No.'),
      reportDate: _extractSingleValue(text, 'Date'),
      reportTime: _extractSingleValue(text, 'Time'),
      storeCode: _extractSingleValue(text, 'Store'),
      address: _extractSingleValue(text, 'Address'),
      customerName: _extractSingleValue(text, 'Name'),
      gender: _extractSingleValue(text, 'Gender'),
      age: _extractSingleValue(text, 'Age'),
      phone: _extractSingleValue(text, 'Tel'),

      leftFootLength: _extractPairDouble(text, 'Foot length', isLeft: true),
      rightFootLength: _extractPairDouble(text, 'Foot length', isLeft: false),

      leftSoleLength: _extractPairDouble(text, 'Sole length', isLeft: true),
      rightSoleLength: _extractPairDouble(text, 'Sole length', isLeft: false),

      leftArchLength: _extractPairDouble(text, 'Arch length', isLeft: true),
      rightArchLength: _extractPairDouble(text, 'Arch length', isLeft: false),

      leftFirstMetaLength:
          _extractPairDouble(text, 'First meta length', isLeft: true),
      rightFirstMetaLength:
          _extractPairDouble(text, 'First meta length', isLeft: false),

      leftFifthMetaLength:
          _extractPairDouble(text, 'Fifth meta length', isLeft: true),
      rightFifthMetaLength:
          _extractPairDouble(text, 'Fifth meta length', isLeft: false),

      leftHalluxBumpsLength:
          _extractPairDouble(text, 'Hallux bumps length', isLeft: true),
      rightHalluxBumpsLength:
          _extractPairDouble(text, 'Hallux bumps length', isLeft: false),

      leftFootFlankLength:
          _extractPairDouble(text, 'Foot flank length', isLeft: true),
      rightFootFlankLength:
          _extractPairDouble(text, 'Foot flank length', isLeft: false),

      leftHeelCenterLength:
          _extractPairDouble(text, 'Heel center length', isLeft: true),
      rightHeelCenterLength:
          _extractPairDouble(text, 'Heel center length', isLeft: false),

      leftHeelMarginLength:
          _extractPairDouble(text, 'Heel margin length', isLeft: true),
      rightHeelMarginLength:
          _extractPairDouble(text, 'Heel margin length', isLeft: false),

      leftFootWidth: _extractPairDouble(text, 'Foot width', isLeft: true),
      rightFootWidth: _extractPairDouble(text, 'Foot width', isLeft: false),

      leftSlantWidth: _extractPairDouble(text, 'Slant width', isLeft: true),
      rightSlantWidth: _extractPairDouble(text, 'Slant width', isLeft: false),

      leftToeWidth: _extractPairDouble(text, 'Toe width', isLeft: true),
      rightToeWidth: _extractPairDouble(text, 'Toe width', isLeft: false),

      leftArchOutsideWidth:
          _extractPairDouble(text, 'Arch outside width', isLeft: true),
      rightArchOutsideWidth:
          _extractPairDouble(text, 'Arch outside width', isLeft: false),

      leftFootFlankWidth:
          _extractPairDouble(text, 'Foot flank width', isLeft: true),
      rightFootFlankWidth:
          _extractPairDouble(text, 'Foot flank width', isLeft: false),

      leftHeelCenterWidth:
          _extractPairDouble(text, 'Heel center width', isLeft: true),
      rightHeelCenterWidth:
          _extractPairDouble(text, 'Heel center width', isLeft: false),

      leftTotalHeelWidth:
          _extractPairDouble(text, 'Total heel width', isLeft: true),
      rightTotalHeelWidth:
          _extractPairDouble(text, 'Total heel width', isLeft: false),

      leftArchHeight: _extractPairDouble(text, 'Arch height', isLeft: true),
      rightArchHeight: _extractPairDouble(text, 'Arch height', isLeft: false),

      leftFirstMetaJointHeight:
          _extractPairDouble(text, 'First meta joint height', isLeft: true),
      rightFirstMetaJointHeight:
          _extractPairDouble(text, 'First meta joint height', isLeft: false),

      leftHeelProtrusionHeight:
          _extractPairDouble(text, 'Heel protrusion height', isLeft: true),
      rightHeelProtrusionHeight:
          _extractPairDouble(text, 'Heel protrusion height', isLeft: false),

      leftHalluxAngle: _extractPairDouble(text, 'Hallux angle', isLeft: true),
      rightHalluxAngle:
          _extractPairDouble(text, 'Hallux angle', isLeft: false),

      leftPronatorAngle:
          _extractPairDouble(text, 'Pronator angle', isLeft: true),
      rightPronatorAngle:
          _extractPairDouble(text, 'Pronator angle', isLeft: false),

      leftKneeAngle: _extractPairDouble(text, 'Knee angle', isLeft: true),
      rightKneeAngle: _extractPairDouble(text, 'Knee angle', isLeft: false),

      leftShoeSize: _extractPairString(text, 'Shoe size', isLeft: true),
      rightShoeSize: _extractPairString(text, 'Shoe size', isLeft: false),

      leftInsoleRecommendation: _extractPairString(
        text,
        'Insole recommendation',
        isLeft: true,
      ),
      rightInsoleRecommendation: _extractPairString(
        text,
        'Insole recommendation',
        isLeft: false,
      ),

      leftArchType: _extractArchType(text, isLeft: true),
      rightArchType: _extractArchType(text, isLeft: false),

      leftArchIndex: _extractArchIndex(text, isLeft: true),
      rightArchIndex: _extractArchIndex(text, isLeft: false),

      leftArchWidthIndex:
          _extractArchWidthIndex(text, isLeft: true),
      rightArchWidthIndex:
          _extractArchWidthIndex(text, isLeft: false),

      leftHalluxType: _extractTypeNearSection(
        text,
        sectionTitle: 'Hallux analysis',
        isLeft: true,
      ),
      rightHalluxType: _extractTypeNearSection(
        text,
        sectionTitle: 'Hallux analysis',
        isLeft: false,
      ),

      leftHeelType: _extractPairString(text, 'Heel type', isLeft: true),
      rightHeelType: _extractPairString(text, 'Heel type', isLeft: false),

      leftKneeType: _extractPairString(text, 'Knee type', isLeft: true),
      rightKneeType: _extractPairString(text, 'Knee type', isLeft: false),

      recommendationText: _extractRecommendationText(text),
      rawText: text,
    );
  }

  String _normalize(String input) {
    return input
        .replaceAll('\r', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('：', ':')
        .replaceAll('（', '(')
        .replaceAll('）', ')')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String? _extractSingleValue(String text, String label) {
    final patterns = <RegExp>[
      RegExp('$label\\s+([^\\s]+)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  double? _extractPairDouble(
    String text,
    String label, {
    required bool isLeft,
  }) {
    final pattern = RegExp(
      '$label\\s+(-?\\d+(?:\\.\\d+)?)\\s+(-?\\d+(?:\\.\\d+)?)',
      caseSensitive: false,
    );

    final match = pattern.firstMatch(text);
    if (match == null) return null;

    final raw = isLeft ? match.group(1) : match.group(2);
    return raw == null ? null : double.tryParse(raw);
  }

  String? _extractPairString(
    String text,
    String label, {
    required bool isLeft,
  }) {
    final pattern = RegExp(
      '$label\\s+([^\\s]+)\\s+([^\\s]+)',
      caseSensitive: false,
    );

    final match = pattern.firstMatch(text);
    if (match == null) return null;

    return isLeft ? match.group(1)?.trim() : match.group(2)?.trim();
  }

  String? _extractArchType(String text, {required bool isLeft}) {
    final pattern = RegExp(
      r'Left foot Right foot\s+(.+?) Arch Type (.+?)\s',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(text);
    if (match == null) return null;

    return isLeft ? match.group(1)?.trim() : match.group(2)?.trim();
  }

  double? _extractArchIndex(String text, {required bool isLeft}) {
    final pattern = RegExp(
      r'Arch Type .+? (-?\d+(?:\.\d+)?) Arch Index (-?\d+(?:\.\d+)?)',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(text);
    if (match == null) return null;

    final raw = isLeft ? match.group(1) : match.group(2);
    return raw == null ? null : double.tryParse(raw);
  }

  double? _extractArchWidthIndex(String text, {required bool isLeft}) {
    final pattern = RegExp(
      r'Arch height\(mm\)\s+(-?\d+(?:\.\d+)?)\s+0\.\d+\s+Right foot\s+(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)',
      caseSensitive: false,
    );

    final simplePattern = RegExp(
      r'(\d+(?:\.\d+)?) Arch height\(mm\) (\d+(?:\.\d+)?) (\d+(?:\.\d+)?) Arch width Index (\d+(?:\.\d+)?)',
      caseSensitive: false,
    );

    final match = simplePattern.firstMatch(text);
    if (match == null) return null;

    final raw = isLeft ? match.group(2) : match.group(4);
    return raw == null ? null : double.tryParse(raw);
  }

  String? _extractTypeNearSection(
    String text, {
    required String sectionTitle,
    required bool isLeft,
  }) {
    final sectionPattern = RegExp(
      '$sectionTitle.*?Left foot Right foot\\s+(-?\\d+(?:\\.\\d+)?)\\s+Hallux angle\\(°\\)\\s+(-?\\d+(?:\\.\\d+)?)\\s+(.+?)\\s+Type\\s+(.+?)\\s',
      caseSensitive: false,
    );

    final match = sectionPattern.firstMatch(text);
    if (match == null) return null;

    return isLeft ? match.group(3)?.trim() : match.group(4)?.trim();
  }

  String? _extractRecommendationText(String text) {
    final index = text.indexOf('Recommendation:');
    if (index == -1) return null;

    final recommendation = text.substring(index + 'Recommendation:'.length).trim();
    if (recommendation.isEmpty) return null;
    return recommendation;
  }
}