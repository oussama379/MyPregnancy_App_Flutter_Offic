// this class is responsible for dependency injection using the package getIT

import 'package:get_it/get_it.dart';
import 'package:ma_grossesse/preferencesService.dart';
import 'package:ma_grossesse/ui/pages/home/services/homeServices.dart';
import 'package:ma_grossesse/ui/pages/information/repo/monthRepo.dart';
import 'package:ma_grossesse/ui/pages/login/loginServices.dart';
import 'package:ma_grossesse/ui/pages/passwordAuth/passwordAuthServices.dart';
import 'package:ma_grossesse/ui/pages/phr/repo/phrRepo.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/pressureRepo.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';
import 'package:ma_grossesse/ui/shared/toasts.dart';

final locator  = GetIt.instance;

void setupDependencyInjection(){
  locator.registerLazySingleton<PreferencesService>(() => PreferencesService());
  locator.registerLazySingleton<toastMsg>(() => toastMsg());
  locator.registerLazySingleton<PasswordAuthServices>(() => PasswordAuthServices());
  locator.registerLazySingleton<LoginServices>(() => LoginServices());
  locator.registerLazySingleton<MonthDao>(() => MonthDao());
  locator.registerLazySingleton<PhrDao>(() => PhrDao());
  locator.registerLazySingleton<HomeServices>(() => HomeServices());
  locator.registerLazySingleton<WeightRepo>(() => WeightRepo());
  locator.registerLazySingleton<PressureRepo>(() => PressureRepo());
}