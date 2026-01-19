import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

class FeedbackTextfield extends StatefulWidget {
  final Language language;
  final bool isPositive;
  final int? star;
  const FeedbackTextfield({
    super.key,
    required this.language,
    required this.isPositive,
    this.star,
  });

  @override
  State<FeedbackTextfield> createState() => _FeedbackTextfieldState();
}

class _FeedbackTextfieldState extends State<FeedbackTextfield> {
  final TextEditingController _feedbackController = TextEditingController();
  final client = SupabaseClientService.instance.client;

  void _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter feedback")));
      return;
    }

    final userId = GetUserDetails.getCurrentUserId() ?? "";
    try {
      await client.from(DbTable.feedbackTable).insert({
        'rating': widget.isPositive ? widget.star : null,
        'feedback': _feedbackController.text,
        'user_id': userId,
      });
    } catch (e) {
      log(e.toString());
    }
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback ❤️")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardOpen = bottomInset > 0;

    return Container(
      height: keyboardOpen
          ? MediaQuery.of(context).size.height * 0.9
          : MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: widget.language.gradient?.first,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.isPositive ? 'Thank you' : 'Oh no..',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(color: Colors.white),
            ),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              maxLength: 250,
              decoration: InputDecoration(
                counter: Container(),
                filled: true,
                fillColor: Colors.white,
                hintText: widget.isPositive
                    ? "Please tell us why you rated us ${widget.star} star"
                    : "Please tell us how we can improve for you",
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black26,
                ),
                onPressed: () async => _submitFeedback(),
                child: Text(
                  'SEND',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (keyboardOpen)
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
          ],
        ),
      ),
    );
  }
}
