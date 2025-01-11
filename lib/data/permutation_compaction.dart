class PermutationAndCompaction {
  // Penanda posisi spasi saat enkripsi
  List<int> spacePositions = [];

  String encrypt(String input) {
    // Simpan posisi spasi
    spacePositions = [];
    for (int i = 0; i < input.length; i++) {
      if (input[i] == ' ') {
        spacePositions.add(i);
      }
    }

    // Permutation: Balik urutan teks
    String permuted = input.split('').reversed.join('');

    // Compaction: Hilangkan spasi
    return permuted.replaceAll(' ', '');
  }

  String decrypt(String input) {
    // Tambahkan kembali spasi pada posisi yang tepat
    String expanded = input;

    for (int i = spacePositions.length - 1; i >= 0; i--) {
      int position = spacePositions[i];
      expanded =
          expanded.substring(0, position) + ' ' + expanded.substring(position);
    }

    // Reverse permutation
    return expanded.split('').reversed.join('');
  }
}
