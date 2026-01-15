import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/feedback/presentation/feedback_textfield.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

class FeedbackRating extends StatefulWidget {
  final Language language;
  final bool isPositive;
  const FeedbackRating({
    super.key,
    required this.language,
    required this.isPositive,
  });

  @override
  State<FeedbackRating> createState() => _FeedbackRatingState();
}

class _FeedbackRatingState extends State<FeedbackRating> {
  final client = SupabaseClientService.instance.client;
  int rating = 0;
  Widget buildStar(int index) {
    return IconButton(
      onPressed: () {
        rating = index;
        _submitFeedback();
        context.pop();
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          context: ctx!,
          builder: (c) => FeedbackTextfield(
            language: widget.language,
            isPositive: widget.isPositive,
            star: rating,
          ),
        );
      },
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 32,
      ),
    );
  }

  void _submitFeedback() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    try {
      await client.from(DbTable.feedbackTable).insert({
        'rating': rating,
        'user_id': userId,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: widget.language.gradient?.first,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Awesome!',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: Colors.white),
          ),
          Text(
            'Please rate YoYo out of 5',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => buildStar(index + 1)),
          ),
        ],
      ),
    );
  }
}
