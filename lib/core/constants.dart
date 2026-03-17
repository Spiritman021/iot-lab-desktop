// Default calibration configs — matching web app's utils/constants.ts

class CalibrationConfig {
  final String mode;
  final List<double> values;
  final String? probe;

  const CalibrationConfig({
    required this.mode,
    required this.values,
    this.probe,
  });
}

/// pH 5-point calibration
const CalibrationConfig phConfig5 = CalibrationConfig(
  mode: '5',
  values: [1.68, 4.01, 7.01, 10.01, 12.45],
);

/// pH 3-point calibration
const CalibrationConfig phConfig3 = CalibrationConfig(
  mode: '3',
  values: [4.01, 7.01, 10.01],
);

/// EC 3-point calibration
const CalibrationConfig ecConfig3 = CalibrationConfig(
  mode: '3',
  values: [512.0, 1418.0, 1833.0],
  probe: '0.1k',
);

/// EC 2-point calibration
const CalibrationConfig ecConfig2 = CalibrationConfig(
  mode: '2',
  values: [512.0, 1833.0],
  probe: '0.1k',
);

/// EC 1-point calibration
const CalibrationConfig ecConfig1 = CalibrationConfig(
  mode: '1',
  values: [1418.0],
  probe: '0.1k',
);

/// Pagination
const int paginationLimit = 25;

/// Device active status timeout (10 seconds, matching web frontend)
const int deviceActiveTimeoutMs = 10000;

/// Check if device is online based on last MQTT message time
bool getDeviceActiveStatus(int? deviceTimeMs, int currentTimeMs) {
  if (deviceTimeMs == null || deviceTimeMs == 0) return false;
  return (deviceTimeMs + deviceActiveTimeoutMs) > currentTimeMs;
}
