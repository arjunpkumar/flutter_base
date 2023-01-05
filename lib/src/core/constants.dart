import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart' as intl;
import 'package:thinkhub/config.dart';
import 'package:thinkhub/src/utils/network_auth_interceptor.dart';
import 'package:thinkhub/src/utils/network_usage_interceptor.dart';

const androidPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.synergymarine.thinkhub';
const iosAppStoreUrl =
    'https://itunes.apple.com/in/app/ahoy-seafarer-professional-app/id1477968777';

const int maxFailuresCount = 3;

const whiteListDocumentExtensions = [
  '.pdf',
  '.doc',
  '.docx',
  '.jpg',
  '.jpeg',
  '.png'
];

const whiteListDocumentMimeTypes = [
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'image/jpeg',
  'image/png',
  'image/jpg',
  'application/pdf'
];

const whiteListDocumentUtiTypes = [
  'public.image',
  'public.jpeg',
  'public.png',
  'com.adobe.pdf',
  'com.microsoft.word.doc',
  'com.microsoft.word.wordml',
];

const whiteListImageExtensions = ['.jpg', '.jpeg', '.png'];

const whiteListImageMimeTypes = [
  'image/jpeg',
  'image/png',
  'image/jpg',
];

const whiteListedAudioMimeTypes = ['audio/*'];

const whiteListAudioExtensions = [
  '.m4a',
  '.mp3',
  '.wav',
  '.wma',
  '.aac',
  'aud'
];

const whiteListVideoExtensions = [
  '.mp4',
];

const whiteListImageUtiTypes = [
  'public.image',
  'public.jpeg',
  'public.png',
];

const whiteListedAudioUtiTypes = [
  'public.audio',
  'public.mp3',
  'com.real.realaudio',
  'public.ulaw-audio',
  'public.au-audio',
  'public.aifc-audio',
  'public.midi-audio',
  'public.downloadable-sound',
  'com.apple.coreaudio-format',
  'public.ac3-audio',
  'com.digidesign.sd2-audio',
  'com.microsoft.thinkhubform-audio',
  'com.soundblaster.soundfont',
];

const whiteListDocumentExtensionsForChat = [
  '.pdf',
  '.xls',
  '.xlsx',
  'doc',
  'docx',
  'aac'
];

const whiteListVideoExtensionsForChat = [
  '.webm',
  '.mkv',
  '.flv',
  '.mp4',
  '.mpg'
];

const whiteListPdfMimeType = [
  'application/pdf',
];

const whiteListPdfUtiType = [
  'com.adobe.pdf',
];

//Fire base dynamic link
const kUriPrefix = 'https://thinkpalm.page.link';
const kWebUrl = 'https://thinkpalm.com';
const kBundleId = 'com.thinkpalm.thinkhub';

///Kb, Mb and Gb in Bytes
const kbInBytes = 1024;
const mbInBytes = 1048576;
const gbInBytes = 1073741824;

class Units {
  Units._();

  static const double _kPaddingUnit = 4.0;
  static const double kXSPadding = _kPaddingUnit;
  static const double kSPadding = 2 * _kPaddingUnit;
  static const double kMPadding = 3 * _kPaddingUnit;
  static const double kStandardPadding = 4 * _kPaddingUnit;
  static const double kLPadding = 5 * _kPaddingUnit;
  static const double kXLPadding = 6 * _kPaddingUnit;
  static const double kXXLPadding = 7 * _kPaddingUnit;
  static const double kXXXLPadding = 8 * _kPaddingUnit;

  static const double kCardBorderRadius = 12;
  static const double kCardElevation = 4;

  static const double kButtonBorderRadius = 8;
  static const double kButtonElevation = 4;
  static const double kButtonHeight = 44;

  static const double kExpandedHeight = 190;
  static const double kMinExpandedHeight = 100;
  static const double kVeryMinExpandedHeight = 80;
  static const double kContentOffSet = 50;
  static const double kAppBarHeight = 64;

  static const double kLoaderHeight = 24;
  static const double kAppIconSize = 24;
  static const double kAppIconSizeSmall = 18;
}

class AppIcons {
  AppIcons._();

  static const String kBgSplash = 'lib/assets/images/bg_splash.svg';
}

class APIEndpoints {
  // AUTH
  static final String _authBaseUrl = Config.appFlavor.identityServerBaseUrl;
  static final String authUrl = '$_authBaseUrl/connect/authorize';
  static final String authTokenUrl = '$_authBaseUrl/connect/token';
  static final String logoutUrl = '$_authBaseUrl/connect/endsession';
  static final String loginUrl = '$_authBaseUrl/Account/Login';
  static final String changePasswordUrl = '$_authBaseUrl/Manage/ChangePassword';

  static final String userinfo = '$_authBaseUrl/connect/userinfo';
}

class NetworkClient {
  NetworkClient._();

  static final dio.BaseOptions _options = dio.BaseOptions(
    connectTimeout: 50000,
    receiveTimeout: 50000,
  );

  static dio.Dio? _dio;

  static dio.Dio get dioInstance {
    if (_dio == null) {
      _dio = dio.Dio(_options);
      _dio!.interceptors.add(NetworkUsageInterceptor());
      _dio!.interceptors.add(NetworkAuthInterceptor());
    }
    return _dio!;
  }
}

class DeepLinkType {
  static const String profile = 'profile';
}

final dateFormat = intl.DateFormat("dd-MM-yyyy");
final timeFormat = intl.DateFormat("hh:mm aa");

const String docx = ".docx";
const String xls = ".xls";
