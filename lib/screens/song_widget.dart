import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  SongWidget(this.song,{super.key});
  final Map<String, dynamic> song;
  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Row(children: [
        FadeInImage(
          placeholder: AssetImage('assets/placeholder.png'),
          image: NetworkImage(widget.song['cover']),
        ),
      ],
      ),
    );
}
}