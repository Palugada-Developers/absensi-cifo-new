class AppConstants
{
    static const String baseUrl = "http://hrmv2.cmedia.co.id/";
    static const String cdcUrl = "https://dev.cdc.winteraccess.id/";
    static const String apiVersion = "api/v1";

    static const String loginUrl = "$apiVersion/auth/login";
    static const String logoutUrl = "$apiVersion/auth/logout";
    static const String profileUrl = "$apiVersion/auth/me";
    static const String retokenUrl = "$apiVersion/auth/refresh";

    static const String checkInUrl = "$apiVersion/absent/in";
    static const String checkOutUrl = "$apiVersion/absent/out";
    static const String checkReasonUrl = "$apiVersion/absent/reason";
    static const String checkStatusUrl = "$apiVersion/absent/check";

    static const String sendLocationUrl = "location-management/create";
}
