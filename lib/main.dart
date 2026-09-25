import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа'),
          ),
          body: MyHomePage(),
          ),
    );
  }
}



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 15,
        children: [
              Container(width: 100, height: 100, margin: EdgeInsets.all(20), padding: EdgeInsets.all(10), color: Colors.red, child: Center(child: Text('1'))),
              Container(width: 200, height: 100, margin: EdgeInsets.all(0), padding: EdgeInsets.all(5), color: Colors.green, child: Center(child: Text('2'))),
              Container(width: 100, height: 100, margin: EdgeInsets.all(20), padding: EdgeInsets.all(15), color: Colors.blue, child: Center(child: Text('3'))),
              Container(width: 150, height: 100, margin: EdgeInsets.all(0), padding: EdgeInsets.all(20), color: Colors.orange, child: Center(child: Text('4'))),
              Container(width: 100, height: 100, margin: EdgeInsets.all(40), padding: EdgeInsets.all(0), color: Colors.purple, child: Center(child: Text('5'))),
              Container(width: 50, height: 100, margin: EdgeInsets.all(80), padding: EdgeInsets.all(20), color: Colors.teal, child: Center(child: Text('6'))),
              
    
        
  

      ],
  ),   
);
  

  }
}

