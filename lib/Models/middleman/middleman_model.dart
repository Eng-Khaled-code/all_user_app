
import 'dart:convert';

class MiddlemanModel
{
  int? placeId;
  String? address;
  int?roufNum;
  String? type;
  String? size;
  String? metrePrice;
  String? totalPrice;
  String? operation;
  String? moreDetails;
  int? adminId;
  String? adminName;
  String? adminImage;
  String? adminToken;
  List? adminPhones;
  String? date;
  int? isDiscuss;
  int? isPurechased;
  int? isBlack;
  int? isFav;
  int? likeCount;

  String? ratings;

  MiddlemanModel({this.placeId,this.ratings,this.address,this.isBlack,this.likeCount,this.roufNum,this.type,this.size,this.metrePrice,this.totalPrice,this.operation,
  this.moreDetails,this.adminName,this.adminToken,this.adminId,this.adminImage,this.adminPhones,this.isFav,this.date,this.isDiscuss,this.isPurechased});

  factory MiddlemanModel.fromSnapshot(Map<String,dynamic> data){
    //print(data["admin_id"]);
    return MiddlemanModel
      (
        placeId: data['place_id'],
        address: data['address'],
        roufNum: data['its_rouf_num']??0,
        type: data['type'],
        size: data['size'].toString() ,
        metrePrice: data['metre_price'].toString(),
        totalPrice: data['total_price'].toString(),
        operation: data['operation']??"",
        moreDetails: data['more_details']??"",
        adminName: data['admin_name'],
        adminId: data['admin_id'],
        adminImage: data['image_url']??"",
        adminToken: data['admin_token']??"",
        adminPhones: json.decode(data['phones']??"[]"),
        isDiscuss:data["is_discuss"]??0,
        date:data["date"]??"",
        isBlack: data["is_black"]??0,
        isPurechased: data['my_purchases']??0,
        isFav:data["is_fav"]??0,
        likeCount:int.tryParse(data['like_count'])??0,
        ratings: data['ratings'].toString()


    );
  }

}