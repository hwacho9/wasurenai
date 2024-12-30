import 'package:flutter/material.dart';

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
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Stack(
              children: [
                // Title in the center
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Trailing widget or Switch on the right
                if (trailing != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: trailing!,
                  )
                else if (showSwitch)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Switch(
                      value: isChecked,
                      onChanged: onCheckedChange,
                    ),
                  )
                else
                  const Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
