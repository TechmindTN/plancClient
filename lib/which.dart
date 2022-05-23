import 'package:flutter/material.dart';

class Which extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vous Etes??"),
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          children: [
            Container(
              child: Text("Entreprise"),
            ),
              Container(
                              child: Text("Independant"),

              )

          ],
        ),
      ),
    );

    // TODO: implement build
    throw UnimplementedError();
  }

}