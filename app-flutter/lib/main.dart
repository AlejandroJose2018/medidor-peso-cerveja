import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerta Cerveja',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: AlertaPage(
        title: 'Alerta Cerveja'
      ),
    );
  }
}

class AlertaPage extends StatefulWidget {
  AlertaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AlertaPageState createState() => _AlertaPageState();
}

class _AlertaPageState extends State<AlertaPage> {

  AssetsAudioPlayer _assetsAudioPlayer;
  Future<Map> sensor;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(
      AssetsAudio(
        asset: "air-alert.mp3",
        folder: "assets/audios/",
      ),
    );
    _assetsAudioPlayer.pause();
    sensor = _getPesoCerveja();
    sincronizar();
  }

  @override
  void dispose() {
    _assetsAudioPlayer = null;
    sensor = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
              future: sensor,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          strokeWidth: 5.0,
                        ),
                      );
                    case ConnectionState.done:
                      return _renderAlerta(context, snapshot);
                    default:
                      return Container(child: Text("Error"),);
                  }
                },
              ),
            ),
            RaisedButton(
              child: Text("Verificar Mesa", style: TextStyle(color: Colors.white),),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  sensor = _getPesoCerveja();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Map> _getPesoCerveja() async {
    await Future.delayed(Duration(seconds: 1));
    http.Response response = await http.get("https://weight-sensor-api.herokuapp.com/v1/public/sensors/sensor-1");
    return json.decode(response.body);
  }

  Widget _renderAlerta(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data['sensor']['value'] > 200) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0.0),
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/normal.gif"),
            Text("Ainda tem cerveja na garrafa! :)", style: TextStyle(fontSize: 35.0), textAlign: TextAlign.center)
          ],
        ),
      );
    } else {
      _assetsAudioPlayer.play();

      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0.0),
        child: Column(
          children: <Widget>[
            Text("Alerta!!!", style: TextStyle(fontSize: 50.0, ), textAlign: TextAlign.center),
            Text("Mesa 01", style: TextStyle(fontSize: 25.0, ), textAlign: TextAlign.center),
            Image.asset("assets/images/alerta.gif"),
            Text("A cerveja acabou, entregue mais uma!", style: TextStyle(fontSize: 35.0), textAlign: TextAlign.center),
          ]
        ),
      );
    }
  }

  void sincronizar() async {
    await Future.delayed(Duration(seconds: 30));
    setState(() {
      sensor = _getPesoCerveja();
    });
    sincronizar();
  }
}
