import 'package:flutter/material.dart';

DropdownButtonFormField genderDropDown(
    {required value, required onChanged, size, validator}) {
  return DropdownButtonFormField(
      validator: validator,
      value: value,
      isExpanded: true,
      hint: Text(
        "Gender",
        style: TextStyle(fontSize: size),
      ),
      items: [
        DropdownMenuItem(
          value: "Male",
          child: Text("Male", style: TextStyle(fontSize: size)),
        ),
        DropdownMenuItem(
          value: "Female",
          child: Text("Female", style: TextStyle(fontSize: size)),
        ),
      ],
      onChanged: onChanged);
}

Widget statusDropDown({required value, required onChanged, size, validator}) {
  return DropdownButtonFormField(
      validator: validator,
      value: value,
      isExpanded: true,
      hint: Text(
        "Status",
        style: TextStyle(fontSize: size),
      ),
      items: [
        DropdownMenuItem(
          value: "Undergraduate",
          child: Text("Undergraduate", style: TextStyle(fontSize: size)),
        ),
        DropdownMenuItem(
          value: "Postgraduate",
          child: Text("Postgraduate", style: TextStyle(fontSize: size)),
        ),
        DropdownMenuItem(
          value: "Graduated",
          child: Text("Graduated", style: TextStyle(fontSize: size)),
        ),
      ],
      onChanged: onChanged);
}

Widget campusDropDown({required value, required onChanged, size, validator}) {
  return DropdownButtonFormField(
      validator: validator,
      value: value,
      isExpanded: true,
      hint: Text(
        "Campus",
        style: TextStyle(fontSize: size),
      ),
      items: [
        DropdownMenuItem(
          value: "Johor",
          child: Text("Johor", style: TextStyle(fontSize: size)),
        ),
        DropdownMenuItem(
          value: "Kuala Lumpur",
          child: Text("Kuala Lumpur", style: TextStyle(fontSize: size)),
        ),
        DropdownMenuItem(
          value: "Pagoh branch",
          child: Text("Pagoh branch", style: TextStyle(fontSize: size)),
        ),
      ],
      onChanged: onChanged);
}
