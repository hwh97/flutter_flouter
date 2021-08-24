import 'package:flutter/material.dart';
import 'package:flutter_flouter_example/router/base_navigator.dart';

class Page2 extends StatefulWidget {
  final String? value;

  const Page2({Key? key, this.value}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            router.routerDelegate.pop("pop back from page2");
          },
        ),
        title: Text("page2"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("${widget.value}"),
            Text("$value"),
            TextButton(
              onPressed: () {
                router.routerDelegate.popAndPushUri(Uri(
                    path: "/page3", queryParameters: {"value": "push from page2"}));
              },
              child: Text("popAndPushUri"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "222",
        onPressed: () async {
          value = await router.routerDelegate.pushUri(Uri(
              path: "/page3", queryParameters: {"value": "push from page2"}));
          if (mounted)
            setState(() {
            });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
