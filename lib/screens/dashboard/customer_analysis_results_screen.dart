import 'package:flutter/material.dart';
import 'package:oy_site/data/mock/mock_customer_analysis_repository.dart';
import 'package:oy_site/models/app_user.dart';
import 'package:oy_site/models/customer_analysis_result_model.dart';
import 'package:oy_site/screens/dashboard/analysis_results_view.dart';
import 'package:oy_site/data/repositories/supabase_analysis_repository.dart';

class CustomerAnalysisResultsScreen extends StatefulWidget {
  final AppUser currentUser;

  const CustomerAnalysisResultsScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<CustomerAnalysisResultsScreen> createState() =>
      _CustomerAnalysisResultsScreenState();
}

class _CustomerAnalysisResultsScreenState
    extends State<CustomerAnalysisResultsScreen> {
  final MockCustomerAnalysisRepository _repository =
      MockCustomerAnalysisRepository();
  final SupabaseAnalysisRepository _supabaseRepository =
      SupabaseAnalysisRepository();

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

      final supabaseResults =
          await _supabaseRepository.getAnalysisHistory(userId: userId);

      final results = supabaseResults.isNotEmpty
          ? supabaseResults
          : await _repository.getAnalysisHistory(userId: userId);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      try {
        final userId = widget.currentUser.userId;
        final fallbackResults =
            await _repository.getAnalysisHistory(userId: userId ?? 0);

        if (!mounted) return;

        setState(() {
          _results = fallbackResults;
          _isLoading = false;
        });
      } catch (_) {
        if (!mounted) return;

        setState(() {
          _errorMessage = 'Analiz sonuçları yüklenirken hata oluştu: $e';
          _isLoading = false;
        });
      }
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
          title: const Text('Analiz Sonuçlarım'),
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
        title: const Text('Analiz Sonuçlarım'),
        backgroundColor: Colors.teal,
      ),
      body: AnalysisResultsView(
        currentUser: widget.currentUser,
        pageTitle: 'Analiz Sonuçlarım',
        results: _results,
      ),
    );
  }
}