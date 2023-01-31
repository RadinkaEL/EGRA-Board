import 'package:cloud_firestore/cloud_firestore.dart';

class Tools {
  static int getHighScore(List<int> score) {
    int result = 999999999999;

    for (var element in score) {
      if (element < result) {
        result = element;
      }
    }

    return result;
  }

  static List<int> toIntList(List scores) {
    return scores.map((e) => e as int).toList();
  }

  static List<QueryDocumentSnapshot<Object?>> sort(List<QueryDocumentSnapshot<Object?>> scores) {
    scores.sort( (a, b) {
        final scoreA =
            Tools.getHighScore(Tools.toIntList((a.data() as Map<String, dynamic>)['score'] as List));
        final scoreB =
            Tools.getHighScore(Tools.toIntList((b.data() as Map<String, dynamic>)['score'] as List)); 
        if (scoreA > scoreB) {
          return 1;
        }
        return 0;
      },
    );

    return scores;
  }
}
///sort score