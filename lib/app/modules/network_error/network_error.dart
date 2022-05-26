import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../../main.dart';
import '../../routes/app_pages.dart';

class NetworkError extends StatefulWidget{
  @override
  State<NetworkError> createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
final Connectivity _connectivity = Connectivity();
ConnectivityResult _connectionStatus ;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
@override
initState() {
  super.initState();

initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
}

// Be sure to cancel subscription after you are done
@override
dispose() {
  super.dispose();

_connectivitySubscription.cancel();
}

  Future<void> initConnectivity() async {
     ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() async {
      _connectionStatus = result;
      if(_connectionStatus==ConnectivityResult.wifi){
        print('got connection WIFI');
        Phoenix.rebirth(context);
        await initServices();
        Future.delayed(Duration(seconds: 1),(){
Navigator.pushReplacementNamed(context, AppPages.INITIAL);
        });
        
        }
        else if(_connectionStatus==ConnectivityResult.mobile){
        print('got connection Mobile');
        Phoenix.rebirth(context);
        }
        else if(_connectionStatus==ConnectivityResult.none){
        print('no connection ');}
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{ 
              var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile) {
            Phoenix.rebirth(context);
  // I am connected to a mobile network.
 
} else if (connectivityResult == ConnectivityResult.wifi) {
  Phoenix.rebirth(context);
         }
         
         }
         
         ,
        child: Center(child: 
        Text("No Internet Connection "+ _connectionStatus.toString() )),
      ),
    );

    // TODO: implement build
    throw UnimplementedError();
  }
}