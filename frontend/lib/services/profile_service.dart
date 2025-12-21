import '../models/profile.dart';
import '../services/auth_service.dart';
import 'api_config.dart';
import 'http_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();

  // Get user profile
  Future<UserProfile> getProfile() async {
    try {
      final token = await _authService.getToken();
      
      final data = await HttpService.get(
        ApiConfig.profileEndpoint,
        token: token,
      );

      return UserProfile.fromJson(data);
    } catch (e) {
      print('❌ ProfileService.getProfile error: $e');
      throw Exception('Failed to load profile: ${e.toString()}');
    }
  }

  // Update user profile
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      final token = await _authService.getToken();
      
      final body = {
        'firstName': profile.firstName,
        'lastName': profile.lastName,
        'email': profile.email,
        if (profile.phone != null && profile.phone!.isNotEmpty) 
          'phone': profile.phone,
        if (profile.address != null && profile.address!.isNotEmpty) 
          'address': profile.address,
        if (profile.region != null && profile.region!.isNotEmpty) 
          'region': profile.region,
        if (profile.chronicDiseases != null && profile.chronicDiseases!.isNotEmpty) 
          'chronicDiseases': profile.chronicDiseases,
        if (profile.allergies != null && profile.allergies!.isNotEmpty) 
          'allergies': profile.allergies,
        if (profile.language != null && profile.language!.isNotEmpty) 
          'language': profile.language,
      };

      final data = await HttpService.put(
        ApiConfig.profileEndpoint,
        body,
        token: token,
      );

      return UserProfile.fromJson(data);
    } catch (e) {
      print('❌ ProfileService.updateProfile error: $e');
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
}
