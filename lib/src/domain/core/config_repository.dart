import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConfigRepository {
  static ConfigRepository? _instance;
  late FirebaseRemoteConfig _config;

  ConfigRepository._() {
    _config = FirebaseRemoteConfig.instance;
  }

  factory ConfigRepository.instance() {
    return _instance ??= ConfigRepository._();
  }

  Future<void> initConfig() async {
    await _config.setConfigSettings(
      RemoteConfigSettings(
        minimumFetchInterval: const Duration(milliseconds: 1),
        fetchTimeout: const Duration(minutes: 2),
      ),
    );
    _config.setDefaults(_defaultConfig);
  }

  Future<void> syncConfig() async {
    final lastFetchTime = _config.lastFetchTime;
    if (lastFetchTime
        .isBefore(DateTime.now().subtract(const Duration(seconds: 1)))) {
      try {
        if (kIsWeb || !Platform.isWindows) await _config.fetch();
        await _config.activate();
      } catch (err) {
        debugPrint(err.toString());
        if ([
          RemoteConfigFetchStatus.noFetchYet,
          RemoteConfigFetchStatus.failure
        ].contains(_config.lastFetchStatus)) {
          throw PlatformException(
            code: 'REMOTE_CONFIG_ERROR',
            details: 'RemoteConfig could not be synced!',
          );
        }
      }
    }
  }

  bool isInitialFetchCompleted() {
    if (!kIsWeb && Platform.isWindows) return true;

    final lastFetchTime = _config.lastFetchTime;
    return lastFetchTime.isAfter(DateTime(1971));
  }

  // BASE URLs [DEV]
  String get restBaseUrlDev => _getString('rest_base_url_dev');

  String get identityServerUrlDev => _getString('identity_server_base_url_dev');

  String get authRedirectUriDev => _getString('auth_redirect_uri_dev');

  String get logoutRedirectUriDev => _getString('logout_redirect_uri_dev');

  // BASE URLs [QA]

  String get restBaseUrlQA => _getString('rest_base_url_qa');

  String get authRedirectUriQA => _getString('auth_redirect_uri_dev');

  String get identityServerUrlQA => _getString('identity_server_base_url_qa');

// BASE URLs [STAGING]

  String get restBaseUrlStaging => _getString('rest_base_url_staging');

  String get authRedirectUriStaging => _getString('auth_redirect_uri_dev');

  String get identityServerUrlStaging =>
      _getString('identity_server_base_url_staging');

  // BASE URLs [PROD]

  String get restBaseUrlProd => _getString('rest_base_url_prod');

  String get identityServerUrlProd =>
      _getString('identity_server_base_url_prod');

  String get authRedirectUriProd => _getString('auth_redirect_uri_prod');

  String get logoutRedirectUriProd => _getString('logout_redirect_uri_prod');

  // CREDENTIALS [DEV]
  String get tenantIDDev => _getString('tenant_id_dev');

  String get clientIDDev => _getString('client_id_dev');

  String get clientSecretDev => _getString('client_secret_dev');

  // CREDENTIALS [QA]
  String get tenantIDQA => _getString('tenant_id_qa');

  String get clientIDQA => _getString('client_id_qa');

  String get clientSecretQA => _getString('client_secret_qa');

  // CREDENTIALS [STAGING]
  String get tenantIDStaging => _getString('tenant_id_staging');

  String get clientIDStaging => _getString('client_id_staging');

  String get clientSecretStaging => _getString('client_secret_staging');

  // CREDENTIALS [PROD]
  String get tenantIDProd => _getString('tenant_id_prod');

  String get clientIDProd => _getString('client_id_prod');

  String get clientSecretProd => _getString('client_secret_prod');

  /*-----------------------------Rest API Folders----------------------------*/
  /*Heads Rest Folder Urls*/

  String get restHeadsUrl => _getString('rest_heads_url');

  String get restEmployeeBasicDetailsUrl =>
      _getString('rest_employee_basic_details_url');

  String get restLeaveEntitlementUrl =>
      _getString('rest_leave_entitlement_url');

  String get restLeaveRequestListUrl =>
      _getString('rest_leave_request_list_url');

  /*-----------------------------------------------------------------*/

  // APP UPDATE RELATED CONFIGS

  int get iOSMinVersionCodeDev => _getInt('ios_min_version_code_dev');

  int get iOSMinVersionCodeQA => _getInt('ios_min_version_code_qa');

  int get iOSMinVersionCodeStaging => _getInt('ios_min_version_code_staging');

  int get iOSMinVersionCodeProd => _getInt('ios_min_version_code_prod');

  int get iOSLatestVersionCodeDev => _getInt('ios_latest_version_code_dev');

  int get iOSLatestVersionCodeQA => _getInt('ios_latest_version_code_qa');

  int get iOSLatestVersionCodeStaging =>
      _getInt('ios_latest_version_code_staging');

  int get iOSLatestVersionCodeProd => _getInt('ios_latest_version_code_prod');

  int get androidMinVersionCodeDev => _getInt('android_min_version_code_dev');

  int get androidMinVersionCodeQA => _getInt('android_min_version_code_qa');

  int get androidMinVersionCodeStaging =>
      _getInt('android_min_version_code_staging');

  int get androidMinVersionCodeProd => _getInt('android_min_version_code_prod');

  int get androidLatestVersionCodeDev =>
      _getInt('android_latest_version_code_dev');

  int get androidLatestVersionCodeQA =>
      _getInt('android_latest_version_code_qa');

  int get androidLatestVersionCodeStaging =>
      _getInt('android_latest_version_code_staging');

  int get androidLatestVersionCodeProd =>
      _getInt('android_latest_version_code_prod');

  String get immediateUpdateTitle => _getString('immediate_update_title');

  String get immediateUpdateMessage => _getString('immediate_update_message');

  String get flexibleUpdateTitle => _getString('flexible_update_title');

  String get flexibleUpdateMessage => _getString('flexible_update_message');

  /*Google API Keys*/
  String get googleAPIKeyAndroid => _getString('google_api_key_android');

  String get googleAPIKeyIOS => _getString('google_api_key_ios');

  String get googleAPIKeyBrowser => _getString('google_api_key_browser');

/*Excluded Document List*/
/*  List<String> get excludedDocumentList =>
      List<String>.from(
        jsonDecode(_getString('excluded_document_list')),
      );*/

  String _getString(String key) {
    if (!kIsWeb && Platform.isWindows) {
      return _defaultConfig[key] as String? ?? '';
    }
    return _config.getString(key);
  }

  int _getInt(String key) {
    if (!kIsWeb && Platform.isWindows) {
      return _defaultConfig[key] as int? ?? 0;
    }
    return _config.getInt(key);
  }

  bool? _getBool(String key) {
    if (!kIsWeb && Platform.isWindows) {
      return _defaultConfig[key] as bool? ?? false;
    }
    return _config.getBool(key);
  }

  double _getDouble(String key) {
    if (!kIsWeb && Platform.isWindows) {
      return _defaultConfig[key] as double? ?? 0.0;
    }
    return _config.getDouble(key);
  }
}

final _defaultConfig = <String, dynamic>{
  "rest_base_url_tcube_staging": "https://tptimesheet.thinkpalm.info:2345/api",
};
