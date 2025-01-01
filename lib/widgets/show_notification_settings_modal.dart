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

  final NotificationViewModel _notificationViewModal = NotificationViewModel();

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
        future: _notificationViewModal.getNotificationSettings(
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
            // Firestore 데이터를 가져와 초기화
            final settings = snapshot.data!;
            final alarmDays = settings['alarmDays'] as Map<String, dynamic>;
            final alarmTime = settings['alarmTime'] as String;

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
                    const Text(
                      '通知設定',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 알림 시간 설정
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
                                  primary:
                                      AppColors.lightRed, // 선택된 시간을 강조하는 색상
                                  onPrimary: Colors.white, // 텍스트 및 아이콘 색상
                                  onSurface: Colors.black, // 기본 텍스트 색상
                                ),
                                timePickerTheme: TimePickerThemeData(
                                  dialBackgroundColor:
                                      Colors.grey[300], // 다이얼 배경 색상
                                  hourMinuteTextColor:
                                      Colors.black, // 시/분 텍스트 색상
                                  dayPeriodTextColor:
                                      AppColors.lightRed, // 오전/오후 텍스트 색상
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

                    // 요일 선택
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
                                  : Colors.black, // 선택 상태에 따른 텍스트 색상
                            ),
                          ),
                          selected: selectedDays[day]!,
                          backgroundColor: Colors.white, // 기본 배경색
                          selectedColor: AppColors.lightRed, // 선택된 상태의 배경색
                          checkmarkColor: Colors.white, // 체크 표시 색상
                          onSelected: (bool selected) {
                            setState(() {
                              selectedDays[day] = selected;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // 저장 버튼
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // 변경된 값 Firestore에 저장
                          await _notificationViewModal
                              .updateNotificationSettings(
                            userId: userId,
                            situationName: situationName,
                            alarmDays: selectedDays,
                            alarmTime:
                                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
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
                        backgroundColor: AppColors.lightRed, // 버튼 배경색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // 더 둥근 모서리
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6, // 버튼 높이 증가
                          horizontal: 40, // 버튼 너비 증가
                        ),
                      ),
                      child: const Text(
                        '保存する',
                        style: TextStyle(
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
            },
          );
        },
      );
    },
  );
}
