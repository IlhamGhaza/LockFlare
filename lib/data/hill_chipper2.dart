class HillCipher2 {
  final List<List<int>> keyMatrix;

  HillCipher2(this.keyMatrix);

  String encrypt(String input) {
    // Konversi input menjadi nilai numerik
    List<int> numericInput = input.split('').map((char) {
      if (char == ' ') return 36; // Spesial untuk spasi
      return char.codeUnitAt(0) - 65; // Asumsi huruf kapital
    }).toList();

    // Tambahkan padding jika input tidak memenuhi kelipatan 2
    if (numericInput.length % 2 != 0) {
      numericInput.add(36); // Tambahkan spasi (36) sebagai padding
    }

    // Proses setiap blok (2 elemen per blok)
    List<int> encrypted = [];
    for (int i = 0; i < numericInput.length; i += 2) {
      List<int> block = numericInput.sublist(i, i + 2);

      for (int row = 0; row < keyMatrix.length; row++) {
        int sum = 0;
        for (int col = 0; col < block.length; col++) {
          sum += keyMatrix[row][col] * block[col];
        }
        encrypted.add(sum % 37); // Modulo 37
      }
    }

    // Konversi hasil numerik menjadi karakter
    return encrypted.map((num) {
      if (num == 36) return ' ';
      return String.fromCharCode(num + 65);
    }).join('');
  }
}
