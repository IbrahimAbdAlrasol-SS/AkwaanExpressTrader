/// API Endpoints Configuration
/// This file contains all API endpoints used in the Tosell application

class APIEndpoints {
  // Base URLs
  static const String imageUrl = "https://uat-api.akwanexpress.com/";
  static const String baseUrl = "${imageUrl}api";

  // Map tile URL for OpenStreetMap
  static const String mapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Authentication Endpoints
  static const String authLogin = '/auth/login';
  static const String authMerchantRegister = '/auth/merchant-register';
  static const String authChangeProfile = '/auth/change-profile';
  static const String authChangePassword = '/auth/change-password';

  static const String authLogout = '/api/auth/logout';
  static const String contactSupport = '/api/auth/contact-support';

  // Dashboard/Home Endpoints
  static const String dashboardMobileMerchant = '/dashboard/mobile/merchant';

  // Order Endpoints
  static const String orderMerchant = '/order/merchant';
  static const String order = '/order';
  static String orderAdvanceStep(String code) => '/order/$code/advance-step';
  static String orderAvailable(String code) => '/order/$code/available';

  // Shipment Endpoints
  static const String shipmentMerchantMyShipments =
      '/shipment/merchant/my-shipments';
  static const String shipment = '/shipment';
  static const String shipmentPickUp = '/shipment/pick-up';
  static String shipmentById(String shipmentId) => '/shipment/$shipmentId';

  // Profile Endpoints
  static const String walletMyTransactions = '/wallet/my-transactions';

  // Location/Zone Endpoints
  static const String governorate = '/governorate';
  static const String zone = '/zone';
  static const String merchantZonesMerchant = '/merchantzones/merchant';

  // File Upload Endpoints
  static const String fileMulti = '/file/multi';

  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String myNotifications = '/notifications/my-notifications';

  // Helper Methods
  static String getFullUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }
    return baseUrl + endpoint;
  }

  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return imageUrl + imagePath;
  }

  // Validation helper
  static bool isValidUrl(String url) {
    return url.startsWith('https://') || url.startsWith('http://');
  }
}

/// API Endpoint Categories for better organization
class AuthEndpoints {
  static const String login = APIEndpoints.authLogin;
  static const String register = APIEndpoints.authMerchantRegister;
  static const String changeProfile = APIEndpoints.authChangeProfile;
  static const String changePassword = APIEndpoints.authChangePassword;

  static const String logout = APIEndpoints.authLogout;
  static const String contactSupport = APIEndpoints.contactSupport;
}

class OrderEndpoints {
  static const String merchant = APIEndpoints.orderMerchant;
  static const String order = APIEndpoints.order;
  static String advanceStep(String code) => APIEndpoints.orderAdvanceStep(code);
  static String available(String code) => APIEndpoints.orderAvailable(code);
}

class ShipmentEndpoints {
  static const String myShipments = APIEndpoints.shipmentMerchantMyShipments;
  static const String shipment = APIEndpoints.shipment;
  static const String pickUp = APIEndpoints.shipmentPickUp;
  static String byId(String shipmentId) =>
      APIEndpoints.shipmentById(shipmentId);
}

class ProfileEndpoints {
  static const String transactions = APIEndpoints.walletMyTransactions;
  static const String governorate = APIEndpoints.governorate;
  static const String zone = APIEndpoints.zone;
  static const String merchantZones = APIEndpoints.merchantZonesMerchant;
}

class DashboardEndpoints {
  static const String mobileMerchant = APIEndpoints.dashboardMobileMerchant;
}

class MapEndpoints {
  static const String tileUrl = APIEndpoints.mapTileUrl;
}

class FileEndpoints {
  static const String multi = APIEndpoints.fileMulti;
}

class NotificationEndpoints {
  static const String all = APIEndpoints.notifications;
  static const String myNotifications = APIEndpoints.myNotifications;
}
