class ParsedScanReport {
  final String? reportNo;
  final String? reportDate;
  final String? reportTime;
  final String? storeCode;
  final String? address;

  final String? customerName;
  final String? gender;
  final String? age;
  final String? phone;

  final double? leftFootLength;
  final double? rightFootLength;

  final double? leftSoleLength;
  final double? rightSoleLength;

  final double? leftArchLength;
  final double? rightArchLength;

  final double? leftFirstMetaLength;
  final double? rightFirstMetaLength;

  final double? leftFifthMetaLength;
  final double? rightFifthMetaLength;

  final double? leftHalluxBumpsLength;
  final double? rightHalluxBumpsLength;

  final double? leftFootFlankLength;
  final double? rightFootFlankLength;

  final double? leftHeelCenterLength;
  final double? rightHeelCenterLength;

  final double? leftHeelMarginLength;
  final double? rightHeelMarginLength;

  final double? leftFootWidth;
  final double? rightFootWidth;

  final double? leftSlantWidth;
  final double? rightSlantWidth;

  final double? leftToeWidth;
  final double? rightToeWidth;

  final double? leftArchOutsideWidth;
  final double? rightArchOutsideWidth;

  final double? leftFootFlankWidth;
  final double? rightFootFlankWidth;

  final double? leftHeelCenterWidth;
  final double? rightHeelCenterWidth;

  final double? leftTotalHeelWidth;
  final double? rightTotalHeelWidth;

  final double? leftArchHeight;
  final double? rightArchHeight;

  final double? leftFirstMetaJointHeight;
  final double? rightFirstMetaJointHeight;

  final double? leftHeelProtrusionHeight;
  final double? rightHeelProtrusionHeight;

  final double? leftHalluxAngle;
  final double? rightHalluxAngle;

  final double? leftPronatorAngle;
  final double? rightPronatorAngle;

  final double? leftKneeAngle;
  final double? rightKneeAngle;

  final String? leftShoeSize;
  final String? rightShoeSize;

  final String? leftInsoleRecommendation;
  final String? rightInsoleRecommendation;

  final String? leftArchType;
  final String? rightArchType;

  final double? leftArchIndex;
  final double? rightArchIndex;

  final double? leftArchWidthIndex;
  final double? rightArchWidthIndex;

  final String? leftHalluxType;
  final String? rightHalluxType;

  final String? leftHeelType;
  final String? rightHeelType;

  final String? leftKneeType;
  final String? rightKneeType;

  final String? recommendationText;
  final String? rawText;

  const ParsedScanReport({
    this.reportNo,
    this.reportDate,
    this.reportTime,
    this.storeCode,
    this.address,
    this.customerName,
    this.gender,
    this.age,
    this.phone,
    this.leftFootLength,
    this.rightFootLength,
    this.leftSoleLength,
    this.rightSoleLength,
    this.leftArchLength,
    this.rightArchLength,
    this.leftFirstMetaLength,
    this.rightFirstMetaLength,
    this.leftFifthMetaLength,
    this.rightFifthMetaLength,
    this.leftHalluxBumpsLength,
    this.rightHalluxBumpsLength,
    this.leftFootFlankLength,
    this.rightFootFlankLength,
    this.leftHeelCenterLength,
    this.rightHeelCenterLength,
    this.leftHeelMarginLength,
    this.rightHeelMarginLength,
    this.leftFootWidth,
    this.rightFootWidth,
    this.leftSlantWidth,
    this.rightSlantWidth,
    this.leftToeWidth,
    this.rightToeWidth,
    this.leftArchOutsideWidth,
    this.rightArchOutsideWidth,
    this.leftFootFlankWidth,
    this.rightFootFlankWidth,
    this.leftHeelCenterWidth,
    this.rightHeelCenterWidth,
    this.leftTotalHeelWidth,
    this.rightTotalHeelWidth,
    this.leftArchHeight,
    this.rightArchHeight,
    this.leftFirstMetaJointHeight,
    this.rightFirstMetaJointHeight,
    this.leftHeelProtrusionHeight,
    this.rightHeelProtrusionHeight,
    this.leftHalluxAngle,
    this.rightHalluxAngle,
    this.leftPronatorAngle,
    this.rightPronatorAngle,
    this.leftKneeAngle,
    this.rightKneeAngle,
    this.leftShoeSize,
    this.rightShoeSize,
    this.leftInsoleRecommendation,
    this.rightInsoleRecommendation,
    this.leftArchType,
    this.rightArchType,
    this.leftArchIndex,
    this.rightArchIndex,
    this.leftArchWidthIndex,
    this.rightArchWidthIndex,
    this.leftHalluxType,
    this.rightHalluxType,
    this.leftHeelType,
    this.rightHeelType,
    this.leftKneeType,
    this.rightKneeType,
    this.recommendationText,
    this.rawText,
  });

  bool get hasAnyCoreMeasurement =>
      leftFootLength != null ||
      rightFootLength != null ||
      leftFootWidth != null ||
      rightFootWidth != null ||
      leftArchHeight != null ||
      rightArchHeight != null;
}