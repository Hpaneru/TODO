class User {
  String id, name, email, token, imageUrl, dob, phoneNumber, address;

  static User fromMap(var data) {
    return User()
      ..id = data["id"]
      ..name = data["name"]
      ..email = data["email"]
      ..token = data["token"]
      ..imageUrl = data["imageUrl"]
      ..dob = data["dob"]
      ..phoneNumber = data["phoneNumber"]
      ..address = data["address"];
  }

  toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "token": token,
      "imageUrl": imageUrl,
      "dob": dob,
      "phoneNumber": phoneNumber,
      "address": address,
    };
  }
}
