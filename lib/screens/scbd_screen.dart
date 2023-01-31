import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speproject1/facade/score_facade.dart';
import 'package:speproject1/model/score.dart';
import 'package:speproject1/utils/tools.dart';
import 'package:speproject1/widget/gradeboard.dart';
import 'package:flutter/material.dart';

class ScbdScreen extends StatefulWidget {
  const ScbdScreen({super.key});

  @override
  State<ScbdScreen> createState() => _ScbdScreenState();
}

class _ScbdScreenState extends State<ScbdScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int old = 0;
    bool isFirstLoading = true;

    final ScoreFacade scoreFacade = ScoreFacade();
    //ngubah data di firebase
    final Stream<QuerySnapshot> usersStream = scoreFacade.stream();

    ///streaming data dari firebase real time

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY SCORES'),
        backgroundColor: Color(0xff1167B1),
        centerTitle: true,
      ),
      backgroundColor: Color(0xff485063),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          ///jika ada data error, akan ada warning

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          ///jika berhasil maka akan ada logo loading circle

          if (!isFirstLoading) {
            if (snapshot.data!.docs.length != old) {
              Score score;

              for (var element in snapshot.data!.docs) {
                final dump =
                    (element.data() as Map<String, dynamic>)['score'] as List;
                score = Score(
                  name: element.id,
                  score: Tools.toIntList(dump),
                  isRenamed: (element.data()
                      as Map<String, dynamic>)['isRenamed'] as bool?,
                  isNew: (element.data() as Map<String, dynamic>)['isNew']
                      as bool?,
                );

                if (score.isNew ?? false) {
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Data changed'),
                          content: const Text('New data has been added'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    ).then((value) {
                      for (var element in snapshot.data!.docs) {
                        final dump = (element.data()
                            as Map<String, dynamic>)['score'] as List;

                        final Score score = Score(
                          name: element.id,
                          score: Tools.toIntList(dump),
                          isRenamed: (element.data()
                              as Map<String, dynamic>)['isRenamed'] as bool?,
                          isNew: (element.data()
                              as Map<String, dynamic>)['isNew'] as bool?,
                        );

                        if (score.isNew == null) {
                          break;
                        }

                        if (score.isNew!) {
                          scoreFacade.changeName(context, score, _controller);
                        }
                      }
                    });
                  });
                }
              }
            }
          }

          isFirstLoading = false;

          old = snapshot.data!.docs.length;
          final data = Tools.sort(snapshot.data!.docs);

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final dump =
                  (data[index].data() as Map<String, dynamic>)['score'] as List;

              final Score score = Score(
                name: data[index].id,
                score: Tools.toIntList(dump),
                isRenamed: (data[index].data()
                    as Map<String, dynamic>)['isRenamed'] as bool?,
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (score.isRenamed == true) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'You cannot change name of this score'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      return;
                    }

                    scoreFacade.changeName(context, score, _controller);
                  },
                  child: Gradeboard(score: score, index: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
