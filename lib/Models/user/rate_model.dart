class RateModel
{

  int?user1Id;
  int? user2Id;
  String? rate;
  String? date;
  String? comment;
  String? email;
  String? name;
  String? commentedUserImage;

  RateModel({this.rate,this.date,this.comment,this.commentedUserImage,this.name,this.email,this.user1Id,this.user2Id});

  factory RateModel.fromSnapshot(Map<String,dynamic> data){
    return RateModel
      (
        user1Id: data['user1_id']??0,
        user2Id: data['user2_id']??0,
        rate: data["rate"].toString(),
        email: data["email"]??"",
        date: data["date"]??"",
      comment: data["comment"]??"",
        commentedUserImage: data["image_url"]??"",
        name: data["username"]??""
    );
  }

}