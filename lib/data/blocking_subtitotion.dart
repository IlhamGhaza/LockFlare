class BlockingAndSubstitution {
  final String substitutionKey;

  BlockingAndSubstitution(this.substitutionKey);

  String encrypt(String input) {
    // Split input into blocks of 3
    List<String> blocks = [];
    for (int i = 0; i < input.length; i += 3) {
      blocks
          .add(input.substring(i, i + 3 > input.length ? input.length : i + 3));
    }

    // Substitution on each block
    String result = blocks.map((block) {
      return block
          .split('')
          .map((char) =>
              substitutionKey[char.codeUnitAt(0) % substitutionKey.length])
          .join('');
    }).join('');

    return result;
  }

  String decrypt(String input) {
    // Reverse substitution
    return input
        .split('')
        .map((char) => String.fromCharCode(substitutionKey.indexOf(char)))
        .join('');
  }
}
