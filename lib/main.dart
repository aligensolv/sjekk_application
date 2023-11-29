import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:sjekk_application/core/helpers/sqflite_helper.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/providers/car_provider.dart';
import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
import 'package:sjekk_application/presentation/providers/printer_provider.dart';
import 'package:sjekk_application/presentation/providers/rule_provider.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/providers/connectivity_provider.dart';
import 'package:sjekk_application/presentation/providers/login_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/splash_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/app_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import 'data/repositories/local/cache_repository_impl.dart';

const SCANBOT_SDK_LICENSE_KEY =
"A5Qo4Gb0iVtBgJzcdjFUr+NOt69e5/" +
"+Mt3sWs6sx2JC5ciedDq75bmU/w1Jq" +
"k4jPpk96cuVAjudY5TD5dPOSagzmBI" +
"O/Qe+cfnIltmexYOejv43a9RmEXKuE" +
"N3MMlcrTNz9T/jew38syDtegkPvOV/" +
"Dq+t213XBIU7Ap5viwlI7llJXxfmdx" +
"hUVrE107rFANR7dXs4RF+ingzESIlv" +
"XvXpxKOgGuqErD1vUo1K/d+Bh77782" +
"YHtTtGguonsEIG5LkmVWk2QB/V/GGx" +
"odyeUFzhFy0xRHQ+/5ZIJJZNdqHgid" +
"GztBZxSXljmO+FuyLUmnwccG5F4bac" +
"AdU5oAKmdtXQ==\nU2NhbmJvdFNESw" +
"pnZW5zb2x2Mi5uby5hcHAKMTcwMTcz" +
"NDM5OQo4Mzg4NjA3CjE5\n";

bool shouldInitWithEncryption = false;


Future<void> _initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  final customStorageBaseDirectory = await getDemoStorageBaseDirectory();

  final encryptionParams = _getEncryptionParams();

  var config = ScanbotSdkConfig(
      loggingEnabled: true,
      // Consider switching logging OFF in production builds for security and performance reasons.
      licenseKey: SCANBOT_SDK_LICENSE_KEY,
      imageFormat: ImageFormat.JPG,
      imageQuality: 80,
      useCameraX: true,
      storageBaseDirectory: customStorageBaseDirectory,
      documentDetectorMode: DocumentDetectorMode.ML_BASED,
      encryptionParameters: encryptionParams);
  try {
    await ScanbotSdk.initScanbotSdk(config);
  } catch (e) {
    Logger.root.severe(e);
  }
}

EncryptionParameters? _getEncryptionParams() {
  EncryptionParameters? encryptionParams;
  if (shouldInitWithEncryption) {
    encryptionParams = EncryptionParameters(
      password: 'SomeSecretPa\$\$w0rdForFileEncryption',
      mode: FileEncryptionMode.AES256,
    );
  }
  return encryptionParams;
}

Future<String> getDemoStorageBaseDirectory() async {
  Directory storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = (await getExternalStorageDirectory())!;
  } else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw ('Unsupported platform');
  }

  return '${storageDirectory.path}/my-custom-storage';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheRepositoryImpl.init();
  await AuthProvider.instance.detectAuthenticationState();
  await ConnectivityProvider.instance.init();
  await DatabaseHelper.instance.initDatabase();
  await ShiftProvider.instance.init();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: scaffoldColor));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState(){
    _initScanbotSdk();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return EntryPoint();
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),

        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider.instance,
        ),

        ChangeNotifierProvider<PlaceProvider>(
          create: (context) => PlaceProvider(),
        ),

        ChangeNotifierProvider<ConnectivityProvider>(
          create: (context) => ConnectivityProvider.instance,
        ),


        ChangeNotifierProvider<ViolationProvider>(
          create: (context) => ViolationProvider(),
        ),

        ChangeNotifierProvider<PrinterProvider>(
          create: (context) => PrinterProvider(),
        ),

        ChangeNotifierProvider<ShiftProvider>(
          create: (context) => ShiftProvider.instance,
        ),

        ChangeNotifierProvider<RuleProvider>(
          create: (context) => RuleProvider(),
        ),

        ChangeNotifierProvider<CarProvider>(
          create: (context) => CarProvider(),
        ),

        ChangeNotifierProvider<CreateViolationProvider>(
          create: (context) => CreateViolationProvider(),
        ),
        ChangeNotifierProvider<ViolationDetailsProvider>(
          create: (context) => ViolationDetailsProvider(),
        ),
      ],
      child: MaterialApp(
              navigatorObservers: [ScanbotCamera.scanbotSdkRouteObserver],
        title: 'Sjekk',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
