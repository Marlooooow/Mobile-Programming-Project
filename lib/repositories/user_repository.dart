import '../models/user_model.dart';
import '../services/supabase_service.dart';

class UserRepository {
  final SupabaseService _supabaseService;

  UserRepository({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      return await _supabaseService.getUserProfile(userId);
    } catch (_) {
      return null;
    }
  }
}