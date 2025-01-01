import 'package:flutter/material.dart';
import 'package:wasurenai/data/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isChecked;
  final ValueChanged<bool>? onCheckedChange;
  final VoidCallback onTap;
  final bool showSwitch;
  final Widget? trailing; // trailing 매개변수 추가
  final Color? color;

  const CustomListTile({
    required this.title,
    required this.subtitle,
    this.isChecked = false,
    this.onCheckedChange,
    required this.onTap,
    this.showSwitch = true,
    this.trailing, // 추가된 trailing
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // InkWell for onTap event
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Center(
                  child: Text(
                    title,
                    maxLines: 1, // 최대 줄 수를 1로 설정
                    overflow: TextOverflow.ellipsis, // 글자가 넘치면 "..."으로 표시
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Trailing widget or Switch
            if (trailing != null)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: trailing!,
              )
            else if (showSwitch)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  ignoring: false,
                  child: Theme(
                    data: ThemeData(
                      useMaterial3: true,
                    ).copyWith(
                      colorScheme: Theme.of(context)
                          .colorScheme
                          .copyWith(outline: AppColors.lightRed),
                    ),
                    child: Switch(
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.lightRed,
                      inactiveTrackColor: Colors.white,
                      inactiveThumbColor: AppColors.lightRed,
                      value: isChecked,
                      onChanged: onCheckedChange,
                    ),
                  ),
                ),
              )
            else
              const Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
