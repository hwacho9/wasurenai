import 'package:flutter/material.dart';
import 'package:wasurenai/data/app_colors.dart';

class ReusableButtons extends StatelessWidget {
  final String settingsLabel;
  final IconData settingsIcon;
  final VoidCallback onPressed;

  final String editLabel;
  final IconData editIcon;
  final VoidCallback onEditPressed;

  final Color? settingsBackgroundColor;
  final Color? settingsForegroundColor;
  final Color? editBackgroundColor;
  final Color? editForegroundColor;

  const ReusableButtons({
    required this.settingsLabel,
    required this.settingsIcon,
    required this.onPressed,
    required this.editLabel,
    required this.editIcon,
    required this.onEditPressed,
    this.settingsBackgroundColor,
    this.settingsForegroundColor,
    this.editBackgroundColor,
    this.editForegroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(settingsIcon, size: 20), // 아이콘 크기
            label: Text(
              settingsLabel,
              style: const TextStyle(fontSize: 18), // 텍스트 크기
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor:
                  settingsBackgroundColor ?? AppColors.scaffoldBackground,
              foregroundColor: settingsForegroundColor ?? Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // 버튼 모서리 둥글게
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: onEditPressed,
            icon: Icon(editIcon, size: 20), // 아이콘 크기
            label: Text(
              editLabel,
              style: const TextStyle(fontSize: 18), // 텍스트 크기
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor:
                  editBackgroundColor ?? AppColors.scaffoldBackground,
              foregroundColor: editForegroundColor ?? Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // 버튼 모서리 둥글게
              ),
            ),
          ),
        ],
      ),
    );
  }
}
