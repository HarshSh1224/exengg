import 'package:exengg/providers/categories_data.dart';
import 'package:flutter/material.dart';

class CategoryDropdownButton extends StatefulWidget {
  void Function(String) _saveFunction;
  String? initialValue;
  CategoryDropdownButton(this._saveFunction, [initValue = 'd1']) {
    initialValue = initValue;
  }

  // String titleFromId(String id) {
  //   int idx = categoriesData.indexWhere((element) => element['id' == id]);
  //   return categoriesData[idx]['title'];
  // }

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
            validator: (value) {
              if (value == null) {
                return 'Please choose a category';
              } else
                return null;
            },
            onSaved: (value) {
              print('SAVE DROPDOWNL');
              print('DROPDOWN VALUE' + (value == null ? 'null' : value));
              widget._saveFunction(value ?? 'null');
            },
            items: [
              ...categoriesData.map((cat) {
                return DropdownMenuItem(
                  // alignment: Alignment.centerRight,
                  child: Text(cat['title'],
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)),
                  value: cat['id'] as String,
                );
              }).toList(),
              // DropdownMenuItem(
              //   // alignment: Alignment.centerRight,
              //   child: Text('DRAFTER',
              //       style: TextStyle(
              //           color: Theme.of(context)
              //               .colorScheme
              //               .onSecondaryContainer)),
              //   value: 'DRAFTER',
              // ),
              // DropdownMenuItem(
              //   child: Text('Lab Coat / Apron',
              //       style: TextStyle(
              //           color: Theme.of(context)
              //               .colorScheme
              //               .onSecondaryContainer)),
              //   value: 'LABCOAT/APRON',
              // ),
              // DropdownMenuItem(
              //   child: Text('Miscellaneous',
              //       style: TextStyle(
              //           color: Theme.of(context)
              //               .colorScheme
              //               .onSecondaryContainer)),
              //   value: 'Miscellaneous',
              // ),
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
