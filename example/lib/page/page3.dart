import 'package:flutter/material.dart';
import 'package:flutter_flouter_example/router/base_navigator.dart';

class Page3 extends StatefulWidget {
  final String? value;

  const Page3({Key? key, this.value}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            router.routerDelegate.pop("pop back from page3");
          },
        ),
        title: Text("page3"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("${widget.value}"),
            TextButton(
              onPressed: () {
                router.routerDelegate.removeUtilUri(Uri(path: "/home"));
              },
              child: Text(
                "removeUtilUri: home"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
