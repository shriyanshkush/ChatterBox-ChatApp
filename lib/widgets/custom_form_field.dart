import 'package:flutter/material.dart';


class Customfields extends StatelessWidget {
  final String HintText;
  final double Height;
  final RegExp validationRegEx;
  final bool obsecuretext;
  final void Function(String?) onSaved;

  const Customfields({super.key,required this.HintText,
    required this.Height,
    required this.validationRegEx,
    this.obsecuretext=false,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Height,
      child: TextFormField(
        obscureText: obsecuretext,
        onSaved: onSaved,
        decoration: InputDecoration(
        hintText: HintText,
        border: const OutlineInputBorder(),
      ),
        validator: (value) {
        if(value !=null && validationRegEx.hasMatch(value)) {
          return null;
        }
        return "Enter a valid ${HintText.toLowerCase()}";
        },
      ),
    );
  }

}