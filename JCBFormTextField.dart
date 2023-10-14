import 'package:flutter/material.dart';
import 'package:flutterubertut/extensions/Colors.dart';
import 'package:flutterubertut/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class JCBFormTextField extends StatefulWidget {
  String label;
  double? width;
  TextFieldType textFieldType;
  TextInputAction? textInputAction;
  TextEditingController? controller;
  FocusNode? focus;
  FocusNode? nextFocus;
  bool? autoFocus;
  TextInputType? keyboardType;
  bool? labelSpace;
  FormFieldValidator<String>? validator;

  JCBFormTextField({
    this.controller,
    this.width,
    this.autoFocus,
    this.focus,
    required this.label,
    this.nextFocus,
    required this.textFieldType,
    this.textInputAction,
    this.keyboardType,
    this.labelSpace,
    this.validator
  });

  @override
  State<JCBFormTextField> createState() => _JCBFormTextFieldState();
}

class _JCBFormTextFieldState extends State<JCBFormTextField> {
  String checkText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        checkText != ''
            ? Text(widget.label, style: boldTextStyle(color: jcbGreyColor, size: 14))
            : widget.labelSpace.validate()
                ? Text('', style: boldTextStyle(size: 14))
                : Offstage(),
        widget.labelSpace.validate() ? 6.height : Offstage(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color:  jcbSecBorderColor),
            borderRadius: radius(jcbButtonRadius),
          ),
          width: widget.width ?? context.width() - 32,
          child: AppTextField(
            validator: widget.validator,
            keyboardType: widget.keyboardType ?? TextInputType.name,
            autoFocus: widget.autoFocus ?? false,
            controller: widget.controller,
            focus: widget.focus,
            nextFocus: widget.nextFocus,
            textFieldType: widget.textFieldType,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            textStyle: boldTextStyle(),
            onChanged: (val) {
              checkText = val;
              setState(() {});
            },
            suffixPasswordInvisibleWidget: Offstage(),
            suffixPasswordVisibleWidget: Offstage(),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.label,
              hintStyle: boldTextStyle(color: jcbGreyColor, size: 14),
            ),
          ),
        )
      ],
    );
  }
}
