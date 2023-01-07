import 'package:flutter/material.dart';

class CategoryDropdownButton extends StatefulWidget {
  void Function(String) _saveFunction;
  String? initialValue;
  CategoryDropdownButton(this._saveFunction, [initValue = 'd1']) {
    if (initValue == 'd2') {
      initialValue = 'Lab Coat';
    } else if (initValue == 'd3') {
      initialValue = 'Others';
    } else {
      initialValue = 'Drafter';
    }
  }

  @override
  State<CategoryDropdownButton> createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  @override
  Widget build(BuildContext context) {
    String? _dropDownValue = widget.initialValue;
    return Container(
      width: double.infinity,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
            dropdownColor: Theme.of(context).colorScheme.primaryContainer,
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            borderRadius: BorderRadius.circular(4),
            isExpanded: true,
            hint: Text(
              'Choose a category',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            onSaved: (value) {
              widget._saveFunction(value!);
            },
            items: [
              DropdownMenuItem(
                // alignment: Alignment.centerRight,
                child: Text('Drafter',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)),
                value: 'Drafter',
              ),
              DropdownMenuItem(
                child: Text('Lab Coat / Apron',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)),
                value: 'Lab Coat',
              ),
              DropdownMenuItem(
                child: Text('Others',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)),
                value: 'Others',
              ),
            ],
            value: _dropDownValue,
            onChanged: (value) {
              setState(() {
                _dropDownValue = value;
              });
            }),
      ),
    );
  }
}
