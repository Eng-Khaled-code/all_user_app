import 'dart:convert';

class DoctorModel
{
  int? id;
  String? name;
  String? image;
  String? address;
  String? token;
  int? clinickStatus;
  String? closingReason;
  String? about;
  List? workDays;
  List? phones;
  String? ratings;
  DoctorModel({this.id,this.ratings,this.name,this.token,this.image,this.address,this.clinickStatus,this.closingReason,this.about,this.workDays,this.phones});

  factory DoctorModel.fromSnapshot(Map<String,dynamic> data){
    return DoctorModel
      (
        id: data['id']??0,
        name: data["name"]??"",
        image: data['image']??"",
        address: data["address"]??"",
        closingReason: data["closing_reason"]??"",
        about: data["about"]??"",
        token: data['token']??"",
        clinickStatus: data['clinick_status']??0,
        workDays: json.decode(data["work_days"]??"[]"),
        phones: json.decode(data["phones"]??"[]"),
        ratings: data['ratings'].toString()
    );
  }

}