import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<Enum> enumList;
  final Enum? value;
  final String label;
  final void Function(Enum?)? onChanged;
  const CustomDropdownButton(
      {Key? key,
      required this.enumList, this.value,
      this.onChanged,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<Enum>(
            value: value,
            elevation: 16,
            borderRadius: BorderRadius.circular(12),
            isExpanded: true,
            style: const TextStyle(color: Color(0xff3843d9)),
            onChanged: onChanged,
            hint:  Text("Select $label"),
            underline: const SizedBox(),
            items: enumList.map<DropdownMenuItem<Enum>>((Enum value) {
              return DropdownMenuItem<Enum>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
