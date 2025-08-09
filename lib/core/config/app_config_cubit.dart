import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart';
import 'app_config.dart';

class ConfigCubit extends Cubit<AppConfig> {
  ConfigCubit(AppConfig initialConfig) : super(initialConfig);

  void updateConfig(AppConfig newConfig) => emit(newConfig);

  void changeLanguage(String localeCode) {
    emit(state.copyWith(localize: localeCode));
  }
}
