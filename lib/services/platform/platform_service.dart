import 'package:flutter/foundation.dart';

bool get isOnDesktop =>
    !kIsWeb &&
        switch (defaultTargetPlatform) {
              .windows || .linux || .macOS => true,
              .android || .fuchsia || .iOS => false,
        };

bool get isOnMobile =>
    !kIsWeb &&
        switch (defaultTargetPlatform) {
                    .windows || .linux || .macOS => false,
                    .android || .fuchsia || .iOS => true,
        };
