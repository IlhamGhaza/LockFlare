class BlockingAndSubstitution {
  final String alphabet;
  BlockingAndSubstitution(this.alphabet);

  // Tabel substitusi sederhana
  final Map<String, String> substitutionTable = {
    'A': 'X', 'B': 'Y', 'C': 'Z', 'D': 'A',
    'E': 'B', 'F': 'C', 'G': 'D', 'H': 'E',
    'I': 'F', 'J': 'G', 'K': 'H', 'L': 'I',
    'M': 'J', 'N': 'K', 'O': 'L', 'P': 'M',
    'Q': 'N', 'R': 'O', 'S': 'P', 'T': 'Q',
    'U': 'R', 'V': 'S', 'W': 'T', 'X': 'U',
    'Y': 'V', 'Z': 'W', ' ': ' ' // Spasi tidak diubah
  };

  // Langkah blocking
  List<String> _block(String input, int blockSize) {
    List<String> blocks = [];
    for (int i = 0; i < input.length; i += blockSize) {
      blocks.add(input.substring(
          i, i + blockSize > input.length ? input.length : i + blockSize));
    }
    return blocks;
  }

  // Langkah substitusi
  String _substitute(String input) {
    return input.toUpperCase().split('').map((char) {
      return substitutionTable[char] ?? char; // Substitusi jika ada di tabel
    }).join('');
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
    List<String> blocks = _block(hexInput, 4); // Blok ukuran 4
    String substituted = blocks.map((block) => _substitute(block)).join('');
    return substituted;
  }
}
