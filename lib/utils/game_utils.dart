import 'dart:developer';

class GameMode {
  static const int FIVE = 5;
  static const int SIX = 6;
  static const int SEVEN = 7;
}

class GameUtils {
  static List<Map<String, dynamic>> mergeHistory(
      List<List<Map<String, dynamic>>> history) {
    return [
      ...history.map((e) => [...e.map((m) => Map<String, dynamic>.from(m))])
    ].fold([], (result, letters) {
      for (var letter in letters) {
        final idx = result.indexWhere((e) => e['letter'] == letter['letter']);
        if (idx == -1) {
          result.add(letter);
        } else if (result[idx]['result'] < letter['result']) {
          result[idx]['result'] = letter['result'];
        }
      }
      return result;
    });
  }

  static List<Map<String, dynamic>> validateInput(
      String word, List<String> input) {
    // String copyWord = word;
    List<Map<String, dynamic>> result =
        input.map((v) => {'letter': v, 'result': 0}).toList();
    for (int i = 0; i < result.length; i++) {
      if (word.indexOf(result[i]['letter']) == i) {
        result[i]['result'] = 2;
        word = word.substring(0, i) + 'X' + word.substring(i + 1);
      }
    }
    for (int i = 0; i < result.length; i++) {
      if (word.contains(result[i]['letter']) && (result[i]['result'] != 2)) {
        result[i]['result'] = 1;
        final index = word.indexOf(result[i]['letter']);
        word = word.substring(0, index) + 'X' + word.substring(index + 1);
      }
    }
    log(word);
    return result;
  }

  static String getModeText(int mode) {
    switch (mode) {
      case GameMode.FIVE:
        return '오';
      case GameMode.SIX:
        return '육';
      case GameMode.SEVEN:
        return '칠';
      default:
        return '';
    }
  }
}
