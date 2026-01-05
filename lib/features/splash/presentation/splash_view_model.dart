import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/app.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';
import 'package:yoyo_school_app/features/splash/app_config_model.dart';
import 'package:yoyo_school_app/features/splash/data/splash_repo.dart';

import '../../../config/router/navigation_helper.dart';
import '../../common/presentation/app_update_screen.dart';

class SplashViewModel extends ChangeNotifier {
  UserModel? _user;
  GlobalProvider? _globalProvider;
  final SplashRepo _repo = SplashRepo();
  AppConfigModel? model;
  bool showUpdate = false;
  SplashViewModel() {
    _globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    model = await _repo.getAppConfig();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _user = await _repo.getProfileData();
    if (_user != null) {
      globalProvider = await GlobalProvider.create();
    }
    if (!(_user?.isTester ?? false)) {
      if (model?.isMaintainance ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GlobalLoader.hide();
          ctx!.go(RouteNames.appMaintenance);
        });

        return;
      }
      final storeVersion = model?.appVersion;
      final appVersion = packageInfo.version;

      if (storeVersion != null &&
          isUpdateRequired(
            storeVersion: storeVersion,
            appVersion: appVersion,
          )) {
        showUpdate = true;
      }
    }

    if (_user?.onboarding != true &&
        _globalProvider?.apiCred?.onboarding == true) {
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
    if (showUpdate) {
      GlobalLoader.showWidget(AppUpdateScreen());
    }
  }

  bool isUpdateRequired({
    required String storeVersion,
    required String appVersion,
  }) {
    final store = storeVersion.split('.').map(int.parse).toList();
    final app = appVersion.split('.').map(int.parse).toList();

    final maxLen = store.length > app.length ? store.length : app.length;

    for (int i = 0; i < maxLen; i++) {
      final s = i < store.length ? store[i] : 0;
      final a = i < app.length ? app[i] : 0;

      if (s > a) return true; // update required
      if (s < a) return false; // app is newer
    }
    return false; // same version
  }
}
