class Payment{
   String id;
  final String name;
  final String type;

  Payment({ this.id,  this.name,  this.type});



    Payment.fromFire(fire)
    : name=fire['name'],
    type=fire['type'],
    id=null;

    printPayment(){
      print(this.id);
      print(this.name);
      print(this.type);
    }

    Map<String, dynamic> tofire() => {
        'name': name,
        'type': type,
        
        
      };
}