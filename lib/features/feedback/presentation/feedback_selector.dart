import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/features/feedback/presentation/feedback_rating.dart';
import 'package:yoyo_school_app/features/feedback/presentation/feedback_textfield.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

class FeedbackSelector extends StatelessWidget {
  final Language language;
  const FeedbackSelector({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: language.gradient?.first,
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
            'Hey!',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: Colors.white),
          ),
          Text(
            'Are you enjoying YoYo?',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    context: ctx!,
                    builder: (c) =>
                        FeedbackRating(language: language, isPositive: true),
                  );
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        '😃 YES!',
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pop();
                  showModalBottomSheet(
                    scrollControlDisabledMaxHeightRatio:
                        MediaQuery.sizeOf(context).height * 0.6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    context: ctx!,
                    builder: (c) => FeedbackTextfield(
                      language: language,
                      isPositive: false,
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        '😩 NO',
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
