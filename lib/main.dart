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
import 'package:sjekk_application/presentation/providers/car_type_provider.dart';
import 'package:sjekk_application/presentation/providers/color_provider.dart';
import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
import 'package:sjekk_application/presentation/providers/keyboard_input_provider.dart';
import 'package:sjekk_application/presentation/providers/printer_provider.dart';
import 'package:sjekk_application/presentation/providers/rule_provider.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/providers/connectivity_provider.dart';
import 'package:sjekk_application/presentation/providers/login_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/app_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import 'data/repositories/local/cache_repository_impl.dart';
import 'debug.dart';
import 'presentation/providers/local_violation_details_provider.dart';
import 'presentation/wrappers/connectivity_wrapper.dart';

import './presentation/providers/brand_provider.dart';



const SCANBOT_SDK_LICENSE_KEY =
"PquqNQ2OlEUfTeh9eLycKSLjUJJRoQ" +
"56T2GgChGDv8Qf1bmbzn0n+q1yCfqB" +
"VPUmtRzSzL2oquKWbYDy30BNWTNfjb" +
"WCjNxE+MCU0g+63TmFy4hErnb4ggv0" +
"RCzG1o0hgDDoY7oed+RmUgDZoKcRHD" +
"xSjULL1y1LGSMrYYdBUjHTCYge7WIq" +
"U5gvdL1T3UlLXbclJjyXnwd+Ip8/Uo" +
"EimgAjnnmNHVyMB2yu/yABkX3QmGbI" +
"YpPqdTFU6nSgbcr7KhQ4EKOa1bjVPY" +
"HrtgCPA98IRs9Yvh/ILSUZy3tBvntX" +
"+y129JBLKrkvpp4HqFybs9ROLonq35" +
"nwX61VPLeLWw==\nU2NhbmJvdFNESw" +
"pnZW5zb2x2NS5uby5hcHAKMTcwMzM3" +
"NTk5OQo4Mzg4NjA3CjE5\n";

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

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// late AndroidNotificationChannel channel;
// late AndroidNotificationChannel customIssueChannel;
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// bool isFlutterLocalNotificationsInitialized = false;


// void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse){
//   if (notificationResponse.payload != null) {
    
//   }
// }ء

// @pragma('vm:entry-point')
// void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
//   if (notificationResponse.payload != null) {
    
//   }
// }

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//       'Sjekk_Channel_1', // id
//       'Sjekk Notifications', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//       playSound: true,
//     );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   AndroidInitializationSettings androidInitializationSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   InitializationSettings initializationSettings = InitializationSettings(
//     android: androidInitializationSettings,
//   );


//   flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//     onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse
//   );


//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);


//   isFlutterLocalNotificationsInitialized = true;
// }


// Future<void> showFlutterNotification(String title, String body) async {
//   if (!kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       Random().nextInt(42949672),
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(channel.id, channel.name,
//             playSound: true,
//             channelDescription: channel.description,
//             icon: '@mipmap/ic_launcher' ,
//             importance: Importance.high,
//             priority: Priority.max),
//       ),
//     );
//   }
// }


// Future<void> requestNotificationPermission() async {
//   await Permission.notification.isDenied.then((value) async {
//     if (value) {
//       Permission.notification.request();
//     }
//   });
// }


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheRepositoryImpl.init();
  await AuthProvider.instance.detectAuthenticationState();
  await ConnectivityProvider.instance.init();
  await DatabaseHelper.instance.initDatabase();
  await ShiftProvider.instance.init();

  // await requestNotificationPermission();
  // await setupFlutterNotifications();

//   Socket socket = io('http://10.0.2.2:4000', 
//     OptionBuilder()
//       .setTransports(['websocket']) // for Flutter or Dart VM
//       .disableAutoConnect()  // disable auto-connection
//       .build()
//   );


// socket.onConnect((data){
//   print('connected');
// });
// socket.onError((data){
//   print(data);
// });
// socket.connect();
// socket.onDisconnect((_) => print('disconnect'));

// socket.on('notification', (data) async{

//   pinfo('data is ${(data['notification']['title'], data['notification']['body'])}');
//   // await showFlutterNotification(data['notification']['title'], data['notification']['body']);
// });


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
        ChangeNotifierProvider<LocalViolationDetailsProvider>(
          create: (context) => LocalViolationDetailsProvider(),
        ),
        ChangeNotifierProvider<KeyboardInputProvider>(
          create: (context) => KeyboardInputProvider(),
        ),
        ChangeNotifierProvider<ColorProvider>(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider<CarTypeProvider>(
          create: (context) => CarTypeProvider(),
        ),
        ChangeNotifierProvider<BrandProvider>(
          create: (context) => BrandProvider(),
        ),
      ],
      child: MaterialApp(
              navigatorObservers: [ScanbotCamera.scanbotSdkRouteObserver],
        title: 'Sjekk',
        theme: appTheme,
        // navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: ConnectivityWrapper(),
        // home: TempTest(),
      ),
    );
  }
}
