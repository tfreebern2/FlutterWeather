import 'package:flutter/material.dart';

import 'package:weather/model/weather_repo.dart';
import 'package:weather/model/model_command.dart';
import 'package:weather/model/model.dart';
import 'package:weather/model/model_provider.dart';

import 'package:rx_widgets/rx_widgets.dart';

import 'package:http/http.dart' as http;

void main() {
  final repo = WeatherRepo(client: http.Client());
  final modelCommand = ModelCommand(repo); 
  runApp(
    ModelProvider(
      child: new MyApp(),
      modelCommand: modelCommand,
      ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather Demo',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: <Widget> [
          Container(
            child: Center(
              child: RxLoader<bool>(
                radius: 20.0,
                commandResults: ModelProvider.of(context).getGpsCommand,
                dataBuilder: (context, data) => Text(data ? "GPS Active" : "GPS Inactive"),
                placeHolderBuilder: (context) => Text("Push the Button"),
                errorBuilder: (context, exception) => Text("$exception"),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: ModelProvider.of(context).getGpsCommand,
          )
        ]
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: RxLoader<List<WeatherModel>>(
              radius: 30.0,
              commandResults: ModelProvider.of(context).updateWeatherCommand,
              dataBuilder: (context, data) => WeatherList(data),
              placeHolderBuilder: (context) => Center(child: Text("No Data")),
              errorBuilder: (context, exception) => 
                  Center(child: Text("$exception")),
            )
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: WidgetSelector(
                    buildEvents: ModelProvider
                      .of(context)
                      .updateLocationCommand
                      .canExecute,
                    onTrue: MaterialButton(
                      elevation: 5.0,
                      color: Colors.blueGrey,
                      child: Text("Get the Weather"),
                      onPressed: ModelProvider.of(context).updateLocationCommand
                    ),
                    onFalse: MaterialButton(
                      elevation: 0.0,
                      color: Colors.blueGrey,
                      onPressed: null,
                      child: Text("Loading..."),
                    ),
                  
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WeatherList extends StatelessWidget {
  final List<WeatherModel> list;
  WeatherList(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(list[index].city),
      ),
    );
  }
}

