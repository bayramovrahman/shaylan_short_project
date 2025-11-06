import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';

late SharedPreferences prefs;

final tokenProvider = createPrefProvider<String>(
  prefs: (_) => prefs,
  prefKey: "authToken",
  defaultValue: '',
);

final selectedTerminalProvider = createPrefProvider<String>(
  prefs: (_) => prefs,
  prefKey: "terminal",
  defaultValue: '',
);
