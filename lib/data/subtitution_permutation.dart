class SubstitutionAndPermutation {
  final String substitutionKey;

  SubstitutionAndPermutation(this.substitutionKey);

  String encrypt(String input) {
    // Substitution: Ubah karakter menjadi karakter lain berdasarkan key
    String substituted = input
        .split('')
        .map((char) =>
            substitutionKey[char.codeUnitAt(0) % substitutionKey.length])
        .join('');

    // Permutation: Balik urutan teks
    return substituted.split('').reversed.join('');
  }

  String decrypt(String input) {
    // Reverse permutation
    String permuted = input.split('').reversed.join('');

    // Reverse substitution
    return permuted
        .split('')
        .map((char) => String.fromCharCode(substitutionKey.indexOf(char)))
        .join('');
  }
}
