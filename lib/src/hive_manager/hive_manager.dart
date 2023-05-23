import 'package:hive_flutter/adapters.dart';

class HiveManager<T> extends HiveObject{
  HiveManager(this.boxLabel, this.adapter);

  final String boxLabel;
  final TypeAdapter<T> adapter;
  Box<T>? modelBox;

  Future<void> connect({bool openBox = true}) async {
    // register adapter
    Hive.registerAdapter<T>(adapter);

    // open box
    if(openBox) modelBox = await Hive.openBox(boxLabel);
  }
}