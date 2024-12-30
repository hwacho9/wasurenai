import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isChecked;
  final ValueChanged<bool>? onCheckedChange;
  final VoidCallback onTap;
  final bool showSwitch;
  final Widget? trailing; // trailing 매개변수 추가

  const CustomListTile({
    required this.title,
    required this.subtitle,
    this.isChecked = false,
    this.onCheckedChange,
    required this.onTap,
    this.showSwitch = true,
    this.trailing, // 추가된 trailing
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          trailing: trailing ??
              (showSwitch
                  ? Switch(
                      value: isChecked,
                      onChanged: onCheckedChange,
                    )
                  : Icon(Icons.arrow_forward_ios, color: Colors.grey)),
          onTap: onTap,
        ),
      ),
    );
  }
}
