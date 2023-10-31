class GroupResponse {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  int? userId;

  GroupResponse(
      {this.id, this.createdAt, this.updatedAt, this.name, this.userId});

  GroupResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    return data;
  }
}
