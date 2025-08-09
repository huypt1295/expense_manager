import 'package:flutter_common/flutter_common.dart';
import 'package:expense_manager/core/di/injector.config.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

@InjectableInit(
    includeMicroPackages: true,
    // ignoreUnregisteredTypesInPackages: ['flutter_core'],
    externalPackageModulesBefore: [
      ExternalModule(FlutterCorePackageModule),
      ExternalModule(FlutterCommonPackageModule),
      ExternalModule(FlutterResourcePackageModule),
    ])
Future<GetIt> configureDependencies() async => await tpGetIt.init();
