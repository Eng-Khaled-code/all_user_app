class UserModel
{
  int? userId;
  String? userName;
  String? email;
  String? address;
  String? imageUrl;
  String? token;
  String? ratingValue;


  UserModel({this.userId,this.userName,this.email,this.address,this.imageUrl,this.token,this.ratingValue});

  factory UserModel.fromSnapshot(Map<String,dynamic> data){
    return UserModel
      (
        userId: data['user_id'],
        userName: data["username"]??"",
        email: data['email']??"",
        address: data["address"]??"",
        imageUrl: data["image_url"]??"",
        token: data['token']??"",
        ratingValue: data['rating']??"0"
    );
  }

}