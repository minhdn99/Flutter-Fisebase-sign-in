import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Enter Address',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 15,
            top: 15,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
            iconSize: 30,
          ),
        ),
      ),
    );
  }
}
