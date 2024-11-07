import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';

class Dropyy extends StatefulWidget {
  final List<String> dropItems;
  final String hintText;
  final TextEditingController controller; // Text controller to hold the value
  final void Function(String)? onChanged;

  const Dropyy({
    super.key, 
    required this.hintText, 
    required this.dropItems, 
    required this.controller, // TextEditingController required
    this.onChanged,
  });

  @override
  _DropyyState createState() => _DropyyState();
}

class _DropyyState extends State<Dropyy> {
  String? selectedValue; // To hold the currently selected value

  @override
  void initState() {
    super.initState();
    // Initialize selectedValue with controller's text if it's a valid value from the dropItems
    if (widget.dropItems.contains(widget.controller.text)) {
      selectedValue = widget.controller.text;
    } else {
      selectedValue = null;
    }
  }

  @override
  void didUpdateWidget(Dropyy oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selectedValue when the controller text changes
    if (widget.controller.text != selectedValue) {
      if (widget.dropItems.contains(widget.controller.text)) {
        setState(() {
          selectedValue = widget.controller.text;
        });
      } else {
        setState(() {
          selectedValue = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a unique set of dropItems while preserving the original order
    final uniqueDropItems = widget.dropItems.toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 7),
              Text(
                widget.hintText,
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: uniqueDropItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(value, textAlign: TextAlign.right),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
              widget.controller.text = value ?? ''; // Update controller with selected value
            });

            widget.onChanged?.call(value!); // Call the onChanged callback with selected value
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: primaryColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
