class User {
  late String fullName;
  late String email;
  
  User(this.fullName, this.email);
  
  User.fromJson(Map<String, dynamic> json) {
    fullName = json["fullName"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
  };

  @override
  bool operator == (Object other) {
    return other is User && other.email == email && other.fullName == fullName;
  }

  @override
  int get hashCode => Object.hash(email, fullName);

  @override
  String toString() {
    return "FullName: $fullName\nEmail: $email; ";
  }
}
