import 'package:all/Models/ecommerce/address_model.dart';
import 'package:all/Models/ecommerce/order_model.dart';
import 'package:all/Models/ecommerce/product_model.dart';
import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Services/main_operations.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EcommerceProvider with ChangeNotifier
{

  String url=rootUrl+"ecommerce/";
  bool isLoading=false;
  bool isFavLoading=false;
  List<ProductModel> productList=[];
  List allProductList=[];
  List<ProductModel> favList=[];
  List<ProductModel> blackList=[];
  List<ProductModel> cartList=[];
  List<AddressModel> addressList=[];
  double totalPrice = 0.0;
  int itemCount =0;
  List<OrderModel> ordersList=[];

  final MainOperation _mainOperation=MainOperation();

  EcommerceProvider(){
    loadEcommerceList("out");
  }

  Future<void> loadEcommerceList(String from) async {

    if(from=="out")
    {
    isLoading=true;
    notifyListeners();
    }

    Map<String, String> postData = {"user_id": "${userInformation!.userId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "load_suggested_products.php");
    if (resultMap["status"] == 1) {

    ecommerceCategoriesList=resultMap["categories"];
      if(from!="in") {
        ecommerceSelectedCategory =
        ecommerceCategoriesList.isNotEmpty ? ecommerceCategoriesList.first : "";
      }
      allProductList=resultMap["data"];

      loadAndSearch(searchValue: "");
      loadAddressesAsModel(addresses:resultMap['address'] );
      loadOrdersAsModel(orders: resultMap['orders']);
    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"],),toastLength: Toast.LENGTH_LONG);
    }

    if(from=="out")
    {
    isLoading=false;
    notifyListeners();
    }
  }

  loadAddressesAsModel({List? addresses}) {
    addressList=[];


    for(var address in addresses!)
    {
      addressList.add(AddressModel.fromSnapshot(address));
    }


  }
  loadOrdersAsModel({List? orders}) {
    ordersList=[];
    for(var order in orders!)
    {
      ordersList.add(OrderModel.fromSnapshot(order));
    }


  }

  loadAndSearch({ String? searchValue}) {
    productList=[];
    favList=[];
    blackList=[];
    cartList=[];
    totalPrice=0.0;
    itemCount=0;
    if(searchValue=="")
    {
      for (var element in allProductList) {
        if(element['is_black']==0){
          if(element['is_fav']==1)
           {
          favList.add(ProductModel.fromSnapshot(element));
           }
          productList.add(ProductModel.fromSnapshot(element));
        }
        else if(element['is_black']==1){
          blackList.add(ProductModel.fromSnapshot(element));
         }


      }
    }
    else
    {
      for (var element in allProductList) {
          if(element['is_black']==0&&element['category']==ecommerceSelectedCategory&&element['product_name'].toString().contains(searchValue!))
          {
            productList.add(ProductModel.fromSnapshot(element));
          }
          else if(element['is_black']==1&&element['product_name'].toString().contains(searchValue!)){
           blackList.add(ProductModel.fromSnapshot(element));
        }
    if(element['is_fav']==1&&element['product_name'].toString().contains(searchValue!))
    {
    favList.add(ProductModel.fromSnapshot(element));
    }
      }
    }

    for (var element in allProductList) {

      if(element['cart_data']!=null)
      {

        ProductModel _model=ProductModel.fromSnapshot(element);
            cartList.add(_model);
            totalPrice+=_model.cartData!['total_price'];
            itemCount+= _model.cartData!['item_count'] as int;
      }

  }

  notifyListeners();
  }

  Future<void> favourateOperations({String? postId,String? type}) async {
    if(type=="black"||type=="unblack"){
      isLoading=true;
      notifyListeners();
    }
    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "post_id": postId!,
      "type": type!
    };
    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "favourate.php");
    if (resultMap["status"] == 1) {
      await loadEcommerceList("in");
      Fluttertoast.showToast(msg: type=="black"?"تم الاضافة في القائمة السوداء":type=="unblack"?"تم الحذف من القائمة السوداء":type=="like"?"تم الإضافة الي القائمة المفضلة":"تم الحذف من القائمة المفضلة");

    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
    }

    if(type=="black"||type=="unblack"){
      isLoading=false;
      notifyListeners();
    }

  }

  Future<void> cartListOperations({int? cartId=0 ,int? productId,int? quantity=0,String? type}) async {


    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "product_id": "$productId",
      "type": type!,
      "cart_id":"$cartId",
      "quantity":"$quantity"
    };
    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "cart_list.php");
    if (resultMap["status"] == 1) {
      await loadEcommerceList("in");
      Fluttertoast.showToast(msg:"تم التنفيذ بنجاح");
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
    }
  }

  Future<bool> addressOperations({int? addressId=0 ,String? country="",String? city="",String? postCode=""
    ,String? phone1="",String? phone2="",String? type}) async {

    isLoading=true;
    notifyListeners();
    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "country": country!,
      "type": type!,
      "city":city!,
      "post_code":postCode!,
      "phone_1":phone1!,
      "phone_2":phone2!,
      "id":"$addressId"
    };
    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "address.php");
    if (resultMap["status"] == 1) {
      await loadEcommerceList("in");
      Fluttertoast.showToast(msg:"تم التنفيذ بنجاح");
      isLoading=false;
      notifyListeners();
      return true;
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
      isLoading=false;
      notifyListeners();
      return false;
    }




  }

  Future orderOperations({int? orderId=0,int?addressId=0,String? type}) async {

    isLoading=true;

    notifyListeners();
    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "order_id": "$orderId",
      "type": type!,
      "total_price":"$totalPrice",
      "total_item_count":"$itemCount",
      "cart_list":'${phpCartList()}',
      "adress_id":"$addressId"
    };
    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "order.php");
    if (resultMap["status"] == 1) {
      await loadEcommerceList("in");
      isLoading=false;
      Fluttertoast.showToast(msg:type=="add"?"تم إضافة الطلب بنجاح":type=="change address"?"تم تغيير العنوان بنجاح":"تم حذف الطلب بنجاح");

      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
      isLoading=false;
      notifyListeners();
    }


  }

Map phpCartList(){

    Map _map={};
   for(var cart in cartList)
   {
     _map["\"${cart.cartData!['cart_id']}\""]=cart.discountStatus==1?cart.priceAfterDiscount:cart.price;
   }

  return _map;
}

}