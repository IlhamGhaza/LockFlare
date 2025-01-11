import 'dart:math';

class HillCipher3 {
  final List<List<int>> keyMatrix;

  HillCipher3(this.keyMatrix);

  // Tabel substitusi (menggunakan aturan yang sama dengan Python)
  final Map<int, String> substitutionTable = {
    for (int i = 0; i < 26; i++) i: String.fromCharCode(65 + i), // A-Z
    for (int i = 26; i < 36; i++) i: String.fromCharCode(48 + i - 26), // 0-9
    36: ' ', // Spasi
    37: '.', // Karakter khusus (contoh: titik)
  };

  // Fungsi untuk mengenkripsi teks
  String encrypt(String input) {
    // Ubah input menjadi huruf besar
    input = input.toUpperCase();

    // Konversi setiap karakter menjadi nilai numerik
    List<int> plaintextNumerical =
        input.split('').fold<List<int>>([], (acc, char) {
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



    // Debug: Tampilkan nilai numerik
    print("Convert to Numerical: $plaintextNumerical");

    // Bagi input menjadi blok-blok dengan panjang 3 elemen
    List<List<int>> blocks = [];
    for (int i = 0; i < plaintextNumerical.length; i += 3) {
      List<int> block =
          plaintextNumerical.sublist(i, min(i + 3, plaintextNumerical.length));
      // Jika blok terakhir kurang dari 3 elemen, tambahkan padding
      while (block.length < 3) {
        block.add(36); // Tambahkan spasi (36)
      }
      blocks.add(block);
    }

    // Debug: Tampilkan blok plaintext setelah padding
    print("Plaintext Blocks after Padding: $blocks");

    // Proses enkripsi
    List<String> ciphertextBlocks = [];
    for (List<int> block in blocks) {
      // Konversi blok menjadi vektor
      List<int> encryptedVector = [];
      for (int row = 0; row < 3; row++) {
        int sum = 0;
        for (int col = 0; col < 3; col++) {
          sum += keyMatrix[row][col] * block[col];
        }
        encryptedVector.add(sum % 37); // Operasi modulo 37
      }

      // Debug: Tampilkan hasil sebelum dan setelah modulo
      print("Raw Encrypted Vector (before modulo): $encryptedVector");

      // Konversi hasil numerik ke karakter menggunakan tabel substitusi
      List<String> ciphertextBlock = encryptedVector.map((val) {
        return substitutionTable[val] ?? '';
      }).toList();

      // Debug: Tampilkan blok terenkripsi
      print("Encrypted Block: $ciphertextBlock");

      // Gabungkan blok ke ciphertext
      ciphertextBlocks.add(ciphertextBlock.join());
    }

    // Gabungkan semua blok menjadi ciphertext akhir
    String ciphertext = ciphertextBlocks.join();
    print("Ciphertext: $ciphertext");
    return ciphertext;
  }
}
