import 'dart:math' as math;

class BlockingAndSubstitution {
  final String alphabet;
  String steps = '';

  BlockingAndSubstitution(this.alphabet);

  /// Method untuk proses enkripsi
  String encrypt(String input) {
    steps +=("\n=== [Blocking + Substitution - Encrypt] ===");
    steps +=("\nInput original: $input");

    // Handle padding untuk input < 8 karakter
    if (input.length < 8) {
      input = input.padRight(8, '0');
      steps +=("\nInput setelah padding: $input");
    }

    // Konversi ke biner
    String binaryInput = _toBinary(input);
    steps +=("\nBiner Input: $binaryInput");

    // Bagi menjadi blok 32-bit
    List<String> blocks = _chunkString(binaryInput, 32);
    steps +=("\nJumlah blok: ${blocks.length}");
    for (int i = 0; i < blocks.length; i++) {
      steps +=("\nBlok ${i + 1}: ${blocks[i]}");
    }

    // Substitusi setiap blok
    List<String> substitutedBlocks = blocks.map((block) {
      String substituted = _blockSubstitution(block);
      steps +=("\nHasil substitusi: $substituted");
      return substituted;
    }).toList();

    // Gabungkan hasil
    String result = substitutedBlocks.join();
    steps +=("\nHasil akhir: $result");

    return result;
  }

  /// Method untuk proses dekripsi
  String decrypt(String input) {
    steps +=("\n=== [Blocking + Substitution - Decrypt] ===");
    steps +=("\nInput: $input");

    // Bagi input menjadi blok 32-bit
    List<String> blocks = _chunkString(input, 32);
    steps +=("\nJumlah blok: ${blocks.length}");

    // Lakukan substitusi balik pada setiap blok
    List<String> decryptedBlocks = blocks.map((block) {
      String decrypted = _blockSubstitution(
          block); // Substitusi yang sama karena merupakan invers dirinya sendiri
      steps +=("\nHasil substitusi balik: $decrypted");
      return decrypted;
    }).toList();

    // Gabungkan hasil
    String binaryResult = decryptedBlocks.join();
    steps +=("\nBiner hasil dekripsi: $binaryResult");

    // Konversi kembali ke teks
    String textResult = _binaryToText(binaryResult);
    steps +=("\nHasil dekripsi: $textResult");

    return textResult;
  }

  /// Konversi teks ke biner
  String toBinary(String input) {
    return _toBinary(input);
  }

  /// Private method: Konversi teks ke biner
  String _toBinary(String text) {
    steps +=("\nMengonversi teks ke biner...");
    return text.codeUnits
        .map((char) => char.toRadixString(2).padLeft(8, '0'))
        .join();
  }

  /// Private method: Konversi biner ke teks
  String _binaryToText(String binary) {
    steps +=("\nMengonversi biner ke teks...");
    List<String> chunks = _chunkString(binary, 8);
    return chunks
        .map((chunk) => String.fromCharCode(int.parse(chunk, radix: 2)))
        .join();
  }

  /// Private method: Substitusi untuk satu blok
  String _blockSubstitution(String block) {
    return block.split('').map((bit) => bit == '0' ? '1' : '0').join();
  }

  /// Private method: Membagi string menjadi blok-blok
  List<String> _chunkString(String str, int size) {
    return List.generate((str.length / size).ceil(),
        (i) => str.substring(i * size, math.min((i + 1) * size, str.length)));
  }
}
