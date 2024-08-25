class MessageModel {
  String? motherId;
  String? doctorId;
  String? message;
  String? file;
  String? type;
  String? dateTime;
  String? id;

  MessageModel(
      {this.motherId,
      this.doctorId,
      this.message,
      this.dateTime,
      this.type,
      this.id,
      this.file});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      motherId: json['motherId'],
      doctorId: json['doctorId'],
      message: json['message'],
      dateTime: json['dateTime'],
      type: json['type'],
      id: json['id'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': motherId,
      'coachId': doctorId,
      'message': message,
      'dateTime': dateTime,
      'type': type,
      'id': id,
      'file': file,
    };
  }
}
