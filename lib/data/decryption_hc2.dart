import 'dart:math';

class DecryptionHillCipher2 {
  List<List<int>> keyMatrix = [];
  List<List<int>> inverseKeyMatrix = [];
  String steps = '';

  DecryptionHillCipher2(String keyInput) {
    // Validasi dan buat matriks kunci
    keyMatrix = _generateKeyMatrix(keyInput);
    // Hitung matriks invers modulo 37
    inverseKeyMatrix = _calculateInverseMatrix(keyMatrix);
  }

  // Fungsi untuk membuat matriks kunci dari input pengguna
  List<List<int>> _generateKeyMatrix(String keyInput) {
    if (keyInput.length != 4 || !RegExp(r'^\d+$').hasMatch(keyInput)) {
      throw Exception("Key harus terdiri dari 4 angka.");
    }

    // Konversi string key menjadi list integer
    List<int> keyNumbers = keyInput.split('').map(int.parse).toList();

    // Buat matriks 2x2
    return [
      keyNumbers.sublist(0, 2),
      keyNumbers.sublist(2, 4),
    ];
  }

  // Fungsi untuk menghitung matriks invers modulo 37
  List<List<int>> _calculateInverseMatrix(List<List<int>> matrix) {
    int det = (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % 37;
    if (det < 0) det += 37;

    // Cari invers determinan modulo 37
    int detInverse = _modInverse(det, 37);

    // Tukar elemen untuk matriks adjugate
    List<List<int>> adjugateMatrix = [
      [matrix[1][1], -matrix[0][1]],
      [-matrix[1][0], matrix[0][0]]
    ];

    // Modulo 37 untuk setiap elemen
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        adjugateMatrix[i][j] =
            (adjugateMatrix[i][j] * detInverse) % 37; // Skalakan dengan invers
        if (adjugateMatrix[i][j] < 0) {
          adjugateMatrix[i][j] += 37; // Pastikan elemen positif
        }
      }
    }

    steps += "\nInverse Key Matrix: $adjugateMatrix";
    return adjugateMatrix;
  }

  // Fungsi untuk mencari invers modulo (menggunakan algoritma Extended Euclidean)
  int _modInverse(int a, int m) {
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    throw Exception("Invers tidak ditemukan untuk determinan $a.");
  }

  // Tabel substitusi (sama dengan Hill Cipher 2x2)
  final Map<int, String> substitutionTable = {
    ...{for (int i = 0; i < 26; i++) i: String.fromCharCode(65 + i)}, // A-Z
    ...{
      for (int i = 26; i < 36; i++) i: String.fromCharCode(48 + i - 26)
    }, // 0-9
    36: ' ', // Spasi
    37: '.' // Titik
  };

  // Fungsi dekripsi
  String decrypt(String input) {
    // Konversi input ke nilai numerik
    List<int> ciphertextNumerical = input.split('').map((char) {
      return substitutionTable.entries
          .firstWhere((entry) => entry.value == char,
              orElse: () => const MapEntry(0, ''))
          .key;
    }).toList();

    steps += "\nConvert Ciphertext to Numerical: $ciphertextNumerical";

    // Bagi ciphertext menjadi blok 2 elemen
    List<List<int>> blocks = [];
    for (int i = 0; i < ciphertextNumerical.length; i += 2) {
      blocks.add(ciphertextNumerical.sublist(
          i, min(i + 2, ciphertextNumerical.length)));
    }

    steps += "\nCiphertext Blocks: $blocks";

    // Proses dekripsi
    List<String> plaintextBlocks = [];
    for (List<int> block in blocks) {
      List<int> decryptedVector = [];
      for (int row = 0; row < 2; row++) {
        int sum = 0;
        for (int col = 0; col < 2; col++) {
          sum += inverseKeyMatrix[row][col] * block[col];
        }
        decryptedVector.add(sum % 37); // Modulo 37
      }

      steps += "\nDecrypted Vector (before modulo): $decryptedVector";

      // Konversi nilai numerik ke karakter menggunakan tabel substitusi
      List<String> plaintextBlock = decryptedVector.map((val) {
        return substitutionTable[val] ?? '';
      }).toList();

      steps += "\nDecrypted Block: $plaintextBlock";

      plaintextBlocks.add(plaintextBlock.join());
    }

    String plaintext = plaintextBlocks.join().trim();
    steps += "\nPlaintext: $plaintext";
    return plaintext;
  }
}
