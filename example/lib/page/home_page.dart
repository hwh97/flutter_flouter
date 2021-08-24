import 'package:flutter/material.dart';
import 'package:flutter_flouter_example/router/base_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home page"),
      ),
      body: Center(
        child: Text("pop back $value"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Uri uri = Uri(
            path: "/page2",
            queryParameters: {"value": "from home page"},
          );
          value = await router.routerDelegate.pushUri(uri);
          if (mounted) setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
