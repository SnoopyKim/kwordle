class Word {
  String word;
  String letters;
  String definition;

  Word(this.word, this.letters, this.definition);

  factory Word.fromMap(Map<dynamic, dynamic> map) => Word(
        map['word'],
        map['letters'],
        map['definition'],
      );
}
