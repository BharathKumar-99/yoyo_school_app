import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';

import '../../../core/supabase/supabase_client.dart';

class OnboardingRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  void updateOnboarding() async {
    try {
      await _client
          .from(DbTable.users)
          .update({'onboarding': true})
          .eq('user_id', GetUserDetails.getCurrentUserId() ?? '');
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      ctx!.go(RouteNames.home);
    } catch (e) {
      log(e.toString());
    }
  }
}
