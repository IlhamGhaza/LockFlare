import 'package:flutter/material.dart';
import '../data/blocking_subtitotion.dart';
import '../data/hill_chipper2.dart';
import '../data/hill_chipper3.dart';
import '../data/permutation_compaction.dart';
import '../data/substitution_compaction.dart';
import '../data/subtitution_permutation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String? _selectedAlgorithm;
  String _outputText = '';
  bool _isProcessing = false;

  void _process() async {
    // Validasi input
    if (_inputController.text.isEmpty || _inputController.text.trim().isEmpty) {
      setState(() {
        _outputText = "Masukkan teks terlebih dahulu.";
      });
      return;
    }

    // Validasi algoritma terpilih
    if (_selectedAlgorithm == null || _selectedAlgorithm!.isEmpty) {
      setState(() {
        _outputText = "Pilih algoritma terlebih dahulu.";
      });
      return;
    }

    // Validasi khusus Hill Cipher
    if (_selectedAlgorithm!.contains("Hill Cipher")) {
      if (_keyController.text.isEmpty || _keyController.text.trim().isEmpty) {
        setState(() {
          _outputText =
              "Masukkan key (9 angka untuk 3x3 atau 4 angka untuk 2x2) untuk Hill Cipher.";
        });
        return;
      }

      // Validasi panjang key untuk Hill Cipher
      if (_selectedAlgorithm!.contains("3x3") &&
          _keyController.text.length != 9) {
        setState(() {
          _outputText = "Key untuk Hill Cipher 3x3 maksimal 9 angka.";
        });
        return;
      }

      if (_selectedAlgorithm!.contains("2x2") &&
          _keyController.text.length != 4) {
        setState(() {
          _outputText = "Key untuk Hill Cipher 2x2 maksimal 4 angka.";
        });
        return;
      }
    } else {
      // Validasi input dan key untuk algoritma selain Hill Cipher
      if (_inputController.text.length > 8) {
        setState(() {
          _outputText =
              "Input terlalu panjang! Maksimum 8 karakter (64-bit) untuk algoritma ini.";
        });
        return;
      }

      if (_keyController.text.isEmpty || _keyController.text.trim().isEmpty) {
        setState(() {
          _outputText = "Masukkan key untuk algoritma ini.";
        });
        return;
      }

      if (_keyController.text.length > 8) {
        setState(() {
          _outputText =
              "Key terlalu panjang! Maksimum 8 karakter (64-bit) untuk algoritma ini.";
        });
        return;
      }
    }

    setState(() {
      _isProcessing = true;
    });

    // Bersihkan input dan key dari spasi berlebih
    String input = _inputController.text.trim();
    String keyInput = _keyController.text.trim();
    String result = "";
    String _toBinary(String text) {
      return text.codeUnits
          .map((char) => char.toRadixString(2).padLeft(8, '0'))
          .join();
    }

    try {
      switch (_selectedAlgorithm) {
        case 'Substitusi + Permutasi':
          final sp = SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

          // Tambahkan padding untuk input jika kurang dari 8 karakter
          input = input.padRight(8, '0');

          try {
            // Konversi input ke biner (fungsi lokal)
            String binaryInput = _toBinary(input);

            // Jalankan proses enkripsi
            String encrypted = sp.encrypt(input);

            // Jalankan proses dekripsi (opsional untuk invers)
            String decrypted = sp.decrypt(encrypted);

            // Atur hasil ke outputText
            setState(() {
              _outputText = "=== Substitusi + Permutasi ===\n"
                  "Biner Input: $binaryInput\n"
                  "Hasil Hexa: $encrypted\n"
                  "Hasil Invers: $decrypted";
            });
          } catch (e) {
            // Tangani error jika terjadi
            print(
                "Error pada algoritma Substitusi + Permutasi: ${e.toString()}");
            setState(() {
              _outputText =
                  "Error pada algoritma Substitusi + Permutasi: ${e.toString()}";
            });
          }
          break;


        case 'Permutasi + Compaction':
          final pc = PermutationAndCompaction();
          input = input.padRight(8, '0');
          keyInput = keyInput.padRight(8, '0');
          String binaryInput = pc.toBinary(input);
          String compacted = pc.encrypt(input);
          _outputText =
              "Biner Input: $binaryInput\nHasil Compacting: $compacted";
          break;

        case 'Blocking + Substitusi':
          final bs = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          input = input.padRight(8, '0');
          keyInput = keyInput.padRight(8, '0');
          String binaryInput = bs.toBinary(input);
          String substituted = bs.encrypt(input);
          _outputText =
              "Biner Input: $binaryInput\nHasil Substitusi: $substituted";
          break;

        case 'Hill Cipher (2x2)':
          final hillCipher = HillCipher2(keyInput);
          result = hillCipher.encrypt(input);
          _outputText = "Hasil Hill Cipher (2x2): $result";
          break;

        case 'Hill Cipher (3x3)':
          final hillCipher = HillCipher3(keyInput);
          result = hillCipher.encrypt(input);
          _outputText = "Hasil Hill Cipher (3x3): $result";
          break;

        case 'Substitusi + Compaction':
          final sc = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          input = input.padRight(8, '0');
          keyInput = keyInput.padRight(8, '0');
          String binaryInput = sc.toBinary(input);
          String compacted = sc.encrypt(input);
          _outputText =
              "Biner Input: $binaryInput\nHasil Compacting: $compacted";
          break;

        default:
          _outputText = "Algoritma tidak dikenali.";
      }
    } catch (e) {
      result = "Error: ${e.toString()}";
    }

    setState(() {
      _isProcessing = false;
      _outputText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modern Cryptography',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),

              // Input Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Input Text
                      Text(
                        "Masukkan Teks:",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _inputController,
                        maxLength:
                            _selectedAlgorithm?.contains("Hill Cipher") ?? false
                                ? null
                                : 8,
                        decoration: InputDecoration(
                          hintText:
                              _selectedAlgorithm?.contains("Hill Cipher") ??
                                      false
                                  ? "Masukkan teks di sini..."
                                  : "Masukkan teks (maks. 8 karakter)...",
                          counterText:
                              _selectedAlgorithm?.contains("Hill Cipher") ??
                                      false
                                  ? null
                                  : "Maks. 8 karakter",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Input Key
                      TextField(
                        controller: _keyController,
                        maxLength:
                            _selectedAlgorithm?.contains("Hill Cipher") ?? false
                                ? null
                                : 8,
                        decoration: InputDecoration(
                          hintText:
                              _selectedAlgorithm?.contains("Hill Cipher") ??
                                      false
                                  ? "Masukkan key di sini..."
                                  : "Masukkan key (maks. 8 karakter)...",
                          counterText:
                              _selectedAlgorithm?.contains("Hill Cipher") ??
                                      false
                                  ? null
                                  : "Maks. 8 karakter",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Dropdown Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Pilih Algoritma:",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedAlgorithm,
                        hint: Text("Pilih algoritma"),
                        isExpanded: true,
                        items: [
                          'Substitusi + Permutasi',
                          'Permutasi + Compaction',
                          'Blocking + Substitusi',
                          'Hill Cipher (2x2)',
                          'Hill Cipher (3x3)',
                          'Substitusi + Compaction',
                        ].map((algorithm) {
                          return DropdownMenuItem(
                            value: algorithm,
                            child: Text(algorithm),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAlgorithm = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Process Button
              ElevatedButton(
                onPressed: _process,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Proses",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              SizedBox(height: 24),

              // Output Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Hasil:",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _outputText.isEmpty
                            ? "Hasil akan muncul di sini..."
                            : _outputText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
