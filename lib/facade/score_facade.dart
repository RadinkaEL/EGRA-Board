import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speproject1/model/score.dart';
import 'package:speproject1/utils/tools.dart';
import 'package:flutter/material.dart';

class ScoreFacade {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final ScoreFacade _instance = ScoreFacade._();

  factory ScoreFacade() {
    return _instance;
  }

  ScoreFacade._();

  Stream<QuerySnapshot> stream() {
    return _firestore.collection('scores').snapshots();
  }

  Future<Score> update(Score score) async {
    _firestore.collection('scores').doc(score.name).set({
      'isRenamed': true,
      'isNew': false,
      'score': score.score,
    });

    return score;
  }
  //update data dari firestore

  Future<Score?> get(String name) async {
    final dump = await _firestore.collection('scores').doc(name).get();

    if (dump.data() == null) {
      return null;
    }

    return Score(
      name: name,
      score: (dump.data()!['score'] as List).map((e) => e as int).toList(),
      isRenamed: dump.data()!['isRenamed'] as bool,
      isNew: dump.data()!['isNew'] as bool,
    );
  }
  ///untuk alamat di firestore

  Future<bool> delete(String name) async {
    await _firestore.collection('scores').doc(name).delete();

    return true;
  }
  //untuk mendeleted

  void changeName(
      BuildContext context, Score score, TextEditingController controller) {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      showDialog(
        context: context,
        builder: (context) {
          controller.text = score.name;
          return AlertDialog(
            title: const Text('Change name'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  controller.text = '';
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              //untuk button cancel isi username
              TextButton(
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: const Text('Name cannot be empty'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                            //untuk text button ok setelah warning
                          ],
                        );
                      },
                    );

                    return;
                  }

                  final now = await get(controller.text);
                  if (now != null) {
                    await delete(score.name);

                    await update(score.copyWith(
                      name: controller.text,
                      score: [
                        ...now.score,
                        Tools.getHighScore(score.score)
                      ],
                    )).then((value) {
                      controller.text = '';
                      Navigator.pop(context);
                    });
                    //menambahkan data setelah di filter

                    return;
                  }

                  await delete(score.name);
                  //untuk mendeleted data yang baru dari IoT

                  await update(score.copyWith(
                    name: controller.text,
                    score: [Tools.getHighScore(score.score)],
                  )).then((value) {
                    controller.text = '';
                    Navigator.pop(context);
                  });
                  //untuk create board barunya.
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
