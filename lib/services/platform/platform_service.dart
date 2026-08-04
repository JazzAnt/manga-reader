import 'package:flutter/foundation.dart';

/// Returns true if app is on a desktop platform (windows / linus / macOS).
bool get isOnDesktop =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      .windows || .linux || .macOS => true,
      .android || .fuchsia || .iOS => false,
    };

/// Returns true if app is on a mobile platform (android / fuchsia / iOS).
bool get isOnMobile =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      .windows || .linux || .macOS => false,
      .android || .fuchsia || .iOS => true,
    };
