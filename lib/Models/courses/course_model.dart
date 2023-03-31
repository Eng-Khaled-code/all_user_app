class CourseModel
{

  int? id;
  String? name;
  String? imageUrl;
  String? desc;
  String? date;
  String? category;
  String? price;
  String?usersCountRattings;
  String? rate;
  String? likeCount;
  int? isPurechased;
  int? isBlack;
  int? isFav;
  String? videosCount;
  int? discountId;
  String? descountPercentage;
  String? priceAfterDiscount;
  int? userId;
  String? userName;
  String? userImage;
  String? userToken;
  int? discountStatus;
  String?discountEndsIn;

  CourseModel({
    this.price,
    this.userId,
    this.descountPercentage,
    this.discountEndsIn,
    this.discountId,
    this.discountStatus,
    this.priceAfterDiscount,
    this.userImage,
    this.userName,
    this.userToken,
    this.isBlack,
    this.isFav,
    this.isPurechased,
    this.videosCount,
    this.id,
    this.likeCount,
    this.name,
    this.imageUrl,
    this.desc,
    this.rate,
    this.category,
    this.date,
    this.usersCountRattings
  });

  factory CourseModel.fromSnapshot(Map<String,dynamic> data){

    return CourseModel
      (
        id: data["id"]??0,
        name: data["name"]??"",
        desc: data["desc"]??"",
        imageUrl: data["image_url"]??"",
        likeCount: data["like_count"]??"0",
        usersCountRattings: data["user_count_rating"]??"0",
        rate: data["rate"].toString(),
        category: data["category"]??"",
        date: data["date"]??"",
        videosCount: data["video_count"]??"0",
      userId: data['user_id']??0,
      userName: data['username']??"",
      userImage:data['image_url']??"",
      userToken: data['user_token']??"",
      price: data['price'].toString(),
      discountId: data['discount_id']??0,
      descountPercentage: data['dis_percentage'].toString(),
      priceAfterDiscount: data['price_after_dis'].toString(),
      discountEndsIn: data['dis_end_in']??"",
      discountStatus:data['dis_status']??0,
      isBlack: data["is_black"]??0,
      isPurechased: data['is_purechased']??0,
      isFav:data["is_fav"]??0,
    );
  }

}