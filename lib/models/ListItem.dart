

class Infor  {

    String address;
   String phone;
    String flag;


  Infor();


  Infor.fromMap(Map<String, dynamic> data) {

    address = data['Address'];
    phone = data['Phone'];
    flag = data["flag"];

  }
  Map<String, dynamic> toMap() {
    return {

      'Address': address,
      'Phone': phone,
      'flag' : flag
    };
  }

}