import 'package:flutter/material.dart';
import 'package:wasurenai/data/app_colors.dart';

class AddModal extends StatelessWidget {
  final String title;
  final List<String> hints; // 입력 필드에 대한 힌트 리스트
  final List<String> labels; // 각 입력 필드 위에 표시될 텍스트 리스트
  final String buttonText;
  final void Function(List<String> values) onSubmit;
  final List<String>? initialValues; // 초기값 리스트

  const AddModal({
    required this.title,
    required this.hints,
    required this.labels,
    required this.buttonText,
    required this.onSubmit,
    this.initialValues, // 초기값 추가
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controllers = List.generate(
      hints.length,
      (index) => TextEditingController(
        text: initialValues != null && index < initialValues!.length
            ? initialValues![index]
            : '', // 초기값 설정
      ),
    );

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Text
                  if (label.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
              backgroundColor: AppColors.lightRed, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // 더 둥근 모서리
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 6, // 버튼 높이 증가
                horizontal: 40, // 버튼 너비 증가
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 15, // 글자 크기 약간 증가
                fontWeight: FontWeight.bold,
                color: Colors.white, // 텍스트 색상을 흰색으로
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
