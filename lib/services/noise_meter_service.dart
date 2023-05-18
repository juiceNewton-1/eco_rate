import 'dart:developer';

import 'package:noise_meter/noise_meter.dart';

class NoiseMeterService {
  final _noiseMeter = NoiseMeter();

  Stream<NoiseReading> getNoiseStream() {
    try {
      return _noiseMeter.noiseStream;
    } catch (e) {
      log('NoiseMeterService || $e');
      rethrow;
    }
  }
}
