import 'package:flutter/material.dart';
import 'package:flutter_application_api/Models/gif.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Gif>> ?_listaGif;

  Future<List<Gif>> _getGifs() async{
    final response= await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=w4Yq4C8OPdWM7KGKZTPJ6v4Ieq558QpT&limit=10&rating=g"));

    List<Gif> gifs= [];
    if(response.statusCode==200){
      String body= utf8.decode(response.bodyBytes);
      final jsonData= jsonDecode(body);
      
      for (var item in jsonData["data"]){
        gifs.add(
          Gif(item["title"], item["images"]["downsized"]["url"])
        );
      }
    // ignore: avoid_print
    print(jsonData["data"][0]["images"]["downsized"]["url"]);
    return gifs;
    
    }else{
      throw Exception("Conection Failed");
    }
    
  }

  @override
  void initState() {
    super.initState();
    _listaGif= _getGifs();
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Api Giphy'),
        ),
        body: FutureBuilder(
          future: _listaGif,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return GridView.count(crossAxisCount: 2,children: _listGifs(snapshot.data),
              );
            }else if(snapshot.hasError){
              // ignore: avoid_print
              print(snapshot.error);
              return const Text("Error");
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

List<Widget> _listGifs(data){
  List<Widget> gifs= [];

  for(var gif in data){
    gifs.add(
      Card(child: Column(
        children: [
          Expanded(child: Image.network(gif.url, fit: BoxFit.fill,)),
        ],
      ))
    );
  }

  return gifs;
}

}


