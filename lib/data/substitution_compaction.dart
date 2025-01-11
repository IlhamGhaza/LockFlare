class SubstitutionAndCompaction {
  final String substitutionKey;

  SubstitutionAndCompaction(this.substitutionKey);

  String encrypt(String input) {
    // Substitution
    String substituted = input
        .split('')
        .map((char) =>
            substitutionKey[char.codeUnitAt(0) % substitutionKey.length])
        .join('');

    // Compaction: Remove spaces
    return substituted.replaceAll(' ', '');
  }

  String decrypt(String input) {
    // Reverse substitution
    return input
        .split('')
        .map((char) => String.fromCharCode(substitutionKey.indexOf(char)))
        .join('');
  }
}
