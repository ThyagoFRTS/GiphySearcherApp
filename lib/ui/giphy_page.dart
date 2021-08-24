import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GiphyInfo extends StatelessWidget {
  //const GiphyInfo({Key? key}) : super(key: key);
  final Map _gifData;

  GiphyInfo(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData['title']),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_gifData['images']['original']['url']);
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(_gifData['images']['original']['url']),
      ),
    );
  }
}
