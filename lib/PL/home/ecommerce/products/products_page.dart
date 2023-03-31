import 'package:all/Models/ecommerce/product_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ecommerce_constants.dart';
import 'product_card.dart';
class ProductPage extends StatefulWidget {

  final String? page;
  ProductPage({Key? key,this.page}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    EcommerceProvider ecommerceProvider=Provider.of<EcommerceProvider>(context);

    return  SafeArea(
        child:  Column(children: [
         _buildSearchTextfieldWidget(ecommerceProvider),
         widget.page=="products_list"?  categoryWidgets(onTap:(){
              setState((){});
              ecommerceProvider.loadAndSearch(searchValue: searchController.text);
            }):Container(),
            _dataWidget(ecommerceProvider),
          ],),
      );}

  _dataWidget(EcommerceProvider ecommerceProvider){
    int itemCount=widget.page=="products_list"?ecommerceProvider.productList.length:widget.page=="fav_list"?ecommerceProvider.favList.length:widget.page=="black_list"?ecommerceProvider.blackList.length:0;
    return Expanded(child: RefreshIndicator(
        onRefresh: ()async{
          await ecommerceProvider.loadEcommerceList("in");

        },
        child:ecommerceProvider.isLoading
        ?
    loadingWidget2()
        :
    widget.page=="products_list"&&(ecommerceProvider.productList.isEmpty||_checkEmpty(ecommerceProvider)) ? noDataCard(text: "لا توجد منتجات",icon: Icons.shopping_basket)
        :
    widget.page=="fav_list"&&ecommerceProvider.favList.isEmpty?   noDataCard(text: "لا توجد منتجات في قائمة المفضلة",icon: Icons.favorite)
        :
    widget.page=="black_list"&&ecommerceProvider.blackList.isEmpty? noDataCard(text: "لا توجد منتجات في القائمة السوداء",icon: Icons.visibility_off)
        :
    SizedBox(
      child:
      ListView.builder(
          itemCount:itemCount,
          itemBuilder: (context,position){
            ProductModel _model=widget.page=="products_list"?ecommerceProvider.productList[position]:widget.page=="fav_list"?ecommerceProvider.favList[position]:ecommerceProvider.blackList[position];
            return widget.page !="products_list"?ProductCard(model:_model,ecommerceProvider: ecommerceProvider):widget.page=="products_list"&&ecommerceSelectedCategory==_model.category?ProductCard(model:_model,ecommerceProvider: ecommerceProvider):Container();
          }

      ),
    )));
  }

  bool _checkEmpty(EcommerceProvider ecommerceProvider){
    bool value=false;
    for (var element in ecommerceProvider.productList) {
      value=element.category==ecommerceSelectedCategory?false:true;
      if(value==false){
        break;}
    }
    return value;
  }

  Widget _buildSearchTextfieldWidget(EcommerceProvider ecommerceProvider) {
    return Container(
      margin:const EdgeInsets.all( 10),
      decoration: BoxDecoration(
          border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        onChanged: (value) {
          ecommerceProvider.loadAndSearch(searchValue: value);
        },
        style:const TextStyle(color: Colors.grey, fontSize: 14),
        controller: searchController,
        decoration:const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: " بحث ...",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            )),
      ),
    );
  }
}