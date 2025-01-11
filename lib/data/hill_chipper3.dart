import 'dart:math';

class HillCipher3 {
  List<List<int>> keyMatrix = [];

  HillCipher3(String keyInput) {
    // Validasi dan buat matriks kunci
    keyMatrix = _generateKeyMatrix(keyInput);
  }

  // Fungsi untuk membuat matriks kunci dari input pengguna
  List<List<int>> _generateKeyMatrix(String keyInput) {
    if (keyInput.length != 9 || !RegExp(r'^\d+$').hasMatch(keyInput)) {
      throw Exception("Key harus terdiri dari 9 angka.");
    }

    // Konversi string key menjadi list integer
    List<int> keyNumbers = keyInput.split('').map(int.parse).toList();

    // Buat matriks 3x3
    return [
      keyNumbers.sublist(0, 3),
      keyNumbers.sublist(3, 6),
      keyNumbers.sublist(6, 9),
    ];
  }

  final Map<int, String> substitutionTable = {
    ...{for (int i = 0; i < 26; i++) i: String.fromCharCode(65 + i)}, // A-Z
    ...{
      for (int i = 26; i < 36; i++) i: String.fromCharCode(48 + i - 26)
    }, // 0-9
    36: ' ', // Spasi
    37: '.' // Titik
  };



  String encrypt(String input) {
    input = input.toUpperCase();

    // Konversi input ke nilai numerik
    List<int> plaintextNumerical = input.split('').fold<List<int>>([], (acc, char) {
      if (char == ' ') {
        acc.add(36); // Spasi
      } else if ('A'.compareTo(char) <= 0 && char.compareTo('Z') <= 0) {
        acc.add(char.codeUnitAt(0) - 65); // A-Z
      } else if ('0'.compareTo(char) <= 0 && char.compareTo('9') <= 0) {
        acc.add(char.codeUnitAt(0) - 48 + 26); // 0-9
      } else if (char == '.') {
        acc.add(37); // Titik
      }
      return acc;
    });

    print("Convert to Numerical: $plaintextNumerical");

    // Bagi plaintext menjadi blok 3 elemen
    List<List<int>> blocks = [];
    for (int i = 0; i < plaintextNumerical.length; i += 3) {
      List<int> block =
          plaintextNumerical.sublist(i, min(i + 3, plaintextNumerical.length));
      while (block.length < 3) {
        block.add(36); // Tambahkan spasi (36)
      }
      blocks.add(block);
    }

    print("Plaintext Blocks after Padding: $blocks");

    // Proses enkripsi
    List<String> ciphertextBlocks = [];
    for (List<int> block in blocks) {
      List<int> encryptedVector = [];
      for (int row = 0; row < 3; row++) {
        int sum = 0;
        for (int col = 0; col < 3; col++) {
          sum += keyMatrix[row][col] * block[col];
        }
        encryptedVector.add(sum % 37); // Modulo 37
      }

      print("Raw Encrypted Vector (before modulo): $encryptedVector");

      // Konversi nilai numerik ke karakter menggunakan tabel substitusi
      List<String> ciphertextBlock = encryptedVector.map((val) {
        return substitutionTable[val] ?? '';
      }).toList();

      print("Encrypted Block: $ciphertextBlock");

      ciphertextBlocks.add(ciphertextBlock.join());
    }

    String ciphertext = ciphertextBlocks.join();
    print("Ciphertext: $ciphertext");
    return ciphertext;
  }
}