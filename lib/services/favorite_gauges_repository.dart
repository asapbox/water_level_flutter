import 'package:level_river/blocs/app/app_cubit.dart';

class FavoriteGaugesRepository {
  static AppCubit? appCubit;

  FavoriteGaugesRepository(AppCubit appCubit) {
    FavoriteGaugesRepository.appCubit ??= appCubit;
  }

  static bool isFavorite(gaugeStation) {
    return appCubit!.isFavorite(gaugeStation);
  }
}
