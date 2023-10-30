class CreateContactResponse {
  String? name;
  String? email;
  String? phone;
  String? updatedAt;
  String? createdAt;
  int? id;

  CreateContactResponse(
      {this.name,
      this.email,
      this.phone,
      this.updatedAt,
      this.createdAt,
      this.id});

  CreateContactResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
