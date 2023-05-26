abstract class Constants {
  // Outlook
  static const officeEventSubject = '💼 Im Büro';
  static const germanTimeZone = 'Europe/Berlin';
  static const favoritesCalendarName = 'Favoriten (jambu)';

  // Collections
  static const usersCollection = 'users';
  static const attendancesCollection = 'attendances';

  // Fields
  static const presentField = 'present';
  static const absentField = 'absent';
  static const tagsField = 'tags';
  static const favoritesField = 'favorites';
  static const onboardingCompletedField = 'onboardingCompleted';
  static const explanationsCompleted = 'explanationsCompleted';
  static const regularAttendancesField = 'regularAttendances';

  // Meeting rooms
  static final allMeetingRooms = meetingRoomsMunich +
      meetingRoomsLeipzig +
      meetingRoomsStuttgart +
      meetingRoomsErfurt;
  static const meetingRoomsMunich = [
    // 4. OG
    'Arabica',
    'Djampit',
    'Kona',
    'Liberica',
    'Robusta',
    'Tupi',
    // 5. OG
    'Americano',
    'Cappuccino',
    'Espresso',
    'Frappé',
    'Latte',
    'Lungo',
    'Ristretto',
    // 6. OG
    'Bali',
    'Biang',
    'Lombok',
    'Sumatra',
    'Toko',
    // 13. OG
    'Dempo',
    'Gama-Lama',
    'Kerinchi',
    'Lokon',
    'Merbabu',
    'Mutis',
    'Sundoro',
    'Tambora',
  ];
  static const meetingRoomsLeipzig = ['Medan', 'Jakarta', 'Bandung', 'Nobo'];
  static const meetingRoomsStuttgart = ['Kelimutu', 'Alapolo'];
  static const meetingRoomsErfurt = ['Gado-gado'];

  // FCM
  static const vapidKey =
      // ignore: lines_longer_than_80_chars
      'BDwDEXNpZUq9IJQ60LNTt3At9ctSWMBiEo5BMXzB9X2VojyfM0En84zNMr328DhLhruGVJQPCjo2lTJ3YCZhGoY';

  // TODO(tim): Just for testing
  static const testCalendarId =
      // ignore: lines_longer_than_80_chars
      'AAMkAGYwY2Y0MWM4LWE2MzItNDk5Ny05NzIzLWFjNjUwZjI3Y2UwYwBGAAAAAABd4EEhe61iSIEnLzkh3SdoBwDnm8A17Q_oQ41X7GXJE69AAAAAAAEGAADnm8A17Q_oQ41X7GXJE69AAACKlQf_AAA=';

  // Other
  static const feedbackUrl =
      'https://teams.microsoft.com/l/chat/0/0?users=tim.mewe@jambit.com';
}
