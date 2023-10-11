import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List options;
  final List<String> selectedOptionIds;
  final ValueChanged<List<String>> onSelect;
  const MultiSelectDropdown({
    Key? key,
    required this.options,
    required this.selectedOptionIds,
    required this.onSelect,
  }) : super(key: key);
  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List filteredOptions = [];
  TextEditingController searchController = TextEditingController();
  bool ontap = false;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
  }

  void onSelected(option) {
    setState(() {
      final index = widget.selectedOptionIds.indexOf(option.id);
      if (index != -1) {
        widget.selectedOptionIds.removeAt(index);
      } else {
        widget.selectedOptionIds.add(option.id);
      }
      widget.onSelect(widget.selectedOptionIds);
      searchController.clear();
      onSearchTextChanged(searchController.text);
    });
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredOptions = widget.options
          .where((option) =>
              option.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          onTap: () {
            onSearchTextChanged(searchController.text);
          },
          enabled: false,
          decoration: InputDecoration(
            hintText: widget.selectedOptionIds.isEmpty ? 'Select' : '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
              ),
            ),
            prefixIcon: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    for (var option in widget.options)
                      if (widget.selectedOptionIds.contains(option.id))
                        Chip(
                          label: Text(option.name),
                          onDeleted: () => onSelected(option),
                        ),
                  ],
                ),
              ),
            ),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 4.0),
        Expanded(
          child: ListView.builder(
            itemCount: filteredOptions.length,
            itemBuilder: (context, index) {
              final option = filteredOptions[index];
              return ListTile(
                title: Text(option.name),
                trailing: widget.selectedOptionIds.contains(option.id)
                    ? const Icon(Icons.check_circle,
                        color: Color.fromARGB(255, 1, 26, 47))
                    : null,
                onTap: () {
                  onSelected(option);
                  searchController.clear();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
