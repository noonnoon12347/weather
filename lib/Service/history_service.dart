import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class HistoryService {
  Future<void> saveSearch(String cityName, String country) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return; // ไม่ login ไม่บันทึก

    // ไม่บันทึกซ้ำภายใน 1 นาที
    await supabase.from('search_history').insert({
      'user_id': userId,
      'city_name': cityName,
      'country': country,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('search_history')
        .select()
        .eq('user_id', userId)
        .order('searched_at', ascending: false)
        .limit(20);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> deleteHistory(String id) async {
    await supabase.from('search_history').delete().eq('id', id);
  }
}