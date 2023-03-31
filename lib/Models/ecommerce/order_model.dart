
import 'dart:convert';

import 'package:all/Models/ecommerce/address_model.dart';

class OrderModel {

  int? orderId;
  String? createdAt;
  String? totalPrice;
  int? totalItemCount;
  List? orderCartList;
  AddressModel? addressModel;

  OrderModel({this.orderId,this.createdAt,this.addressModel,this.orderCartList,this.totalPrice,this.totalItemCount});

  factory OrderModel.fromSnapshot(Map<String,dynamic> data){
    return OrderModel
      (
        orderId: data['id']??0,
        createdAt: data["created_at"]??"",
        totalItemCount: data["total_item_count"]??0,
        totalPrice: data["total_price"].toString(),
        addressModel: AddressModel.fromSnapshot(json.decode(data["address"])),
        orderCartList: json.decode(data['cart_data']??"[]"),

    );
  }


}
