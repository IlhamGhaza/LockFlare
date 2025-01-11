class PermutationAndCompaction {
  // Pola permutasi sederhana
  final List<int> permutationPattern = [
    2,
    0,
    3,
    1
  ]; // Contoh pola untuk permutasi

  // Langkah permutasi
  String _permute(String input) {
    List<String> permutedBlocks = [];
    int blockSize = permutationPattern.length;

    // Bagi input menjadi blok-blok sesuai ukuran pola
    for (int i = 0; i < input.length; i += blockSize) {
      String block = input.substring(
          i, i + blockSize > input.length ? input.length : i + blockSize);
      if (block.length == blockSize) {
        permutedBlocks.add(String.fromCharCodes(
            permutationPattern.map((index) => block.codeUnitAt(index))));
      } else {
        permutedBlocks.add(block);
      }
    }

    return permutedBlocks.join('');
  }

  // Langkah compaction (menggabungkan blok-blok)
  String _compact(String input) {
    // Ambil 2 karakter hexa (16 bit) dan gabungkan menjadi 1 byte
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
    String permuted = _permute(hexInput);
    String compacted = _compact(permuted);
    return compacted;
  }
}
