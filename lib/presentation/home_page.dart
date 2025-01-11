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
    if (_inputController.text.isEmpty) {
      setState(() {
        _outputText = "Masukkan teks terlebih dahulu.";
      });
      return;
    }

    if (_selectedAlgorithm == null) {
      setState(() {
        _outputText = "Pilih algoritma terlebih dahulu.";
      });
      return;
    }
    setState(() {
      _isProcessing = true;
    });

    if (_keyController.text.isEmpty &&
        _selectedAlgorithm!.contains("Hill Cipher")) {
      setState(() {
        _outputText = "Masukkan key (9 angka) untuk Hill Cipher.";
      });
      return;
    }

    // Simulasi waktu pemrosesan
    await Future.delayed(Duration(seconds: 2));

    String input = _inputController.text;
    String keyInput = _keyController.text;
    String result = "";

    try {
      switch (_selectedAlgorithm) {
        case 'Substitusi + Permutasi':
          final algorithm =
              SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          String hexResult = algorithm
              .encrypt(input); // Enkripsi menghasilkan hasil hexadecimal
          String inversText = algorithm.decrypt(hexResult); // Opsional: Inversi
          _outputText = "Hasil Hexa: $hexResult\nHasil Invers: $inversText";
          break;

        case 'Permutasi + Compaction':
          final algorithm = PermutationAndCompaction();
          _outputText = algorithm.encrypt(input);
          break;

        case 'Blocking + Substitusi':
          final algorithm =
              BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          _outputText = algorithm.encrypt(input);
          break;

        case 'Hill Cipher (2x2)':
          final hillCipher = HillCipher2(keyInput);
          result = hillCipher.encrypt(input);
          _outputText = hillCipher.encrypt(input);
          break;
        case 'Hill Cipher (3x3)':
          final hillCipher = HillCipher3(keyInput);
          result = hillCipher.encrypt(input);
          _outputText = hillCipher.encrypt(input);
          break;

        case 'Substitusi + Compaction':
          final algorithm =
              SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          _outputText = algorithm.encrypt(input);
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
        backgroundColor:
            Theme.of(context).colorScheme.primary, // Sesuai dengan tema
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
                color: Theme.of(context).cardColor, // Sesuai dengan warna tema
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
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color, // Sesuai dengan tema
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _inputController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Masukkan teks di sini...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Input Key
                      Text(
                        "Masukkan Kunci (Opsional):",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _keyController,
                        decoration: InputDecoration(
                          hintText: "Masukkan kunci jika diperlukan...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
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
                  iconColor:
                      Theme.of(context).primaryColor, // Sesuai dengan tema
                  elevation: 5,
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
