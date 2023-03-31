import 'package:all/Models/ecommerce/product_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';

class CartCard extends StatefulWidget {
 final ProductModel? model;
 EcommerceProvider? ecommerceProvider;
  CartCard(
      {Key? key,this.model,this.ecommerceProvider})
      : super(key: key);

  @override
  _CartCardState createState() =>
      _CartCardState();
}

class _CartCardState extends State<CartCard> {

  bool quantityRow=false;
  int _numOfItems=1;
  double imageBottom=40;
  double height=180.0;
  bool isDeleteLoading=false;
  bool isQuantityLoading=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0,vertical: 10.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _blueBackground(),
          _deleteButton(),
          _imageWidget(),
          _nameWidget(),
          _descriptionWidget(),
          _bottomRow(),
        ],
      ),
    );
  }

  Container _blueBackground() {

    return  Container(
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.0),
          color: Colors.lightBlueAccent,
          boxShadow:const [
            BoxShadow(color: Colors.grey, blurRadius: 8.0),
          ]),
      child: Container(
        margin: const EdgeInsets.only(left: 35.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.0)),
      ),
    );
  }

  Positioned _deleteButton() {
    return isDeleteLoading?const Positioned(
        top: 70,left:8.0,
        child: SizedBox(width:20,height: 20,child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)))
        :
    Positioned(
        top: 0.0,
        left: 0.0,
        bottom: 0.0,
        child:IconButton(
          icon:const Icon(Icons.delete,color: Colors.black,size: 25.0,),
          onPressed: ()async {
            setState(()=>isDeleteLoading=true);
            await widget.ecommerceProvider!.cartListOperations(type: "delete",cartId: widget.model!.cartData!["cart_id"]);
            setState(()=>isDeleteLoading=false);

          },
        ));
  }

  Positioned _imageWidget() {

    return Positioned(
        top: 5,
        right: 5.0,
        bottom: imageBottom,
        child: imageWidget(image:widget.model!.imageUrl!,height:180,width: 118));
  }

  Positioned _nameWidget() {
    return Positioned(
        top: 10.0,
        left: 35.0,
        right: 125.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomText(text:
              widget.model!.name!,
              fontSize: 15,
              fontWeight: FontWeight.bold,alignment: Alignment.topRight,textAlign: TextAlign.right,

            ),
          ),
        ));
  }

  Positioned _descriptionWidget() {
    return Positioned(
        top: 60.0,
        left: 45.0,
        right: 125.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.model!.desc!,
              maxLines: 3,
            ),
          ),
        ));
  }

  Padding _bottomRow() {

    return Padding(
      padding: const EdgeInsets.only(right: 5,left:30,bottom: 2),
      child: Column(
        children: [
          _buildingCartQuantity(),
          Row(
              children: [
          _myBottomColoredContainer("${widget.model!.price!}\$",color:Colors.greenAccent,isDiscount: widget.model!.discountStatus==1?true:false ),
      _offWidget(),
          _afterDisPriceWidget(),
          _itemCountWidget(),
          _myBottomColoredContainer("إجمالي: \$"+ widget.model!.cartData!['total_price'].toString(),)
    ],
    ),
        ],
      ),
    );
  }

  GestureDetector _itemCountWidget() {

    return GestureDetector(onTap: (){
      if(isQuantityLoading==false){
     setState((){
       height=quantityRow?180.0:210.0;
       imageBottom=quantityRow?40:90;
       quantityRow=!quantityRow;

     });}
    },child:  Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(5),
      child: isQuantityLoading?const SizedBox(width:20,height: 20,child:  CircularProgressIndicator(strokeWidth: 1,color: Colors.white,))
          :
      Text(
        "X"+widget.model!.cartData!['item_count'].toString() ,style:const TextStyle(fontSize: 12),
      ),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
    ));
  }

  Widget _offWidget() {
    return  widget.model!.discountStatus==1?
    _myBottomColoredContainer("خصم ${widget.model!.descountPercentage}%",color: Colors.pink):Container();
  }

  Widget _afterDisPriceWidget() {
    return widget.model!.discountStatus==1?_myBottomColoredContainer("${widget.model!.priceAfterDiscount}\$"):Container();
  }

  Container _myBottomColoredContainer(String text,{Color? color=Colors.lightBlueAccent,bool? isDiscount=false}){
    return Container(
      margin:const EdgeInsets.only(right: 5),
      padding:const EdgeInsets.all(5),
      child: Text(text,style:TextStyle(fontSize: 12,decoration: isDiscount! ?TextDecoration.lineThrough:TextDecoration.none),),
      decoration: customDecoration(color: color!,border: false),
    );
  }

  Widget _buildingCartQuantity() {
    return quantityRow
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
        height=quantityRow?180.0:210.0;
        imageBottom=quantityRow?40:90;
        quantityRow=!quantityRow;

      });
        await widget.ecommerceProvider!.cartListOperations(type: "update",cartId: widget.model!.cartData!["cart_id"],quantity:_numOfItems);
        setState(()=>isQuantityLoading=false);


    }, icon:const Icon(Icons.edit,size:20,color: Colors.blue,)
    , label: CustomText(text:"تغيير الكمية",fontSize: 12,))
    ]),
    ]):Container();
  }

}
