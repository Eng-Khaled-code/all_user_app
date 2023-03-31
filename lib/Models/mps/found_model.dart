import 'dart:convert';

class FoundModel
{
  String? date;
  int?userId;
  String? username;
  String? userImage;
  String? missedType;
  String? name;
  String? lastPlace;
  String? missedImage;
  int? fUserId;
  String? fUsername;
  String? fUserImage;
  String? fMissedType;
  String? fLastPlace;
  String? fMissedImage;
  List? userPhones;
  List? fUserPhones;

  FoundModel({
    this.userId,
    this.fUserId,
    this.name,
    this.fLastPlace,
    this.fMissedImage,
    this.fMissedType,
    this.fUserImage,
    this.fUsername,
    this.fUserPhones,
    this.userImage,
    this.lastPlace,
    this.date,
    this.username,
    this.missedImage,
    this.missedType,
    this.userPhones,
  });

  factory FoundModel.fromSnapshot(Map<String,dynamic> data){
    return FoundModel
      (
      userId: data["user_id"]??0,
      fUserId: data["f_user_id"]??0,
      name: data["name"]??"",
        fLastPlace: data['f_last_place']??"",
        fMissedImage: data["f_missed_image"]??"",
        fMissedType: data["f_missed_type"]??"",
        fUserImage: data["f_user_image"]??"",
        fUsername: data['f_username']??"",
        fUserPhones: json.decode(data["f_user_phones"]??"[]"),
      userImage: data["user_image"]??"",
      lastPlace: data["last_place"]??"",
      date: data["date"]??"",
      username: data['username']??"",
      missedImage: data['missed_image']??"",
      missedType: data['missed_type']??"",
      userPhones: json.decode(data["user_phones"]??"[]"),
    );
  }

}