import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';

import '../../core/supabase/supabase_client.dart';
import 'get_user_details.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final client = SupabaseClientService.instance.client;

  void _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a rating")));
      return;
    }

    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter feedback")));
      return;
    }

    // 🔥 Use these values
    debugPrint("Rating: $_rating");
    debugPrint("Feedback: ${_feedbackController.text}");
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    try {
      await client.from(DbTable.feedbackTable).insert({
        'rating': _rating,
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

    // Reset
    setState(() {
      _rating = 0;
      _feedbackController.clear();
    });
  }

  Widget _buildStar(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          _rating = index;
        });
      },
      icon: Icon(
        index <= _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rate your experience",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // ⭐ Stars
          Row(children: List.generate(5, (index) => _buildStar(index + 1))),

          const SizedBox(height: 16),

          // 📝 Feedback Field
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            maxLength: 250,
            decoration: InputDecoration(
              hintText: "Tell us what you think...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🚀 Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Submit Feedback"),
            ),
          ),
        ],
      ),
    );
  }
}
