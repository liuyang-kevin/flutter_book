import 'package:app_lib/app_lib.dart';
import 'package:book_demos/common.dart';
import 'package:book_demos/engine/md_parser.dart';
import 'package:book_demos/util/responsive.dart';
import 'package:book_demos/widget/card/card.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class AppHomePage extends StatefulPage {
  AppHomePage();

  @override
  ReduxState<Object, StatefulWidget> createState() => _AppHomePageState();
}

class _PageVM {
  _PageVM(this.title, this.onTap, {this.subTitle = ''});

  String title;
  String subTitle;
  Function(BuildContext) onTap;
}

class _AppHomePageState extends ReduxState<int, AppHomePage> with SingleTickerProviderStateMixin {
  var bookChapters = <_PageVM>[
    _PageVM("路由回调监听事件", (ctx) => App.goNext(ctx, navKeys.sampleScaffoldRouteAware), subTitle: '根据log查看路由的pop，push回调事件'),
  ];
  var myTabs = <Tab>[
    Tab(text: '目录'),
    Tab(text: 'Readme.md'),
  ];

  TabController _tabController;

  final _mdWidgets = <Widget>[];
  var parser;

  @override
  int initViewModel() => 0;

  @override
  void initState() {
    super.initState();
    parser = MarkdownParser(_mdWidgets, () => setState(() {}));
    MarkdownParser.parserMarkdown('README.md', parser);
    _tabController = TabController(vsync: this, length: myTabs.length);

    () async {
      print(await AppLib.api());
    }();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo与总结'),
        bottom: TabBar(
          controller: _tabController, // only if DefaultTabController is not used
          tabs: myTabs,
        ),
      ),
      body: DefaultTabController(
        length: myTabs.length,
        initialIndex: 1, // default is 0
        child: TabBarView(
          controller: _tabController,
          children: [
            Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveWidget.isMobileScreen(context) ? 1 : 3, //列
                  childAspectRatio: 6.4, //显示区域宽高相等
                ),
                itemCount: bookChapters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: CustomCardWidget(
                      title: bookChapters[index].title,
                      subTitle: bookChapters[index].subTitle,
                    ),
                    onTap: () => bookChapters[index].onTap(context),
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _mdWidgets,
            )
          ],
        ),
      ),
    );
  }
}
