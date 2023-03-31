import 'dart:convert';

class BookingModel
{
  int? id;
  int? docId;
  String? docName;
  String? docImage;
  String? docAddress;
  int? clinickStatus;
  String? docToken;
  String? closingReason;
  String? patientName;
  String? reqDate;
  String? finalBookDate;
  String? responseDate;
  int? numInQueue;
  String? notes;
  String? bookType;
  String? painDesc;
  String? bookStatus;


  BookingModel({
    this.id,
    this.patientName,
    this.docId,
    this.bookStatus,
    this.bookType,
    this.clinickStatus,
    this.docAddress,
    this.closingReason,
    this.docImage,
    this.docName,
    this.docToken,
    this.finalBookDate,
    this.notes,
    this.numInQueue,
    this.reqDate,
    this.responseDate,
    this.painDesc
  });

  factory BookingModel.fromSnapshot(Map<String,dynamic> data){
    return BookingModel
      (
        id: data['id'],
        docToken: data["doc_token"]??"",
        docName: data['doc_name']??"",
        docImage: data["doc_image"]??"",
        closingReason: data["d_closing_reason"]??"",
        docAddress: data["doc_address"]??"",
        docId: data['doc_id']??0,
        clinickStatus: data['d_clinick_status']??0,
        responseDate: data['result_date']??"",
        reqDate: data["req_date"]??"",
        finalBookDate: data['booking_final_date']??"",
        bookStatus: data["booking_status"]??"",
        bookType: data["booking_type"]??"",
        numInQueue: data["num_in_queue"]??0,
        notes: data['notes']??"",
        patientName: data['patient_name']??"",
      painDesc: data['pain_desc']??""
    );
  }

}