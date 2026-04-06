import 'package:flutter/material.dart';
import 'package:oy_site/models/app_user.dart';

class AnalysisScreen extends StatefulWidget {
  final AppUser currentUser;

  const AnalysisScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isLoading = true;
  List<AnalysisSessionViewModel> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadAnalysisData();
  }

  Future<void> _loadAnalysisData() async {
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      _sessions = _buildMockSessions();
      _isLoading = false;
    });
  }

  List<AnalysisSessionViewModel> _buildMockSessions() {
    return [
      AnalysisSessionViewModel(
        sessionCode: 'MS-2026-001',
        patientName: 'Ayşe Demir',
        sessionDate: DateTime(2026, 3, 21),
        status: 'completed',
        has3dScan: true,
        hasPlantarCsv: true,
        hasInsolePhoto: true,
        leftArchType: 'Pes Planus',
        rightArchType: 'Normal Ark',
        leftArchHeightMm: 21.4,
        rightArchHeightMm: 27.8,
        leftFootLengthMm: 243.2,
        rightFootLengthMm: 245.1,
        leftPronatorAngleDeg: 8.6,
        rightPronatorAngleDeg: 4.2,
        peakPressureKpa: 312.4,
        meanPressureKpa: 146.8,
        contactAreaCm2: 128.5,
        leftLoadPercent: 53.2,
        rightLoadPercent: 46.8,
        stabilityScore: 72.4,
        recommendationSummary:
            'Sol ark desteği ve hafif topuk stabilizasyonu önerilir.',
      ),
      AnalysisSessionViewModel(
        sessionCode: 'MS-2026-002',
        patientName: 'Mehmet Kaya',
        sessionDate: DateTime(2026, 3, 28),
        status: 'completed',
        has3dScan: true,
        hasPlantarCsv: true,
        hasInsolePhoto: false,
        leftArchType: 'Normal Ark',
        rightArchType: 'Pes Cavus',
        leftArchHeightMm: 29.1,
        rightArchHeightMm: 34.7,
        leftFootLengthMm: 258.6,
        rightFootLengthMm: 259.0,
        leftPronatorAngleDeg: 3.1,
        rightPronatorAngleDeg: 7.4,
        peakPressureKpa: 338.9,
        meanPressureKpa: 154.2,
        contactAreaCm2: 121.0,
        leftLoadPercent: 48.7,
        rightLoadPercent: 51.3,
        stabilityScore: 68.9,
        recommendationSummary:
            'Sağ tarafta yüksek ark yapısına uygun destek ve metatarsal rahatlatma değerlendirilebilir.',
      ),
      AnalysisSessionViewModel(
        sessionCode: 'MS-2026-003',
        patientName: 'Elif Yıldız',
        sessionDate: DateTime(2026, 4, 1),
        status: 'in_progress',
        has3dScan: true,
        hasPlantarCsv: false,
        hasInsolePhoto: true,
        leftArchType: 'Normal Ark',
        rightArchType: 'Normal Ark',
        leftArchHeightMm: 26.0,
        rightArchHeightMm: 26.4,
        leftFootLengthMm: 236.4,
        rightFootLengthMm: 236.9,
        leftPronatorAngleDeg: 4.0,
        rightPronatorAngleDeg: 4.3,
        peakPressureKpa: null,
        meanPressureKpa: null,
        contactAreaCm2: null,
        leftLoadPercent: null,
        rightLoadPercent: null,
        stabilityScore: null,
        recommendationSummary:
            'Plantar basınç verisi bekleniyor. Nihai öneri için ölçüm tamamlanmalı.',
      ),
    ];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'draft':
        return Colors.blueGrey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Tamamlandı';
      case 'in_progress':
        return 'Devam Ediyor';
      case 'draft':
        return 'Taslak';
      case 'cancelled':
        return 'İptal';
      default:
        return status;
    }
  }

  String _metricText(num? value, {String suffix = ''}) {
    if (value == null) return '—';
    return '$value$suffix';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_sessions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            '${widget.currentUser.displayName} için analiz kaydı bulunamadı.',
          ),
        ),
      );
    }

    final latest = _sessions.last;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ayak Analizi',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ölçüm oturumları, 3D sonuçlar ve plantar basınç özetleri burada görüntülenir.',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),

            _buildLatestSessionSummary(latest),

            const SizedBox(height: 24),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildSessionHistory(),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: _buildRecommendationPanel(latest),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestSessionSummary(AnalysisSessionViewModel latest) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            runSpacing: 12,
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Son Oturum: ${latest.sessionCode}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(latest.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _statusLabel(latest.status),
                  style: TextStyle(
                    color: _statusColor(latest.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${latest.patientName} • ${_formatDate(latest.sessionDate)}',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Peak Pressure',
                  value: _metricText(latest.peakPressureKpa, suffix: ' kPa'),
                  icon: Icons.speed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Mean Pressure',
                  value: _metricText(latest.meanPressureKpa, suffix: ' kPa'),
                  icon: Icons.stacked_line_chart,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Contact Area',
                  value: _metricText(latest.contactAreaCm2, suffix: ' cm²'),
                  icon: Icons.crop_square,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Stability Score',
                  value: _metricText(latest.stabilityScore),
                  icon: Icons.balance,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildFootSideCard(
                  title: 'Sol Ayak',
                  archType: latest.leftArchType,
                  archHeight: _metricText(latest.leftArchHeightMm, suffix: ' mm'),
                  footLength:
                      _metricText(latest.leftFootLengthMm, suffix: ' mm'),
                  pronation:
                      _metricText(latest.leftPronatorAngleDeg, suffix: '°'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFootSideCard(
                  title: 'Sağ Ayak',
                  archType: latest.rightArchType,
                  archHeight:
                      _metricText(latest.rightArchHeightMm, suffix: ' mm'),
                  footLength:
                      _metricText(latest.rightFootLengthMm, suffix: ' mm'),
                  pronation:
                      _metricText(latest.rightPronatorAngleDeg, suffix: '°'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFootSideCard({
    required String title,
    required String archType,
    required String archHeight,
    required String footLength,
    required String pronation,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _buildKeyValueRow('Ark Tipi', archType),
          _buildKeyValueRow('Ark Yüksekliği', archHeight),
          _buildKeyValueRow('Ayak Uzunluğu', footLength),
          _buildKeyValueRow('Pronasyon Açısı', pronation),
        ],
      ),
    );
  }

  Widget _buildSessionHistory() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ölçüm Geçmişi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: _sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final session = _sessions[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            _statusColor(session.status).withOpacity(0.15),
                        child: Icon(
                          Icons.assignment,
                          color: _statusColor(session.status),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.sessionCode,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${session.patientName} • ${_formatDate(session.sessionDate)}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildTag(
                                  session.has3dScan ? '3D Scan Var' : '3D Scan Yok',
                                  session.has3dScan,
                                ),
                                _buildTag(
                                  session.hasPlantarCsv
                                      ? 'Plantar Veri Var'
                                      : 'Plantar Veri Yok',
                                  session.hasPlantarCsv,
                                ),
                                _buildTag(
                                  session.hasInsolePhoto
                                      ? 'Fotoğraf Var'
                                      : 'Fotoğraf Yok',
                                  session.hasInsolePhoto,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${session.sessionCode} detay ekranını sonra bağlayacağız.',
                              ),
                            ),
                          );
                        },
                        child: const Text('Detay'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationPanel(AnalysisSessionViewModel latest) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Uzman Yorumu / Öneri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              latest.recommendationSummary,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Yük Dağılımı',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildKeyValueRow(
            'Sol Yük',
            _metricText(latest.leftLoadPercent, suffix: '%'),
          ),
          _buildKeyValueRow(
            'Sağ Yük',
            _metricText(latest.rightLoadPercent, suffix: '%'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Veri Durumu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildKeyValueRow('3D Tarama', latest.has3dScan ? 'Hazır' : 'Eksik'),
          _buildKeyValueRow(
              'Plantar Basınç', latest.hasPlantarCsv ? 'Hazır' : 'Eksik'),
          _buildKeyValueRow(
              'Referans Fotoğraf', latest.hasInsolePhoto ? 'Hazır' : 'Eksik'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tasarım formu bağlantısını sonra ekleyeceğiz.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
              label: const Text(
                'Tasarım Formuna Geç',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: active ? Colors.green.withOpacity(0.12) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.green.shade700 : Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildKeyValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalysisSessionViewModel {
  final String sessionCode;
  final String patientName;
  final DateTime sessionDate;
  final String status;

  final bool has3dScan;
  final bool hasPlantarCsv;
  final bool hasInsolePhoto;

  final String leftArchType;
  final String rightArchType;
  final double? leftArchHeightMm;
  final double? rightArchHeightMm;
  final double? leftFootLengthMm;
  final double? rightFootLengthMm;
  final double? leftPronatorAngleDeg;
  final double? rightPronatorAngleDeg;

  final double? peakPressureKpa;
  final double? meanPressureKpa;
  final double? contactAreaCm2;
  final double? leftLoadPercent;
  final double? rightLoadPercent;
  final double? stabilityScore;

  final String recommendationSummary;

  const AnalysisSessionViewModel({
    required this.sessionCode,
    required this.patientName,
    required this.sessionDate,
    required this.status,
    required this.has3dScan,
    required this.hasPlantarCsv,
    required this.hasInsolePhoto,
    required this.leftArchType,
    required this.rightArchType,
    required this.leftArchHeightMm,
    required this.rightArchHeightMm,
    required this.leftFootLengthMm,
    required this.rightFootLengthMm,
    required this.leftPronatorAngleDeg,
    required this.rightPronatorAngleDeg,
    required this.peakPressureKpa,
    required this.meanPressureKpa,
    required this.contactAreaCm2,
    required this.leftLoadPercent,
    required this.rightLoadPercent,
    required this.stabilityScore,
    required this.recommendationSummary,
  });
}