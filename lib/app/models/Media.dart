class Media{
   String id;
  final String url;
  final String type;

  Media({ this.id,  this.url,  this.type});



    Media.fromFire(fire)
    : url=fire['url'],
    type=fire['type'],
    id=null;

    printPayment(){
      print(this.id);
      print(this.url);
      print(this.type);
    }

    Map<String, dynamic> tofire() => {
        'url': url,
        'type': type,
        
        
      };
}