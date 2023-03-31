import 'package:all/Models/ecommerce/product_model.dart';
import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';
class ProductCard extends StatefulWidget {
  final ProductModel? model;
  final EcommerceProvider? ecommerceProvider;

  ProductCard({Key? key,this.model,this.ecommerceProvider}):super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isQuantityLoading=false;
  bool isFavLoading=false;
  bool showCartRow=false;
  int _numOfItems = 1;
  @override
  Widget build(BuildContext context){

    return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _topRow(),
            imageWidget(image:widget.model!.imageUrl! ),
            _dataWidget(),
              _bottomRow()
          ],

      ),
    );
  }

 Row _topRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          adminProfileWidget(context: context,image: widget.model!.adminImage,name:widget.model!.adminName,adminId:widget.model!.adminId,date:  widget.model!.date,ratings:widget.model!.ratings,opertionType: widget.model!.category),
          _actionsRow(),
    ],
    );
  }

  Widget _buildingCartQuantity() {
    return showCartRow&&widget.model!.isInCartLit==0
    ?
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomText(text:"الكمية : "),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(_numOfItems.toString().padLeft(2, "0")),
      ),
      Row( children: [
        SizedBox(
            height:20,
            width:20,
            child: OutlinedButton(
              onPressed: () {
                if (_numOfItems > 1) {
                  setState(() {
                    _numOfItems--;
                  });
                }
              },

              child:const Icon(Icons.remove,size: 15),
            )),
        const SizedBox(width: 10.0),
        SizedBox(
            height: 20,
            width: 20,
            child: OutlinedButton(

              onPressed: () {
                setState(() {
                  _numOfItems++;
                });
              },
              child: const Icon(Icons.add,size: 15,),
            )),
        const SizedBox(width: 10.0),
    TextButton.icon(onPressed: ()async{

      setState((){
        isQuantityLoading=true;
        showCartRow=!showCartRow;});

    await widget.ecommerceProvider!.cartListOperations(type: "add",productId: widget.model!.productId,quantity:_numOfItems);
    setState(()=>isQuantityLoading=false);


    }, icon:const Icon(Icons.shopping_cart,size:20,color: Colors.blue,)
    , label: CustomText(text:"إضافة لسلة المشتريات",fontSize: 12,))
      ]),
    ]):Container();
  }

 Column _bottomRow(){
    return Column(
      children: [
        const Divider(),
        _buildingCartQuantity(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _likeWidget(),
            _shoppingCartWidget(),
            _discountWidget(),
          ],
        ),
      ],
    );
  }

 InkWell _likeWidget() {
    return InkWell(
      onTap: ()async{

        setState(()=>isFavLoading=true);
        await widget.ecommerceProvider!.favourateOperations(postId: "${widget.model!.productId}",type: widget.model!.isFav==0?"like":"dislike");
        setState(()=>isFavLoading=false);

      },
      child:  isFavLoading? Container(padding:const EdgeInsets.all(10),width: 40,height: 40,child:const CircularProgressIndicator(strokeWidth: .7,),)
        :widget.model!.isBlack==1?Container():Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          children: [
            CustomText(
              text:"${widget.model!.likeCount}",
              color: Colors.grey,),
            const SizedBox(width: 10),
             Icon(Icons.favorite,color:widget.model!.isFav==1?Colors.pink:Colors.grey),
          ],
        ),),
    );
  }

 Container _discountWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: Row(
        children: [
          CustomText(
            text:widget.model!.discountStatus == 0 ? "لا يوجد خصم":"${widget.model!.descountPercentage}%",
            color: Colors.grey,),
          const SizedBox(width: 10),
         const Icon(Icons.money_off,color: Colors.green,),

        ],
      ),);
  }

 Widget _shoppingCartWidget() {
    return isQuantityLoading?loadingWidget2():widget.model!.isBlack==1?Container():InkWell(
      onTap: ()=>setState(()=>showCartRow=!showCartRow),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          children: [
            CustomText(
              text:"سلة المشتريات",
              color: Colors.grey,),
            const SizedBox(width: 10),
            Icon(Icons.shopping_cart,color:widget.model!.isInCartLit==1?Colors.blue: Colors.grey,),

          ],
        ),),
    );
  }

 Padding _dataWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(text:widget.model!.name!,fontSize: 20,fontWeight: FontWeight.bold,),
          CustomText(text: "${widget.model!.unit}   ||   سعر الوحدة : ${widget.model!.price}"+ (widget.model!.discountId! ==0?"":"   ||   بعد الخصم : ${widget.model!.priceAfterDiscount}"),color: Colors.grey,alignment: Alignment.centerRight,textAlign: TextAlign.right,),
          CustomText(text: "تفاصيل اكثر : ${widget.model!.desc}",color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
        ],
      ),
    );
  }

 Row _actionsRow() {
    return Row(
      children: [
        IconButton(onPressed: (){},icon: const Icon(Icons.notifications_active,color: Colors.blue,),),
        _blackListWidget()

      ],
    );
  }

 Widget _blackListWidget() {
    return widget.model!.isFav==0?IconButton(onPressed: ()=>showDialogFor(
   context:context,
   contentText: widget.model!.isBlack==0?"هل تريد وضع هذا المنتج في القائمة السوداء":"هل تريد إزالة هذا المنتج من القائمة السوداء",
   title: "تأكيد",
   onPress: ()async{
   Navigator.pop(context);
   await widget.ecommerceProvider!.favourateOperations(postId: "${widget.model!.productId}",type: widget.model!.isBlack==0?"black":"unblack");
   }),icon: Icon(widget.model!.isBlack==0?Icons.visibility_off:Icons.visibility)):Container();
 }

}
