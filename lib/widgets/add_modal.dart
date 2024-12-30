import 'package:flutter/material.dart';
import 'package:wasurenai/data/app_colors.dart';

class AddModal extends StatelessWidget {
  final String title;
  final List<String> hints; // 입력 필드에 대한 힌트 리스트
  final List<String> labels; // 각 입력 필드 위에 표시될 텍스트 리스트
  final String buttonText;
  final void Function(List<String> values) onSubmit;

  const AddModal({
    required this.title,
    required this.hints,
    required this.labels,
    required this.buttonText,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controllers =
        List.generate(hints.length, (_) => TextEditingController());

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input Fields with Labels
          ...hints.asMap().entries.map((entry) {
            final index = entry.key;
            final hint = entry.value;
            final label = labels.isNotEmpty ? labels[index] : '';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // Label Text
                  if (label.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  // Input Field
                  TextField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.lightRed),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: hint,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 20),

          // Submit Button
          ElevatedButton(
            onPressed: () {
              final values = controllers.map((c) => c.text).toList();
              if (values.any((value) => value.isEmpty)) return;
              onSubmit(values);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
