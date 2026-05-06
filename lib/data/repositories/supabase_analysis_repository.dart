import 'package:oy_site/models/customer_analysis_result_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAnalysisRepository {
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<CustomerAnalysisResult>> getAnalysisHistory({
    required int userId,
  }) async {
    final response = await _client
        .from('analysis_results')
        .select()
        .eq('user_id', userId)
        .order('analysis_date', ascending: false);

    return (response as List<dynamic>)
        .map((item) => CustomerAnalysisResult.fromMap(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  Future<CustomerAnalysisResult?> getLatestAnalysis({
    required int userId,
  }) async {
    final response = await _client
        .from('analysis_results')
        .select()
        .eq('user_id', userId)
        .order('analysis_date', ascending: false)
        .limit(1);

    final list = response as List<dynamic>;

    if (list.isEmpty) return null;

    return CustomerAnalysisResult.fromMap(
      Map<String, dynamic>.from(list.first as Map),
    );
  }

  Future<void> saveAnalysisResult({
    required int userId,
    required CustomerAnalysisResult result,
  }) async {
    await _client.from('analysis_results').insert(
          result.toMap(userId: userId),
        );
  }

  Future<void> upsertAnalysisResult({
    required int userId,
    required CustomerAnalysisResult result,
  }) async {
    await _client.from('analysis_results').upsert(
          result.toMap(userId: userId),
          onConflict: 'user_id,session_code',
        );
  }

  Future<void> deleteAnalysisResult({
    required int analysisResultId,
  }) async {
    await _client
        .from('analysis_results')
        .delete()
        .eq('id', analysisResultId);
  }
}