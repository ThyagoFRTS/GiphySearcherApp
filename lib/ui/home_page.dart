import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giphy_searcher/ui/giphy_page.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = '';
  int _offset = 0;

  Future<Map> _getGiphys() async {
    http.Response response;
    if (_search == '') {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=hqONnA6AcBB6n1u1e0YPJRyPr6zNObE5&limit=18&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=hqONnA6AcBB6n1u1e0YPJRyPr6zNObE5&q=$_search&limit=18&offset=$_offset&rating=g&lang=en"));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Image.network(
            "https://64.media.tumblr.com/733fedbd14779e3aed1ed63abca1734b/tumblr_punmuzoXFA1xg58k9o9_250.gifv"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search here",
                hintText: "Search Here",
                labelStyle: TextStyle(color: Colors.teal),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGiphys(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        strokeWidth: 4.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == '') {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_search == '' || index < snapshot.data['data'].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data['data'][index]['images']['fixed_height']['url'],
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GiphyInfo(snapshot.data['data'][index])));
              },
              onLongPress: () {
                Share.share(snapshot.data['data'][index]['images']
                    ['fixed_height']['url']);
              },
            );
          } else {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.grey, size: 100.0),
                  Text(
                    "See More",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 17;
                });
              },
            );
          }
        });
  }
}
