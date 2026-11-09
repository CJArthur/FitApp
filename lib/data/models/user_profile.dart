// Пока авторизации нет, в приложении хранится один локальный профиль.
class UserProfile {
  const UserProfile({
    this.firstName = '',
    this.lastName = '',
    this.middleName = '',
    this.birthDate = '',
    this.email = '',
    this.phone = '',
    this.height,
    this.weight,
    this.targetWeight,
  });

  final String firstName;
  final String lastName;
  final String middleName;
  final String birthDate; // Для этой формы храним дату как ДД.ММ.ГГГГ.
  final String email;
  final String phone;
  final double? height;
  final double? weight;
  final double? targetWeight;

  String get displayName {
    final name = '$firstName $lastName'.trim();
    if (name.isEmpty) {
      return 'Имя не указано';
    }
    return name;
  }

  // Как у Workout: превращаем объект в карту для записи в SQLite.
  Map<String, Object?> toMap() {
    return {
      'id': 1,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'birth_date': birthDate,
      'email': email,
      'phone': phone,
      'height': height,
      'weight': weight,
      'target_weight': targetWeight,
    };
  }

  // Обратное преобразование: строка таблицы → объект профиля.
  factory UserProfile.fromMap(Map<String, Object?> map) {
    return UserProfile(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      middleName: map['middle_name'] as String,
      birthDate: map['birth_date'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      height: (map['height'] as num?)?.toDouble(),
      weight: (map['weight'] as num?)?.toDouble(),
      targetWeight: (map['target_weight'] as num?)?.toDouble(),
    );
  }
}
