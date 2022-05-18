import 'package:instagram_analytics/utils/functions.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../input_done_view.dart';

class TileDatePicker extends StatefulWidget {
  final String text;
  DateTime value;
  final Function(DateTime) onChanged;
  final IconData icon;
  final Widget child;

  TileDatePicker({Key key,
    @required this.text,
    this.value,
    this.icon,
    this.child,
    this.onChanged
  }) : super(key: key);

  @override
  State<TileDatePicker> createState() => TileDatePickerState();
}

class TileDatePickerState extends State<TileDatePicker>{
  @override
  Widget build(BuildContext context) {
    // if there is no icon, show text only,
    // otherwise show row
    Widget content = Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Icon(
                  widget.icon,
                  color: Theme.of(context).primaryColorLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.subtitle2.fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColorLight
                ),
              ),
              Text(
                parseDateToString(widget.value),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: Theme.of(context).textTheme.subtitle2.fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.subtitle2.color
                ),
              ),
            ],
          ),
          flex: 5,
        ),
        const SizedBox(width: 7)
      ],
    );

    return GestureDetector(
      onTap: _showSelector,
      child: Container(
        margin: const EdgeInsets.only(
          top: 4,
          bottom: 4,
        ),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
              horizontal: 20
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(BORDER_RADIUS),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              content,
            ],
          ),
        ),
      ),
    );

  }

  void _showSelector(){
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: 350,
              child: Column(
                children: <Widget>[
                  inputDoneView(context, callback: (){
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 300,
                    child: CupertinoDatePicker(
                      initialDateTime: widget.value,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime value) {
                        setState(() {
                          widget.value = value;
                        });
                        if(widget.onChanged!=null) {
                          widget.onChanged(value);
                        }
                      },
                    ),
                  )
                ],
              )
          );
        });
  }

}