class UserModel {
  final String uid;
  // final String name;
  final String email;

  UserModel({required this.uid, required this.email});

  // JSON 데이터로부터 UserModel 인스턴스를 생성하는 팩토리 생성자
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      // name: json['name'],
      email: json['email'],
    );
  }

  // UserModel 인스턴스를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      // 'name': name,
      'email': email,
    };
  }
}
