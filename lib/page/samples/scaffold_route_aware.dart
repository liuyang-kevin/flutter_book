import 'package:book_demos/util/quick_pop_page.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class ScaffoldRouteAware extends StatefulWidget {
  ScaffoldRouteAware();
  @override
  State createState() => _ScaffoldRouteAwareState();
}

class _ScaffoldRouteAwareState extends State<ScaffoldRouteAware> implements RouteAware {
  var msg = <String>[];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("RouteAware 回调测试 - 监听路由状态"),
          Expanded(
            child: ListView.builder(
              itemCount: msg.length,
              itemBuilder: (context, index) => Text(msg[index]),
            ),
          ),
          RaisedButton(child: Text("下一页"), onPressed: () => quickToolPageForPop(context)),
        ],
      ),
    );
  }

  /// 这些回调函数 不能使用Overlay的操作，因为路由正在执行
  @override
  void didPop() {
    msg.add("this:${this.hashCode} TODO: implement didPop");
    // Toast.show("this:${this.hashCode} TODO: implement didPop");
    print("this:${this.hashCode} TODO: implement didPop");
    setState(() {});
  }

  @override
  void didPopNext() {
    msg.add("this:${this.hashCode} TODO: implement didPopNext");
    // Toast.show("this:${this.hashCode} TODO: implement didPopNext");
    print("this:${this.hashCode} TODO: implement didPopNext");
    setState(() {});
  }

  @override
  void didPush() {
    msg.add("this:${this.hashCode} TODO: implement didPush");
    // Toast.show("this:${this.hashCode} TODO: implement didPush");
    print("this:${this.hashCode} TODO: implement didPush");
    setState(() {});
  }

  @override
  void didPushNext() {
    msg.add("this:${this.hashCode} TODO: implement didPushNext");
    // Toast.show("this:${this.hashCode} TODO: implement didPushNext");
    print("this:${this.hashCode} TODO: implement didPushNext");
    setState(() {});
  }
}
