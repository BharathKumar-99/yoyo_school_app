import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/features/homework/presentation/home_work_provider.dart';

class AddHomeworkScreen extends StatelessWidget {
  const AddHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeWorkProvider(context),
      child: Consumer<HomeWorkProvider>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back Button
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded),
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

                    /// Due Date
                    _buildDatePickerBox(context, text.dueDate, value),

                    const SizedBox(height: 20),

                    /// Structures
                    Text(
                      text.structures,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: value.structures.map((item) {
                        return _structureChip(item, Colors.orange, value);
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    /// Subjects
                    Text(
                      text.subjects,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: value.subjects.map((item) {
                        return _subjectChip(item, Colors.purple, value);
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      text.anythingElse,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    _buildInputBox(
                      text.anythingElseHint,
                      value.anythingElseController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 30),

                    /// Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => value.createHomework(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          text.createHomework,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
