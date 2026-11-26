class AppConstants {
  static const String SUCCESS_TRUE = '1';
  static const String STATUS_TRUE = 'true';

  // Api Response Constants
  static const String SUCCESS = 'success';
  static const String STATUS = 'status';
  static const String MESSAGE = 'message';
  static const String RESULT = 'result';
  static const String DATA = 'data';

  // Shared Preferences Keys
  static const String PREF_MOBILE_NUMBER = "mobile_number";
  static const String PREF_IS_LOGGED_IN = "is_logged_in";
  static const String PREF_USER_DATA = "user_data";
  static const String PREF_KEEP_SIGNED_IN = "keep_signed_in";

  /* Api URLS*/
  static const String BASE_URL = "https://apinurse.koderztech.cloud/api";
  static const String LOGIN_API = "$BASE_URL/auth/loginUser";
  static const String USER_REGISTRATION_API = "$BASE_URL/auth/registerUser";
  static const String VERIFY_OTP_API = "$BASE_URL/auth/verifyEmailOtp";
  static const String BANNER_LIST_API = "$BASE_URL/getBanner";
  static const String CATEGORY_LIST_API = "$BASE_URL/admin/getCategory";
  static const String ALL_VACCINES_LIST_API = "$BASE_URL/admin/getVaccine";
  static const String ADD_FAMILY_MEMBER_API = "$BASE_URL/admin/createFamilyMember";
  static const String FETCH_FAMILY_MEMBER_BY_ID_API = "$BASE_URL/admin/getFamilyMemberById";
  static const String FETCH_FAMILY_MEMBER_API = "$BASE_URL/admin/getFamilyMember";
  static const String GET_CONSENT_DATA_API = "$BASE_URL/admin/getConsent";
  static const String GET_CONSENT_DATA_BY_ID_API = "$BASE_URL/admin/getConsentById";
  static const String NOTIFICATIONS_API = "$BASE_URL/admin/getNotifications";
  static const String READ_NOTIFICATION_API = "$BASE_URL/admin/markNotificationRead";
  static const String FETCH_INVOICE_API = "$BASE_URL/admin/getInvoiceById";
}
