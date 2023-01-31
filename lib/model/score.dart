class Score {
  final String name;
  final List<int> score;
  bool? isRenamed;
  bool? isNew;

  Score({
    required this.name,
    required this.score,
    this.isRenamed = false,
    this.isNew = false,
  });

  Score copyWith({
    String? name,
    List<int>? score,
    bool? isRenamed,
    bool? isNew,
  }) {
    return Score(
      name: name ?? this.name,
      score: score ?? this.score,
      isRenamed: isRenamed ?? this.isRenamed,
      isNew: isNew ?? this.isNew,
    );
  }
}
