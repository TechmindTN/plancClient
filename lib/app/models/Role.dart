
class Role{
   String id;
  final String name;

  Role({ this.id,  this.name});


   Role.fromFire(fire)
    : name=fire['name'];

  printRole(){
    print(this.id);
    print(this.name);
  }
    
}