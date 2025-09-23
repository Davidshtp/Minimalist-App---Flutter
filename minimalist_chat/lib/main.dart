import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minimalist_chat/services/auth/auth_gate.dart';
import 'package:minimalist_chat/themes/theme_provider.dart';
import 'package:minimalist_chat/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar FCM y solicitar permisos
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  // Opcional: obtener el token del dispositivo
  String? token = await messaging.getToken();
  print('FCM Token: ' + (token ?? 'No token'));

  // Inicializar notificaciones locales
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Mostrar notificación local cuando el mensaje llega en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Notificaciones',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  // Manejar cuando el usuario toca la notificación y abre la app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notificación abierta: ${message.notification?.title}');
    // Aquí puedes navegar a una pantalla específica si lo deseas
  });
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
          theme: themeProvider.themeData,
        );
      },
    );
  }
}
