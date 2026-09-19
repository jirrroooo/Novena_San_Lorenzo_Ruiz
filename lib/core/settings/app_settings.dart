import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User preferences that survive restarts: theme, reading text size and
/// whether prayer reminders are scheduled.
class AppSettings extends ChangeNotifier {
  AppSettings._(
    this._prefs, {
    required this._themeMode,
    required this._textScale,
    required this._remindersEnabled,
  });

  static const _themeModeKey = 'themeMode';
  static const _textScaleKey = 'readingTextScale';
  static const _remindersKey = 'remindersEnabled';

  /// Reading text sizes offered by the text size control.
  static const List<double> textScales = [0.85, 1.0, 1.15, 1.3, 1.5, 1.75];
  static const double defaultTextScale = 1.0;

  final SharedPreferencesAsync _prefs;

  ThemeMode _themeMode;
  double _textScale;
  bool _remindersEnabled;

  ThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;
  bool get remindersEnabled => _remindersEnabled;

  static Future<AppSettings> load() async {
    final prefs = SharedPreferencesAsync();
    final themeName = await prefs.getString(_themeModeKey);
    final scale = await prefs.getDouble(_textScaleKey);

    return AppSettings._(
      prefs,
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == themeName,
        orElse: () => ThemeMode.system,
      ),
      textScale: textScales.contains(scale) ? scale! : defaultTextScale,
      remindersEnabled: await prefs.getBool(_remindersKey) ?? true,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> setTextScale(double scale) async {
    if (scale == _textScale) return;
    _textScale = scale;
    notifyListeners();
    await _prefs.setDouble(_textScaleKey, scale);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    if (enabled == _remindersEnabled) return;
    _remindersEnabled = enabled;
    notifyListeners();
    await _prefs.setBool(_remindersKey, enabled);
  }
}

/// Exposes [AppSettings] to the widget tree and rebuilds dependents on change.
class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'No AppSettingsScope found in context');
    return scope!.notifier!;
  }
}
