import 'dart:io';

Future<void> main() async {
  File pokelist = File('pokemon_en_fr.csv');

  if (!await pokelist.exists()) {
    print('Missing pokemon_en_fr.csv !');
    exit(0);
  }

  List<String> pokeLines = await pokelist.readAsLines();

  Map<int, String> pokemap = <int, String>{};

  for (var e in pokeLines) {
    if (e.isEmpty) continue;

    var exploded = e.trim().split(';');

    int? i = int.tryParse(exploded.first);

    if (i == null) continue;

    pokemap[i] = exploded.last;
  }

  print('Hello, welcome into Pokemon Box');
  print('Please entrer a Pokemon ID (national dex) or exit');
  print(
      'You may also type oldbox or newbox to change the box size from 30 to 20 and 20 to 30');

  int boxSize = 30;

  List<int> oldGenTable = <int>[4, 5];
  List<int> newGenTable = <int>[6, 5];

  print('Enter your id :');
  String? input = stdin.readLineSync(retainNewlines: true);

  do {
    if (input == null) continue;

    var toLowerCase = input.trim().toLowerCase();

    int? index = int.tryParse(toLowerCase);

    if (index != null) {
      if (index <= 0) {
        print('A pokemon index can\'t be inferior to 1 or negative');
        continue;
      }

      String pokemonName = '';

      if (pokemap.containsKey(index)) {
        pokemonName = pokemap[index]!;
      }

      int box = (index / boxSize).ceilToDouble().toInt();
      int pos = index % boxSize;

      pos = pos == 0 ? 30 : pos;

      var printedResult = pokemonName == ''
          ? 'Pokemon $index : $box @ $pos'
          : 'Pokemon $index : $pokemonName : $box @ $pos';

      print(printedResult);

      late int x, y;

      switch (boxSize) {
        case 30:
          x = newGenTable.first;
          y = newGenTable.last;
          break;
        case 20:
          x = oldGenTable.first;
          y = oldGenTable.last;
          break;
      }

      int caseIndex = 1;
      StringBuffer outputBuffer = StringBuffer();
      for (int lines = 0; lines < y; lines++) {
        for (int columns = 0; columns < x; columns++) {
          String symbol = caseIndex == pos ? 'X' : '_';

          outputBuffer.write(' [ $symbol ] ');
          caseIndex++;
        }

        print(outputBuffer.toString());
        outputBuffer.clear();
      }
    } else {
      switch (toLowerCase) {
        case 'exit':
          exit(1);
        case 'oldbox':
          boxSize = 20;
          print('Box size changed to old format: 20 slots');
          break;
        case 'newbox':
          print('Box size changed to new format : 30 slots');
          break;
      }
    }

    print('Enter your id :');
    input = stdin.readLineSync();
  } while (input != null && input.toLowerCase() != 'exit');
}
