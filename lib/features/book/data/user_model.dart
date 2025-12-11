
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime? birthDate;
  final String? job;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.birthDate,
    this.job,
  });

  int get age {
    if (birthDate == null) return 0;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month || (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'displayName': displayName,
        'birthDate': birthDate?.toIso8601String(),
        'job': job,
      };

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) => AppUser(
        uid: uid,
        email: map['email'] ?? '',
        displayName: map['displayName'],
        birthDate: map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
        job: map['job'],
      );
}