import 'package:flutter/material.dart';

class MultiSelectDropdownFormField extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String>? initialValue;
  final void Function(List<String>)? onChanged;

  const MultiSelectDropdownFormField({
    Key? key,
    required this.label,
    required this.options,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _MultiSelectDropdownFormFieldState createState() =>
      _MultiSelectDropdownFormFieldState();
}

class _MultiSelectDropdownFormFieldState
    extends State<MultiSelectDropdownFormField> {
  List<String>? _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialValue ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: _selectedValues,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
                labelText: widget.label,
              ),
              items: widget.options
                  .map(
                    (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ),
              )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  if (_selectedValues!.contains(newValue)) {
                    _selectedValues!.remove(newValue);
                  } else {
                    _selectedValues!.add(newValue!);
                  }
                });
                widget.onChanged?.call(_selectedValues!);
                state.didChange(_selectedValues);
              },
              value: _selectedValues!.isNotEmpty ? _selectedValues![0] : null,
              isExpanded: true,
              iconSize: 30.0,
            ),
            Text(
              state.errorText ?? '',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
              ),
            ),
          ],
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select at least one option';
        }
        return null;
      },
    );
  }
}
