import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final String text;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  MyCheckbox({
    required this.text,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value!;
              widget.onChanged(value);
            });
          },
        ),
        Text(widget.text),
      ],
    );
  }
}
