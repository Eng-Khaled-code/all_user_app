
class CartModel {

  int?id;
  String? productName;
  String? productImage;
  String? productAdmin;
  String? adminImage;
  int? itemCount;
  String? itemPrice;
  String? totalPrice;
  int?   cartStatus;

  CartModel({this.id,this.productName,this.productAdmin,this.productImage,this.totalPrice,this.itemPrice,this.itemCount,this.adminImage,this.cartStatus});

  factory CartModel.fromSnapshot(Map<String,dynamic> data){
    return CartModel
      (
        id: data['cart_id']??0,
        productImage: data["product_image"]??"",
        productAdmin: data["product_admin"]??"",
        productName: data["product_name"]??"",
        totalPrice: data["total_price"].toString(),
        itemPrice: data["item_price"].toString(),
        itemCount: data['item_count']??0,
        cartStatus: data['cart_status']??0,
        adminImage: data["admin_image"]??"",


    );
  }
}
