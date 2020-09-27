


import 'package:logger/logger.dart';

class LoggerConfig {
  Logger _logger;
  LoggerConfig._(){
    this._logger = Logger();
  }

  factory LoggerConfig.instance(){
    return _internal;
  }

  static final LoggerConfig _internal = LoggerConfig._();

  static final Logger log = _internal._logger;
}