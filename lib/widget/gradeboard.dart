import 'package:speproject1/model/score.dart';
import 'package:speproject1/utils/tools.dart';
import 'package:flutter/material.dart';

class Gradeboard extends StatelessWidget {
  final Score score;
  final int index;
  Gradeboard({super.key, required this.score, required this.index});

  final List<Color> rankColor = [
    Color(0xffD2AC47),
    Color(0xffC0C0C0),
    Color(0xff65350F),
    Color(0xff0DA2FF),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: ListTile(
        leading: leadingRank(context, index),
        title: Text(
          score.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black,
              ),
        ),
        trailing: Text(
          '${Tools.getHighScore(score.score)/1000}s',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Color(0xffE700DD),
              ),
        ),
      ),
    );
  }

  Widget leadingRank(BuildContext context, int rank) {
    if (rank < 3) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: rankColor[rank],
        child: Text(
          (rank + 1).toString(),
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      );
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: rankColor[3],
      child: Text(
        (rank + 1).toString(),
        style: Theme.of(context).textTheme.titleLarge!,
      ),
    );
  }
}
