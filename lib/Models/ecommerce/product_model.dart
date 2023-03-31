import 'dart:convert';

class ProductModel
{
  int? productId;
  String? name;
  String? desc;
  String? unit;
  String? category;
  int? quantity;
  String? price;
  int? discountId;
  String? descountPercentage;
  String? priceAfterDiscount;
  int? adminId;
  String? adminImage;
  String? adminName;
  String? adminToken;
  String? date;
  String? imageUrl;
  int? discountStatus;
  String?discountEndsIn;
  int? likeCount;
  int? isFav;
  int? isBlack;
  int? isInCartLit;
  String? ratings;

  Map<String,dynamic>? cartData;
  ProductModel({
    this.date,
    this.adminId,
    this.name,
    this.price,
    this.productId,
    this.quantity,
    this.category,
    this.desc,
    this.descountPercentage,
    this.discountEndsIn,
    this.discountId,
    this.discountStatus,
    this.isBlack,
    this.priceAfterDiscount,
    this.unit,
    this.cartData,
    this.isInCartLit,
    this.imageUrl,
    this.likeCount,
    this.adminName,
    this.adminImage,
    this.isFav,
    this.ratings,
    this.adminToken
  });

  factory ProductModel.fromSnapshot(Map<String,dynamic> data){
    //print(data.toString());
    return ProductModel
      (
        productId: data['product_id']??0,
        name: data['product_name']??"",
        desc: data['description']??"",
        unit: data['unit']??"",
        category: data['category']??"",
        adminToken: data['admin_token']??"",
        quantity: data['quantity']??0,
        price: data['price'].toString(),
        discountId: data['discount_id']??0,
        descountPercentage: data['dis_percentage'].toString(),
        priceAfterDiscount: data['price_after_dis'].toString(),
        adminId: data['admin_id']??0,
        imageUrl: data['image_url']??"",
        discountEndsIn: data['dis_end_in']??"",
        discountStatus:data['dis_status']??0,
        likeCount:int.tryParse(data['like_count'])??0,
        date: data['date']??"غير محدد",
        adminImage: data['admin_image']??"",
        adminName: data["admin_name"]??"",
        isFav: data["is_fav"]??0,
        isBlack: data["is_black"]??0,
        isInCartLit: data["cart_data"]==null?0:1,
        cartData: json.decode(data['cart_data']??"{}"),
       ratings: data['ratings'].toString()
    );
  }

}