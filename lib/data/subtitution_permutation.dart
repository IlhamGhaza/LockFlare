import 'dart:convert';

class SubstitutionAndPermutation {
  final String alphabet;

  SubstitutionAndPermutation(this.alphabet);

  // Tabel substitusi sederhana (bisa diubah sesuai kebutuhan)
  final Map<String, String> substitutionTable = {
    'A': 'Q', 'B': 'W', 'C': 'E', 'D': 'R',
    'E': 'T', 'F': 'Y', 'G': 'U', 'H': 'I',
    'I': 'O', 'J': 'P', 'K': 'A', 'L': 'S',
    'M': 'D', 'N': 'F', 'O': 'G', 'P': 'H',
    'Q': 'J', 'R': 'K', 'S': 'L', 'T': 'Z',
    'U': 'X', 'V': 'C', 'W': 'V', 'X': 'B',
    'Y': 'N', 'Z': 'M', ' ': ' ' // Spasi tidak diubah
  };

  // Langkah substitusi
  String _substitute(String input) {
    return input.toUpperCase().split('').map((char) {
      return substitutionTable[char] ?? char; // Substitusi jika ada di tabel
    }).join('');
  }

  // Langkah permutasi sederhana
  String _permute(String input) {
    // Permutasi diacak berdasarkan pola tertentu
    List<int> permutationPattern = [3, 1, 4, 2, 0]; // Contoh pola
    int blockSize = permutationPattern.length;
    List<String> blocks = [];

    // Bagi input ke dalam blok-blok dengan ukuran sama
    for (int i = 0; i < input.length; i += blockSize) {
      String block = input.substring(
          i, i + blockSize > input.length ? input.length : i + blockSize);
      // Terapkan permutasi jika panjang blok sesuai pola
      if (block.length == blockSize) {
        blocks.add(String.fromCharCodes(
            permutationPattern.map((index) => block.codeUnitAt(index))));
      } else {
        blocks.add(block); // Blok terakhir tetap sama jika tidak sesuai ukuran
      }
    }

    return blocks.join('');
  }

  // Konversi teks ke hexadecimal
  String _textToHex(String input) {
    return input.codeUnits
        .map((char) => char.toRadixString(16).padLeft(2, '0'))
        .join('');
  }

  // Konversi hexadecimal ke teks
  String _hexToText(String hex) {
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      String byte = hex.substring(i, i + 2);
      bytes.add(int.parse(byte, radix: 16));
    }
    return String.fromCharCodes(bytes);
  }

  // Fungsi enkripsi
  String encrypt(String input) {
    // Konversi input ke hexadecimal
    String hexInput = _textToHex(input);

    // Substitusi dan permutasi bekerja pada data teks (bukan hexadecimal)
    String substituted = _substitute(hexInput);
    String permuted = _permute(substituted);

    // Konversi hasil akhir ke hexadecimal
    return permuted;
  }

  // Fungsi dekripsi (opsional, jika diperlukan inversi)
  String decrypt(String input) {
    // Permutasi invers (jika pola diketahui)
    // ... Implementasikan jika diperlukan ...
    return input; // Placeholder
  }
}
