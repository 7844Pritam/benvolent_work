class ApiEndPoints {
  static const BASEURL = "https://crm.benevolentrealty.com/api/v3";
  /////////
  static const LOGIN_URL = "/login";
  static const SIGNUP_URL = '/registration';

  static const RESET_PASSWORD_URL = "/reset-password";
  static const RESET_PASSWORD_VERIFY_URL = "/reset-password-verify";
  static const CHANGE_PASSWORD_URL = "/change-password";
  static const DASHBOARD_URL = "/dashboard";
  static const LEADS_URL = "/leads";
  static const GET_AGENTS = "/agents";
  static const GET_STATUS = "/status";
  static const GET_CAMPAIGNS = "/campaigns";
  static const GET_SOURCE = "/source";
  static const GET_SUB_STATUS = "/sub-status";
  //
  static const GET_COLD_CALLS = "/coldCalls";
  static const GET_COLD_CALLS_CONVERTS = "/coldCallConverts";
  static const GET_SOURCE_COLD_CALLS_DETAILS = "/coldCallDetails/591";

  static const GET_DEVICE_NOTIFICATIONS = "/getDeviceNotifications";
  static const DELETE_DEVICE_NOTIFICATIONS = "/deleteDeviceNotifications";

  static const String _GET_LEAD_BY_ID_BASE = '/getLead';
  static String getLeadById(int id) => '$_GET_LEAD_BY_ID_BASE/$id';

  // remaining api
  static const String COLD_CALL_CONVERTTO_LEAD = '/coldCallConvetToLead/1';
  static String changeColdCallStatus(int id) => '/changeColdCallStatus/$id';
  static String leadUpdateAdditionalPhone(int id) =>
      '/lead_update_additional_phone/$id';

  static String ADD_NOTES = '/addLeadComment';

  static const CAMPAIGN_SUMMARY_REPORT_URL = "/campaign-summary-report";
}
