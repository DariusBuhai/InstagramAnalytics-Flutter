import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class InputField extends StatefulWidget{
  final String text;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  TextEditingController controller;
  final Function(String) onChanged;
  final Function onSubmitted;
  final double borderRadius;
  final double height;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  FocusNode focusNode;
  String value;

  InputField({Key key,
    this.text = "",
    this.icon = Icons.search,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius = 10,
    this.height = 45,
    this.autofocus = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.value
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController controller;

  @override
  void initState() {
    if (widget.controller == null) {
      controller = TextEditingController(text: widget.value);
    } else {
      widget.controller.text = widget.value;
      controller = widget.controller;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(Platform.isIOS){
      return SizedBox(
        height: widget.height,
        child: CupertinoTextField(
          controller: controller,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          onSubmitted: (_){
            if(widget.onSubmitted!=null) {
              widget.onSubmitted();
            }
          },
          textCapitalization: widget.textCapitalization,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.onSubmitted==null ? TextInputAction.next : TextInputAction.done,
          onChanged: (val){
            if(widget.onChanged!=null)
              widget.onChanged(val);
          },
          style: TextStyle(
              color: Theme.of(context).textTheme.subtitle2.color
          ),
          placeholder: widget.text,
          prefix: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(
              widget.icon,
              color: Theme.of(context).textTheme.subtitle2.color,
              size: 18,
            ),
          ),
          clearButtonMode: OverlayVisibilityMode.never,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 0),
          child: TextField(
            onSubmitted: (_){
              if(widget.onSubmitted!=null) {
                widget.onSubmitted();
              }
            },
            textInputAction: widget.onSubmitted==null ? TextInputAction.next : TextInputAction.done,
            enableInteractiveSelection: true,
            enableSuggestions: true,
            obscureText: widget.obscureText,
            controller: controller,
            textCapitalization: widget.textCapitalization,
            autofocus: widget.autofocus,
            focusNode: widget.focusNode,
            onChanged: (val){
              if(widget.onChanged!=null) {
                widget.onChanged(val);
              }
            },
            style: TextStyle(
                color: Theme.of(context).textTheme.subtitle2.color
            ),
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.text,
                hintStyle: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.subtitle2.color
                ),
                contentPadding:
                const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 12,
                    top: 13
                ),
                prefixIcon: Icon(
                  widget.icon,
                  color: Theme.of(context).textTheme.subtitle2.color,
                  size: 18,
                )),

          ),
        ),
      ),
    );
  }

}