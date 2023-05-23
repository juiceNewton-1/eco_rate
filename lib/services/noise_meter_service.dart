import 'dart:developer';

import 'package:noise_meter/noise_meter.dart';

class NoiseMeterService {
  final _noiseMeter = NoiseMeter();

  static final instance = NoiseMeterService._();

  NoiseMeterService._();

  Stream<NoiseReading> getNoiseStream() {
    try {
      return _noiseMeter.noiseStream;
    } catch (e) {
      log('NoiseMeterService || $e');
      rethrow;
    }
  }
}
