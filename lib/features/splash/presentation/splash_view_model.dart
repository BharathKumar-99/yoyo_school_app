import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';
import 'package:yoyo_school_app/features/splash/data/splash_repo.dart';

import '../../../config/router/navigation_helper.dart';

class SplashViewModel extends ChangeNotifier {
  UserModel? _user;
  GlobalProvider? _globalProvider;
  final SplashRepo _repo = SplashRepo();

  SplashViewModel() {
    _globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    _user = await _repo.getProfileData();
    if (_user?.onboarding != true &&
        _globalProvider?.apiCred.onboarding == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GlobalLoader.hide();
        ctx!.go(RouteNames.onboarding);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GlobalLoader.hide();
        ctx!.go(RouteNames.home);
      });
    }
  }
}
