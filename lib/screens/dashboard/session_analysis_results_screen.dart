import 'package:flutter/material.dart';
import 'package:oy_site/data/mock/mock_customer_analysis_repository.dart';
import 'package:oy_site/models/app_user.dart';
import 'package:oy_site/models/customer_analysis_result_model.dart';
import 'package:oy_site/models/measurement_session.dart';
import 'package:oy_site/screens/dashboard/analysis_results_view.dart';

class SessionAnalysisResultsScreen extends StatefulWidget {
  final AppUser currentUser;
  final MeasurementSession session;

  const SessionAnalysisResultsScreen({
    super.key,
    required this.currentUser,
    required this.session,
  });

  @override
  State<SessionAnalysisResultsScreen> createState() =>
      _SessionAnalysisResultsScreenState();
}

class _SessionAnalysisResultsScreenState
    extends State<SessionAnalysisResultsScreen> {
  final MockCustomerAnalysisRepository _repository =
      MockCustomerAnalysisRepository();

  bool _isLoading = true;
  String? _errorMessage;
  List<CustomerAnalysisResult> _results = [];

  @override
  void initState() {
    super.initState();
    _loadAnalyses();
  }

  Future<void> _loadAnalyses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = widget.currentUser.userId;
      if (userId == null) {
        throw Exception('Kullanıcı ID bulunamadı.');
      }

      final results = await _repository.getAnalysisHistory(userId: userId);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Analiz sonuçları yüklenirken hata oluştu: $e';
        _isLoading = false;
      });
    }
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

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ayak Sağlığı Analiz Sonuçları'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analiz Sonuçları - ${widget.session.sessionCode}'),
        backgroundColor: Colors.teal,
      ),
      body: AnalysisResultsView(
        currentUser: widget.currentUser,
        pageTitle: 'Ayak Sağlığı Analiz Sonuçları',
        results: _results,
      ),
    );
  }
}