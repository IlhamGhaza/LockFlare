class SubstitutionAndCompaction {
  final String alphabet;
  SubstitutionAndCompaction(this.alphabet);

  // Tabel substitusi sederhana
  final Map<String, String> substitutionTable = {
    'A': 'N', 'B': 'O', 'C': 'P', 'D': 'Q',
    'E': 'R', 'F': 'S', 'G': 'T', 'H': 'U',
    'I': 'V', 'J': 'W', 'K': 'X', 'L': 'Y',
    'M': 'Z', 'N': 'A', 'O': 'B', 'P': 'C',
    'Q': 'D', 'R': 'E', 'S': 'F', 'T': 'G',
    'U': 'H', 'V': 'I', 'W': 'J', 'X': 'K',
    'Y': 'L', 'Z': 'M', ' ': ' ' // Spasi tidak diubah
  };

  // Langkah substitusi
  String _substitute(String input) {
    return input.toUpperCase().split('').map((char) {
      return substitutionTable[char] ?? char; // Substitusi jika ada di tabel
    }).join('');
  }

  // Langkah compaction
  String _compact(String input) {
    List<String> compacted = [];
    for (int i = 0; i < input.length; i += 2) {
      if (i + 2 <= input.length) {
        compacted.add(input.substring(i, i + 2)); // Ambil setiap 2 karakter
      }
    }
    return compacted.join('');
  }

  // Konversi teks ke hexadecimal
  String _textToHex(String input) {
    return input.codeUnits
        .map((char) => char.toRadixString(16).padLeft(2, '0'))
        .join('');
  }

  // Fungsi enkripsi
  String encrypt(String input) {
    String hexInput = _textToHex(input);
    String substituted = _substitute(hexInput);
    String compacted = _compact(substituted);
    return compacted;
  }
}
