import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../config/theme/bloc/theme_cubit.dart';
import '../config/theme/theme.dart';
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
      _showAdaptiveDialog("Masukkan teks terlebih dahulu.");
      return;
    }

    // Validasi algoritma terpilih
    if (_selectedAlgorithm == null || _selectedAlgorithm!.isEmpty) {
      _showAdaptiveDialog("Pilih algoritma terlebih dahulu.");
      return;
    }

    // Validasi khusus Hill Cipher
    if (_selectedAlgorithm!.contains("Hill Cipher")) {
      if (_keyController.text.isEmpty || _keyController.text.trim().isEmpty) {
        _showAdaptiveDialog(
            "Masukkan key (9 angka untuk 3x3 atau 4 angka untuk 2x2) untuk Hill Cipher.");
        return;
      }

      // Validasi panjang key untuk Hill Cipher
      if (_selectedAlgorithm!.contains("3x3") &&
          _keyController.text.length != 9) {
        _showAdaptiveDialog("Key untuk Hill Cipher 3x3 maksimal 9 angka.");
        return;
      }

      if (_selectedAlgorithm!.contains("2x2") &&
          _keyController.text.length != 4) {
        _showAdaptiveDialog("Key untuk Hill Cipher 2x2 maksimal 4 angka.");
        return;
      }
    } else {
      // Validasi input dan key untuk algoritma selain Hill Cipher
      if (_inputController.text.length > 8) {
        _showAdaptiveDialog(
            "Input terlalu panjang! Maksimum 8 karakter (64-bit) untuk algoritma ini.");
        return;
      }

      if (_keyController.text.isEmpty || _keyController.text.trim().isEmpty) {
        _showAdaptiveDialog("Masukkan key untuk algoritma ini.");
        return;
      }

      if (_keyController.text.length > 8) {
        _showAdaptiveDialog(
            "Key terlalu panjang! Maksimum 8 karakter (64-bit) untuk algoritma ini.");
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
          setState(() {
            _outputText =
                "Biner Input: $binaryInput\nHasil Compacting: $compacted";
          });
          break;

        case 'Blocking + Substitusi':
          final bs = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          input = input.padRight(8, '0');
          keyInput = keyInput.padRight(8, '0');
          String binaryInput = bs.toBinary(input);
          String substituted = bs.encrypt(input);
          setState(() {
            _outputText =
                "Biner Input: $binaryInput\nHasil Substitusi: $substituted";
          });
          break;

        case 'Hill Cipher (2x2)':
          final hillCipher = HillCipher2(keyInput);
          result = hillCipher.encrypt(input);
          setState(() {
            _outputText = "Hasil Hill Cipher (2x2): $result";
          });
          break;

        case 'Hill Cipher (3x3)':
          final hillCipher = HillCipher3(keyInput);
          result = hillCipher.encrypt(input);
          setState(() {
            _outputText = "Hasil Hill Cipher (3x3): $result";
          });
          break;

        case 'Substitusi + Compaction':
          final sc = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
          input = input.padRight(8, '0');
          keyInput = keyInput.padRight(8, '0');
          String binaryInput = sc.toBinary(input);
          String compacted = sc.encrypt(input);
          setState(() {
            _outputText =
                "Biner Input: $binaryInput\nHasil Compacting: $compacted";
          });
          break;

        default:
          setState(() {
            _outputText = "Algoritma tidak dikenali.";
          });
      }
    } catch (e) {
      setState(() {
        _outputText = "Error: ${e.toString()}";
      });
    }

    setState(() {
      _isProcessing = false;
    });
  }

  // Fungsi dialog adaptif untuk berbagai platform
  void _showAdaptiveDialog(String message) {
    if (kIsWeb || Theme.of(context).platform == TargetPlatform.linux) {
      // Untuk web dan linux, gunakan showDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Untuk platform lain, gunakan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung lebar maksimum untuk responsivitas
    final maxWidth = MediaQuery.of(context).size.width;
    final isWideScreen = maxWidth > 600;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with gradient
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Modern Cryptography',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: isWideScreen ? 20 : 16,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Animated Background Pattern (similar to profile page)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: BackgroundPatternPainter(
                              color: theme.colorScheme.onPrimary.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.security,
                            size: isWideScreen ? 96 : 64,
                            color: theme.colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Padding(
                      padding: EdgeInsets.all(isWideScreen ? 16.0 : 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Input Section
                          Card(
                            elevation: 4,
                            shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: theme.colorScheme.surface,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.edit,
                                          color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Input Text',
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  TextField(
                                    controller: _inputController,
                                    maxLength: _selectedAlgorithm
                                                ?.contains("Hill Cipher") ??
                                            false
                                        ? null
                                        : 8,
                                    decoration: InputDecoration(
                                      hintText: _selectedAlgorithm
                                                  ?.contains("Hill Cipher") ??
                                              false
                                          ? "Enter text here..."
                                          : "Enter text (max 8 characters)...",
                                      counterText: _selectedAlgorithm
                                                  ?.contains("Hill Cipher") ??
                                              false
                                          ? null
                                          : "Max 8 characters",
                                      border: OutlineInputBorder(),
                                      // Add these properties for better web compatibility
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                    ),
                                    // Add these properties for better web input handling
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _keyController,
                                    maxLength: _selectedAlgorithm
                                                ?.contains("Hill Cipher") ??
                                            false
                                        ? null
                                        : 8,
                                    decoration: InputDecoration(
                                      hintText: _selectedAlgorithm
                                                  ?.contains("Hill Cipher") ??
                                              false
                                          ? "Enter key here..."
                                          : "Enter key (max 8 characters)...",
                                      counterText: _selectedAlgorithm
                                                  ?.contains("Hill Cipher") ??
                                              false
                                          ? null
                                          : "Max 8 characters",
                                      border: OutlineInputBorder(),
                                      // Add these properties for better web compatibility
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                    ),
                                    // Add these properties for better web input handling
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Algorithm Selection Section
                          Card(
                            elevation: 4,
                            shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: theme.colorScheme.surface,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.science,
                                          color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Select Algorithm',
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  DropdownButtonFormField<String>(
                                    value: _selectedAlgorithm,
                                    decoration: const InputDecoration(
                                      hintText: "Choose an algorithm",
                                    ),
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
                                        child: Text(
                                          algorithm,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAlgorithm = value;
                                      });
                                    },
                                    isExpanded:
                                        true, // Membuat dropdown lebih responsif
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Process Button
                          ElevatedButton(
                            onPressed: _process,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "Process",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 24),

                          // Output Section
                          Card(
                            elevation: 4,
                            shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: theme.colorScheme.surface,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.output,
                                          color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Result',
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: theme
                                            .colorScheme.primaryContainer
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      _outputText.isEmpty
                                          ? "Results will appear here..."
                                          : _outputText,
                                      style: theme.textTheme.bodyLarge,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Background Pattern Painter (copied from profile page for consistency)
class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < size.width; i += 20) {
      for (var j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
