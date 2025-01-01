import 'package:flutter/material.dart';
import 'package:wasurenai/data/app_colors.dart';
import 'package:wasurenai/viewmodels/notification_view_model.dart';

void showNotificationSettingsModal({
  required BuildContext context,
  required String userId,
  required String situationName,
}) {
  TimeOfDay selectedTime = TimeOfDay.now();
  Map<String, bool> selectedDays = {
    "月曜日": false,
    "火曜日": false,
    "水曜日": false,
    "木曜日": false,
    "金曜日": false,
    "土曜日": false,
    "日曜日": false,
  };
  bool isAlarmOn = false; // 알람 상태 초기값

  final NotificationViewModel notificationViewModal = NotificationViewModel();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return FutureBuilder<Map<String, dynamic>>(
        future: notificationViewModal.getNotificationSettings(
          userId: userId,
          situationName: situationName,
        ),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('');
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('エラーが発生しました: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            final settings = snapshot.data!;
            final alarmDays = settings['alarmDays'] as Map<String, dynamic>;
            final alarmTime = settings['alarmTime'] as String;
            isAlarmOn = settings['isAlarmOn'] as bool;

            for (String day in selectedDays.keys) {
              if (alarmDays.containsKey(day)) {
                selectedDays[day] = alarmDays[day] as bool;
              }
            }

            if (alarmTime.isNotEmpty) {
              final timeParts = alarmTime.split(':');
              selectedTime = TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              );
            }
          }

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                    // 알람 켜기/끄기 상태 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '通知をオンにする',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                            useMaterial3: true,
                          ).copyWith(
                            colorScheme: Theme.of(context)
                                .colorScheme
                                .copyWith(outline: AppColors.lightRed),
                          ),
                          child: Switch(
                            value: isAlarmOn,
                            onChanged: (bool value) {
                              setState(() {
                                isAlarmOn = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: AppColors.lightRed,
                            inactiveTrackColor: Colors.white,
                            inactiveThumbColor: AppColors.lightRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading:
                          const Icon(Icons.access_time, color: Colors.black),
                      title: Text(
                        '通知時間: ${selectedTime.format(context)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.lightRed,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '通知する曜日',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: selectedDays.keys.map((String day) {
                        return FilterChip(
                          label: Text(
                            day,
                            style: TextStyle(
                              color: selectedDays[day]!
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          selected: selectedDays[day]!,
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.lightRed,
                          checkmarkColor: Colors.white,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedDays[day] = selected;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await notificationViewModal
                              .updateNotificationSettings(
                            userId: userId,
                            situationName: situationName,
                            alarmDays: selectedDays,
                            alarmTime:
                                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                            isAlarmOn: isAlarmOn,
                          );

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('通知設定が保存されました。'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('エラーが発生しました: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 40,
                        ),
                      ),
                      child: const Text(
                        '保存する',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
