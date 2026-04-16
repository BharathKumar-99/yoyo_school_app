import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_colors.dart';
import 'package:yoyo_school_app/config/theme/app_theme.dart';
import 'package:yoyo_school_app/features/homework/presentation/home_work_provider.dart';

class AddHomeworkScreen extends StatefulWidget {
  const AddHomeworkScreen({super.key});

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;

      setState(() {
        _dotCount = (_dotCount % 3) + 1;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeWorkProvider(context),
      child: Consumer<HomeWorkProvider>(
        builder: (context, value, child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: value.isLoading
                ? Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Lottie.asset(
                            AnimationAsset.yoyoWaitingText,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Building${'.' * _dotCount}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Back Button
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Title
                            Text(
                              text.set_homework,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            TextField(
                              controller: value.anythingElseController,
                              maxLines: 7,
                              decoration: InputDecoration(
                                hintText: text.anythingElseHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onLongPress: () => value.startListening(),
                              onLongPressUp: () => value.stopListening(),
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      value.speechToText.isListening
                                      ? Colors.red
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                icon: Icon(Icons.mic_rounded, size: 20),
                                label: Text(
                                  value.speechToText.isListening
                                      ? 'Stop'
                                      : 'Use Voice',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Attachment Options
                            _buildAttachmentOption(
                              title:
                                  "UPLOAD Docs:: Text book material, print off exercises etc",
                              icon: Icons.upload_file_outlined,
                              activeColor: Colors.orange,
                              isSelected: value.selectedAttachmentType == 1,
                              onTap: () => value.setAttachmentType(1),
                            ),

                            _buildAttachmentOption(
                              title: "Take a photo of document or worksheet",
                              icon: Icons.camera_alt_outlined,
                              activeColor: Colors.purple,
                              isSelected: value.selectedAttachmentType == 2,
                              onTap: () => value.setAttachmentType(2),
                            ),

                            // Checkbox
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: value.exactContent,
                                  onChanged: value.toggleExactContent,
                                  side: BorderSide(color: Colors.grey.shade500),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Tick if you want YoYo to use the content on the uploads exactly",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            bottomNavigationBar: value.isLoading
                ? SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => value.createHomework(context),
                        child: Text(text.createHomework),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required String title,
    required IconData icon,
    required Color activeColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.white,
          border: Border.all(
            color: isSelected
                ? activeColor
                : activeColor.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildInputBox(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildDatePickerBox(
    BuildContext context,
    String hint,
    HomeWorkProvider provider,
  ) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: provider.selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          provider.pickDate(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined),
            const SizedBox(width: 10),

            /// Text / Selected Date
            Text(
              provider.selectedDate != null
                  ? _formatDate(provider.selectedDate!)
                  : hint,
              style: TextStyle(
                color: provider.selectedDate != null
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _structureChip(String text, Color color, HomeWorkProvider provider) {
    return GestureDetector(
      onTap: () => provider.selectStructure(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: provider.selectedStructure.contains(text)
              ? color
              : color.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _subjectChip(String text, Color color, HomeWorkProvider provider) {
    return GestureDetector(
      onTap: () => provider.selectSubject(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: provider.selectedSubject.contains(text)
              ? color
              : color.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
