class ContactResponse {
  int? id;
  String? name;
  String? email;
  String? phone;
  Null? groupId;
  String? createdAt;
  String? updatedAt;

  ContactResponse(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.groupId,
      this.createdAt,
      this.updatedAt});

  ContactResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    groupId = json['group_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['group_id'] = this.groupId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
