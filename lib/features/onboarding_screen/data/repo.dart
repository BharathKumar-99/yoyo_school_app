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
      final userId = GetUserDetails.getCurrentUserId() ?? '';
      print('📝 [Onboarding] Updating onboarding for user: $userId');

      final res = await _client
          .from(DbTable.users)
          .update({'onboarding': true})
          .eq('user_id', userId);

      print('✅ [Onboarding] Successfully updated onboarding to true res:$res');

      // Verify the update by re-fetching
      final verifyData = await _client
          .from(DbTable.users)
          .select('onboarding')
          .eq('user_id', userId)
          .maybeSingle();

      print(
        '🔍 [Onboarding] Verification - onboarding value in DB: ${verifyData?['onboarding']}',
      );

      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      ctx!.go(RouteNames.home);
    } catch (e) {
      print('❌ [Onboarding] Error updating onboarding: $e');
      log(e.toString());
    }
  }
}
