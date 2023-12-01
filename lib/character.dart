import 'package:flutter/material.dart';

class CharacterSelection extends StatefulWidget {
  final String groupValue;
  final Function(String) onChanged;
  const CharacterSelection(this.groupValue, this.onChanged);

  @override
  State<CharacterSelection> createState() => _CharacterSelectionState();
}

class _CharacterSelectionState extends State<CharacterSelection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: 
          ListTile(
            title: const Text('RD'),
            leading: Radio<String>(
              value: 'RD',
              groupValue: widget.groupValue,
              onChanged: (value) {
                widget.onChanged(value.toString());
              },
            ),
          ),
        ),
        Expanded(child:
          ListTile(
            title: const Text('供應商'),
            leading: Radio<String>(
              value: "Supplier",
              groupValue: widget.groupValue,
              onChanged: (value) {
                widget.onChanged(value.toString());
              },
            ),
          ),
        ),
        Expanded(child:
          ListTile(
            title: const Text('採購'),
            leading: Radio<String>(
              value: "PD",
              groupValue: widget.groupValue,
              onChanged: (value) {
                widget.onChanged(value.toString());
              },
            ),
          ),
        ),
      ],
    );
  }
}
