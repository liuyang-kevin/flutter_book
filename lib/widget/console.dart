import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

mixin DebugConsole<T extends StatefulWidget> on State<T> implements RouteAware {
  bool get debugMode => true;
  var debugKey = UniqueKey();
  Widget get debugWidget => Container();
  OverlayEntry _overlayEntry;
  @override
  void initState() {
    if (debugMode) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
        _overlayEntry = _Console.initOverlayEntry('${this.runtimeType}', debugWidget);
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    App.routeObserver.unsubscribe(this);
    // _Console.dispose(_overlayEntry);
    super.dispose();
  }

  void didPopNext() {
    print('didPopNext');
  }

  void didPush() {
    print('didPush');
  }

  void didPop() {
    print('didPop');
  }

  void didPushNext() {
    print('didPushNext');
  }
}

abstract class ConsoleLayoutManager {
  LayoutBuilder buildLayout(Widget child);
}

class _DefaultLayoutManager extends ConsoleLayoutManager {
  double consoleW = double.infinity;
  double consoleH = double.infinity;
  @override
  LayoutBuilder buildLayout(Widget child) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: consoleW,
            height: consoleH,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                child: Material(
                  color: Colors.black87,
                  child: Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(16),
                    child: child,
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                child: RawMaterialButton(
                  onPressed: () {
                    if (consoleW == 0) {
                      consoleW = double.infinity;
                      consoleH = double.infinity;
                    } else {
                      consoleW = 0;
                      consoleH = 0;
                    }
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(Icons.info, size: 16.0),
                  padding: EdgeInsets.all(2.0),
                  shape: CircleBorder(),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _Console {
  static final _qMsg = Queue<String>();

  /// 回调函数是动画可用时常
  static ConsoleLayoutManager defaultLayoutManager = _DefaultLayoutManager();

  /// 利用App中的nav globalkey的overlay显示toast，
  ///
  /// layoutBuilder可以覆盖原始逻辑，delayTime 延迟时间负责硬消失，动画可以在layout中实现。
  static OverlayEntry initOverlayEntry(String msg, Widget child, {ConsoleLayoutManager mgr, int delayTime = 2000}) {
    if (msg == null || msg == '') {
      msg = '网络开小差了,请检查网络';
    }
    var _delayTime = delayTime ?? 2000;
    var _layourMgr = mgr ?? defaultLayoutManager;

    var overlayEntry = OverlayEntry(builder: (context) => _layourMgr.buildLayout(child));
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      // 开始动画，拥有全部时常
      // Future.delayed(Duration.zero, () => _layourMgr.onStartAnim(_delayTime));
    });

    App.navKey.currentState.overlay.insert(overlayEntry);

    // 等待三分之二的时间，
    // 继续动画开始，或者，结束动画开始，拥有三分之一剩余时长
    Future.delayed(Duration(milliseconds: _delayTime - (_delayTime ~/ 3)), () {
      // _loopRemainMessage(overlayEntry, (_delayTime ~/ 3), _layourMgr);
    });

    return overlayEntry;
  }

  static dispose(OverlayEntry overlayEntry) {
    overlayEntry.remove();
  }

  // /// 根据msg的队列长度递归延迟显示toast
  // static void _loopRemainMessage(OverlayEntry overlayEntry, int remainTime, ConsoleLayoutManager mgr) {
  //   if (_qMsg.isNotEmpty) {
  //     var nextMsg = _qMsg.removeFirst();
  //     Future.delayed(Duration.zero, () => mgr.onContinueAnim(nextMsg, remainTime));
  //     Future.delayed(Duration(milliseconds: remainTime), () {
  //       _loopRemainMessage(overlayEntry, remainTime, mgr);
  //     });
  //   } else {
  //     Future.delayed(Duration.zero, () => mgr.onRemoveAnim(remainTime));
  //     Future.delayed(Duration(milliseconds: remainTime), () {
  //       overlayEntry.remove();
  //       _showing = false;
  //     });
  //   }
  // }
}
