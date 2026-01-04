import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  // Map country names to country codes
  static final Map<String, String> countryToCode = {
    'Vietnam': '+84',
    'United States': '+1',
    'United Kingdom': '+44',
    'China': '+86',
    'Japan': '+81',
    'South Korea': '+82',
    'India': '+91',
    'Thailand': '+66',
    'Singapore': '+65',
    'Malaysia': '+60',
    'Indonesia': '+62',
    'Philippines': '+63',
    'Australia': '+61',
    'Canada': '+1',
    'Germany': '+49',
    'France': '+33',
    'Italy': '+39',
    'Spain': '+34',
    'Brazil': '+55',
    'Mexico': '+52',
  };

  // Default country code if location is denied or not found
  static const String defaultCountryCode = '+84';

  /// Request location permission and get current position
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get country code from coordinates
  static Future<String> getCountryCodeFromLocation() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return defaultCountryCode;
      }

      // Get placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final countryName = placemark.country ?? '';
        final isoCountryCode = placemark.isoCountryCode ?? '';

        // Try to get code from country name
        if (countryToCode.containsKey(countryName)) {
          return countryToCode[countryName]!;
        }

        // If not found, try to get from ISO code
        // This is a simplified mapping - you might want to use a more comprehensive package
        if (isoCountryCode.isNotEmpty) {
          // Common ISO to phone code mappings
          final isoToCode = {
            'VN': '+84',
            'US': '+1',
            'GB': '+44',
            'CN': '+86',
            'JP': '+81',
            'KR': '+82',
            'IN': '+91',
            'TH': '+66',
            'SG': '+65',
            'MY': '+60',
            'ID': '+62',
            'PH': '+63',
            'AU': '+61',
            'CA': '+1',
            'DE': '+49',
            'FR': '+33',
            'IT': '+39',
            'ES': '+34',
            'BR': '+55',
            'MX': '+52',
          };

          if (isoToCode.containsKey(isoCountryCode)) {
            return isoToCode[isoCountryCode]!;
          }
        }
      }

      return defaultCountryCode;
    } catch (e) {
      return defaultCountryCode;
    }
  }
}
