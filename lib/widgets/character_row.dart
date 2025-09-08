import 'package:flutter/material.dart';
import '../models/character.dart';
import '../widgets/attribute_widget.dart';

class CharacterRow extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterRow({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 200.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: rowHeight,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(-10, 0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..rotateY(0.0262), 
                child: Container(
                  height: 190,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-44, 0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..rotateY(0.1396),
                child: Container(
                  height: 170,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(-30, 0),
                child: Hero(
                  tag: 'character-${character.name}',
                  child: Image.asset(
                    character.image,
                    width: rowHeight,
                    height: rowHeight,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 58),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AttributeWidget(
                        progress: character.speed,
                        size: 50.0,
                        child: Icon(
                          Icons.speed,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Flexible(
                      child: AttributeWidget(
                        progress: character.health,
                        size: 50.0,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Flexible(
                      child: AttributeWidget(
                        progress: character.attack,
                        size: 50.0,
                        child: Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 24,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(
                          'FIGHT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}