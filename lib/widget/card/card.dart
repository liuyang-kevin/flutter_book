import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const CustomCardWidget({
    Key key,
    this.title = "",
    this.subTitle = "",
    this.icon = Icons.album,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      //z轴的高度，设置card的阴影
      elevation: 1.50,
      //设置shape，这里设置成了R角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
      clipBehavior: Clip.antiAlias,
      semanticContainer: false,
      child: _tileChild,
    );
  }

  Widget get _tileChild {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: ListTile(
            // leading: Icon(icon, size: 36),
            title: Text(title),
            subtitle: Text(
              subTitle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  getChild() {
    return Container(
      color: Colors.deepPurpleAccent,
      alignment: Alignment.center,
      child: Text(title, style: TextStyle(fontSize: 28, color: Colors.white)),
    );
  }
}
