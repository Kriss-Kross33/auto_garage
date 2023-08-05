import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification_service/push_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

/// {@template push_notification_service}
/// Repository which manages the push notifications.
/// {@endtemplate}
class PushNotificationService {
  /// {@macro push_notification_repository}
  PushNotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
  })  : messaging = messaging ?? FirebaseMessaging.instance,
        flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin ??
            FlutterLocalNotificationsPlugin() {
    onTapForegroundNotification = StreamController<PushNotification>();
  }

  final FirebaseMessaging messaging;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationDetails? platformChannelSpecifics;
  StreamController<PushNotification>? onTapForegroundNotification;

  /// Requesting permission on iOS
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Flutter Local Notifications settings
  Future<void> init() async {
    ///Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    ///Initialization Settings for iOS
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    ///InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    platformSpecificInitialization();
  }

  /// on Select Notification
  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      final _notification = PushNotification.fromJson(jsonDecode(payload));
      final _payload = _notification.payload;

      if (_payload!.id != null) {
        onTapForegroundNotification?.add(_notification);
      }
    }
  }

  /// platform specific initialization for Displaying Notifications
  void platformSpecificInitialization() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  /// Prompts the user for notification permissions.
  Future<NotificationSettings> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    return settings;
  }

  /// Returns a Stream that is called when an incoming FCM payload is received whilst
  /// the Flutter instance is in the foreground.
  Stream<PushNotification> get onMessage {
    return FirebaseMessaging.onMessage.map(
      (message) {
        return PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data.containsKey('payload')
              ? Payload.fromJson(message.data["payload"])
              : null,
        );
      },
    );
  }

  /// Returns a [Stream] that is called when a user presses a notification message displayed
  /// via FCM.
  Stream<PushNotification> get onMessageOpenedApp {
    return FirebaseMessaging.onMessageOpenedApp.map(
      (message) {
        return PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data.containsKey('payload')
              ? Payload.fromJson(message.data["payload"])
              : null,
        );
      },
    );
  }

  /// If the application has been opened from a terminated state via a [RemoteMessage]
  /// (containing a [Notification]), it will be returned, otherwise it will be `null`.
  Future<PushNotification?> onTerminatedApp() async {
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        payload: Payload.fromJson(
          jsonDecode(initialMessage.data.containsKey('payload')
              ? initialMessage.data["payload"]
              : '{}'),
        ),
      );
      return notification;
    }
    return null;
  }

  /// Returns the default FCM token for this device.
  Future<String?>? getToken() {
    try {
      return messaging.getToken();
    } catch (e) {
      throw GetTokenException();
    }
  }

  /// Deletes the default FCM token for this device.
  Future<void>? deleteToken() {
    try {
      return messaging.deleteToken();
    } catch (e) {
      throw DeleteTokenException();
    }
  }

  /// Fires when a new FCM token is generated.
  Stream<String>? get onTokenRefresh {
    return messaging.onTokenRefresh;
  }

  Future<void> showPushNotification(PushNotification pushNotification) async {
    /// Showing Notification in OS Notification bar
    await flutterLocalNotificationsPlugin.show(
      pushNotification.hashCode,
      pushNotification.title,
      pushNotification.body,
      platformChannelSpecifics,
      payload: jsonEncode(pushNotification.toJson()),
    );
  }

  /// Subscribes to given topic
  Future<void> subscribeToTopics({required String topic}) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
