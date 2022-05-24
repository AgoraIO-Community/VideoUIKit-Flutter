enum Layout { grid, floating }

enum BuiltInButtons { callEnd, switchCamera, toggleCamera, toggleMic }

enum MicState { muted, unmuted }

enum CameraState { enabled, disabled }

enum Level { info, warning, error }

extension LevelExtension on Level {
  int get value {
    switch (this) {
      case Level.info:
        return 800;
      case Level.warning:
        return 900;
      case Level.error:
        return 1000;
      default:
        return 800;
    }
  }
}

enum Device { mic, camera }
