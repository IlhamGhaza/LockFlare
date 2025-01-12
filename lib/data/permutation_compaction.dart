import 'dart:math' as math;
class PermutationAndCompaction {
  String steps = '';
  /// Method untuk proses enkripsi
  String encrypt(String input) {
    steps +=("\n=== [Permutation + Compaction - Encrypt] ===");
    steps +=("\nInput original: $input");

    // Handle padding untuk input < 8 karakter
    if (input.length < 8) {
      input = input.padRight(8, '0');
      steps +=("\nInput setelah padding: $input");
    }

    // Konversi ke biner
    String binaryInput = _toBinary(input);
    steps +=("\nBiner Input: $binaryInput");

    // Initial Permutation (IP)
    String permutedBinary = _initialPermutation(binaryInput);
    steps +=("\nBiner setelah Initial Permutation: $permutedBinary");

    // Kompaksi - ambil setengah dari hasil permutasi
    String compactedBinary =
        permutedBinary.substring(0, permutedBinary.length ~/ 2);
    steps +=("\nHasil setelah kompaksi: $compactedBinary");

    return compactedBinary;
  }

  /// Method untuk proses dekripsi
  String decrypt(String compactedInput) {
    steps +=("\n=== [Permutation + Compaction - Decrypt] ===");
    steps +=("\nInput terenkripsi: $compactedInput");

    // Duplikasi data yang telah dikompaksi untuk mengembalikan ke ukuran asli
    String expandedBinary = compactedInput + compactedInput;
    steps +=("\nBiner setelah ekspansi: $expandedBinary");

    // Inverse Initial Permutation
    String decryptedBinary = _inverseInitialPermutation(expandedBinary);
    steps +=("\nBiner setelah Inverse Initial Permutation: $decryptedBinary");

    // Konversi kembali ke teks
    String result = _binaryToText(decryptedBinary);
    steps +=("\nHasil dekripsi: $result");

    return result;
  }

  String toBinary(String input) {
    return _toBinary(input);
  }

  /// Private Method: Konversi teks ke biner
  String _toBinary(String text) {
    steps +=("\nMengonversi teks ke biner...");
    return text.codeUnits
        .map((char) => char.toRadixString(2).padLeft(8, '0'))
        .join();
  }

  /// Private Method: Konversi biner ke teks
  String _binaryToText(String binary) {
    steps +=("\nMengonversi biner ke teks...");
    List<String> chunks = _chunkString(binary, 8);
    return chunks
        .map((chunk) => String.fromCharCode(int.parse(chunk, radix: 2)))
        .join();
  }

  /// Private Method: Initial Permutation (IP)
  String _initialPermutation(String binary) {
    List<int> ipTable = [
      58,
      50,
      42,
      34,
      26,
      18,
      10,
      2,
      60,
      52,
      44,
      36,
      28,
      20,
      12,
      4,
      62,
      54,
      46,
      38,
      30,
      22,
      14,
      6,
      64,
      56,
      48,
      40,
      32,
      24,
      16,
      8,
      57,
      49,
      41,
      33,
      25,
      17,
      9,
      1,
      59,
      51,
      43,
      35,
      27,
      19,
      11,
      3,
      61,
      53,
      45,
      37,
      29,
      21,
      13,
      5,
      63,
      55,
      47,
      39,
      31,
      23,
      15,
      7
    ];
    return _permute(binary, ipTable);
  }

  /// Private Method: Inverse Initial Permutation (IP^-1)
  String _inverseInitialPermutation(String binary) {
    List<int> ipInverseTable = [
      40,
      8,
      48,
      16,
      56,
      24,
      64,
      32,
      39,
      7,
      47,
      15,
      55,
      23,
      63,
      31,
      38,
      6,
      46,
      14,
      54,
      22,
      62,
      30,
      37,
      5,
      45,
      13,
      53,
      21,
      61,
      29,
      36,
      4,
      44,
      12,
      52,
      20,
      60,
      28,
      35,
      3,
      43,
      11,
      51,
      19,
      59,
      27,
      34,
      2,
      42,
      10,
      50,
      18,
      58,
      26,
      33,
      1,
      41,
      9,
      49,
      17,
      57,
      25
    ];
    return _permute(binary, ipInverseTable);
  }

  /// Private Method: Permutasi
  String _permute(String input, List<int> table) {
    List<String> bits = input.split('');
    String result = '';
    for (int pos in table) {
      if (pos <= bits.length) {
        result += bits[pos - 1];
      } else {
        result += '0'; // Padding jika posisi melebihi panjang input
      }
    }
    return result;
  }

  /// Private Method: Membagi string menjadi chunks
  List<String> _chunkString(String str, int size) {
    List<String> chunks = [];
    for (var i = 0; i < str.length; i += size) {
      chunks.add(str.substring(i, math.min(i + size, str.length)));
    }
    return chunks;
  }
}
