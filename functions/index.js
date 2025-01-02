const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.sendDailyAlarms = onSchedule("every 10 minutes", async (event) => {
  try {
    console.log("Starting scheduled function to send alarms...");

    // `isAlarmOn`이 true인 사용자만 가져오기
    const usersSnapshot = await db.collection("Users").where("isAlarmOn", "==", true).get();
    if (usersSnapshot.empty) {
      console.log("No users with isAlarmOn === true found.");
      return;
    }

    console.log(`${usersSnapshot.size} users with isAlarmOn === true found.`);

    const now = new Date();
    const jstOffset = 9 * 60 * 60 * 1000; // JST는 UTC보다 9시간 빠름
    const jstDate = new Date(now.getTime() + jstOffset);

    const currentHour = jstDate.getHours().toString().padStart(2, "0");
    const currentMinute = jstDate.getMinutes().toString().padStart(2, "0");
    const currentTime = `${currentHour}:${currentMinute}`;

    // 10분 후의 시간 계산
    const next10MinutesDate = new Date(jstDate.getTime() + 10 * 60 * 1000);
    const nextHour = next10MinutesDate.getHours().toString().padStart(2, "0");
    const nextMinute = next10MinutesDate.getMinutes().toString().padStart(2, "0");
    const nextTime = `${nextHour}:${nextMinute}`;

    const currentDay = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"][jstDate.getDay()];

    console.log(`Current time: ${currentTime}, Next 10-min time: ${nextTime}`);

    // 사용자별로 상황 데이터 가져오기
    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const situationsSnapshot = await db.collection("Users").doc(userId).collection("situations").get();

      console.log(`${situationsSnapshot.size} situations found for user ${userId}.`);

      if (!situationsSnapshot.empty) {
        for (const situationDoc of situationsSnapshot.docs) {
          const data = situationDoc.data();
          const {alarmTime, alarmDays, isAlarmOn, name} = data;

          console.log(`${data.name}: ${alarmTime}, ${alarmDays}, ${isAlarmOn}`);
          // 알림 조건: isAlarmOn이 true, 현재 요일이 활성화됨, alarmTime이 현재 ~ 10분 사이에 포함됨
          if (
            isAlarmOn &&
            alarmDays[currentDay] &&
            alarmTime >= currentTime &&
            alarmTime < nextTime
          ) {
            const message = {
              notification: {
                title: "MOTTAからのリマインダー",
                body: `「${name}」の予定があります！忘れ物に注意してください。`,
              },
              topic: userId, // 사용자 ID로 구독한 토픽
            };

            await admin.messaging().send(message);
            console.log(`Sent alarm to user ${userId} for situation ${name}`);
          }
        }
      }
    }
  } catch (error) {
    console.error("Error in scheduled function:", error);
  }
});
