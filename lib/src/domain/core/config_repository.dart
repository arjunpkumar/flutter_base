import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConfigRepository {
  static ConfigRepository? _instance;
  late FirebaseRemoteConfig _config;

  ConfigRepository._() {
    _config = FirebaseRemoteConfig.instance;
  }

  Future<void> initConfig() async {
    await _config.setConfigSettings(
      RemoteConfigSettings(
        minimumFetchInterval: const Duration(milliseconds: 1),
        fetchTimeout: const Duration(minutes: 2),
      ),
    );
    _config.setDefaults({});
  }

  static ConfigRepository get instance => _instance ??= ConfigRepository._();

  Future<void> syncConfig() async {
    final lastFetchTime = _config.lastFetchTime;
    if (lastFetchTime
        .isBefore(DateTime.now().subtract(const Duration(minutes: 5)))) {
      try {
        await _config.fetch();
        await _config.activate();
      } catch (err) {
        if (_config.lastFetchStatus == RemoteConfigFetchStatus.noFetchYet) {
          throw PlatformException(
            code: 'REMOTE_CONFIG_ERROR',
            details: 'RemoteConfig could not be synced!',
          );
        }
        debugPrint(err.toString());
      }
    }
  }

  // BASE URLs [DEV]
  String get restBaseUrlDev => _config.getString('rest_base_url_dev');

  String get identityServerUrlDev =>
      _config.getString('identity_server_base_url_dev');

  String get authRedirectUriDev => _config.getString('auth_redirect_uri_dev');

  // BASE URLs [QA]

  String get restBaseUrlQA => _config.getString('rest_base_url_qa');

  String get authRedirectUriQA => _config.getString('auth_redirect_uri_dev');

  String get identityServerUrlQA =>
      _config.getString('identity_server_base_url_qa');

// BASE URLs [STAGING]

  String get restBaseUrlStaging => _config.getString('rest_base_url_staging');

  String get authRedirectUriStaging =>
      _config.getString('auth_redirect_uri_dev');

  String get identityServerUrlStaging =>
      _config.getString('identity_server_base_url_staging');

  // BASE URLs [PROD]

  String get restBaseUrlProd => _config.getString('rest_base_url_prod');

  String get identityServerUrlProd =>
      _config.getString('identity_server_base_url_prod');

  String get authRedirectUriProd => _config.getString('auth_redirect_uri_prod');

  // CREDENTIALS [DEV]
  String get tenantIDDev => _config.getString('tenant_id_dev');

  String get clientIDDev => _config.getString('client_id_dev');

  String get clientSecretDev => _config.getString('client_secret_dev');

  // CREDENTIALS [QA]
  String get tenantIDQA => _config.getString('tenant_id_qa');

  String get clientIDQA => _config.getString('client_id_qa');

  String get clientSecretQA => _config.getString('client_secret_qa');

  // CREDENTIALS [STAGING]
  String get tenantIDStaging => _config.getString('tenant_id_staging');

  String get clientIDStaging => _config.getString('client_id_staging');

  String get clientSecretStaging => _config.getString('client_secret_staging');

  // CREDENTIALS [PROD]
  String get tenantIDProd => _config.getString('tenant_id_prod');

  String get clientIDProd => _config.getString('client_id_prod');

  String get clientSecretProd => _config.getString('client_secret_prod');

  /*-----------------------------Rest API Folders----------------------------*/
  /*Heads Rest Folder Urls*/

  String get restHeadsUrl => _config.getString('rest_heads_url');

  String get restEmployeeBasicDetailsUrl =>
      _config.getString('rest_employee_basic_details_url');

  String get restLeaveEntitlementUrl =>
      _config.getString('rest_leave_entitlement_url');

  String get restLeaveRequestListUrl =>
      _config.getString('rest_leave_request_list_url');

  /*-----------------------------------------------------------------*/

  // APP UPDATE RELATED CONFIGS

  int get iOSMinVersionCodeDev => _config.getInt('ios_min_version_code_dev');

  int get iOSMinVersionCodeQA => _config.getInt('ios_min_version_code_qa');

  int get iOSMinVersionCodeStaging =>
      _config.getInt('ios_min_version_code_staging');

  int get iOSMinVersionCodeProd => _config.getInt('ios_min_version_code_prod');

  int get iOSLatestVersionCodeDev =>
      _config.getInt('ios_latest_version_code_dev');

  int get iOSLatestVersionCodeQA =>
      _config.getInt('ios_latest_version_code_qa');

  int get iOSLatestVersionCodeStaging =>
      _config.getInt('ios_latest_version_code_staging');

  int get iOSLatestVersionCodeProd =>
      _config.getInt('ios_latest_version_code_prod');

  int get androidMinVersionCodeDev =>
      _config.getInt('android_min_version_code_dev');

  int get androidMinVersionCodeQA =>
      _config.getInt('android_min_version_code_qa');

  int get androidMinVersionCodeStaging =>
      _config.getInt('android_min_version_code_staging');

  int get androidMinVersionCodeProd =>
      _config.getInt('android_min_version_code_prod');

  int get androidLatestVersionCodeDev =>
      _config.getInt('android_latest_version_code_dev');

  int get androidLatestVersionCodeQA =>
      _config.getInt('android_latest_version_code_qa');

  int get androidLatestVersionCodeStaging =>
      _config.getInt('android_latest_version_code_staging');

  int get androidLatestVersionCodeProd =>
      _config.getInt('android_latest_version_code_prod');

  String get immediateUpdateTitle =>
      _config.getString('immediate_update_title');

  String get immediateUpdateMessage =>
      _config.getString('immediate_update_message');

  String get flexibleUpdateTitle => _config.getString('flexible_update_title');

  String get flexibleUpdateMessage =>
      _config.getString('flexible_update_message');

  /*Google API Keys*/
  String get googleAPIKeyAndroid => _config.getString('google_api_key_android');

  String get googleAPIKeyIOS => _config.getString('google_api_key_ios');

  String get googleAPIKeyBrowser => _config.getString('google_api_key_browser');

/*Excluded Document List*/
/*  List<String> get excludedDocumentList =>
      List<String>.from(
        jsonDecode(_config.getString('excluded_document_list')),
      );*/
}
