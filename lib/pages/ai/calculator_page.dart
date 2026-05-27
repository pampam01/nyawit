import 'package:flutter/material.dart';
import '../../services/price_service.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  bool _isLoading = true;
  PalmPriceData? _priceData;
  String? _selectedAge;
  final TextEditingController _weightController = TextEditingController();
  double _calculatedTotal = 0;
  String _selectedProvince = 'jambi'; // Default

  // List of supported provinces
  final List<String> _provinces = [
    'jambi',
    'riau',
    'aceh',
    'kalimantan barat',
    'kalimantan timur',
    'sumatera utara',
    'sumatera selatan',
  ];

  @override
  void initState() {
    super.initState();
    _fetchPriceData();
  }

  Future<void> _fetchPriceData() async {
    setState(() => _isLoading = true);
    final data = await PriceService.getTodayPrices(province: _selectedProvince);
    setState(() {
      _priceData = data;
      _isLoading = false;
      if (data != null && data.byAge.isNotEmpty) {
        // Find a default age, prefer 10-20 years if it exists
        String? defaultAge;
        for (var key in data.byAge.keys) {
          if (key.contains('10-20')) {
            defaultAge = key;
            break;
          }
        }
        _selectedAge = defaultAge ?? data.byAge.keys.first;
      }
      _calculate();
    });
  }

  void _calculate() {
    if (_priceData == null || _selectedAge == null) return;
    final weightStr = _weightController.text.trim();
    final weight = double.tryParse(weightStr) ?? 0.0;
    final pricePerKg = _priceData!.byAge[_selectedAge] ?? 0;
    
    setState(() {
      _calculatedTotal = weight * pricePerKg;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Sawit'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _priceData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Gagal mengambil data harga terkini.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchPriceData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Source Info Card
                      Card(
                        elevation: 0,
                        color: colorScheme.primaryContainer.withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Harga berdasarkan data SPKS/Disbun',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Provinsi: ${_priceData!.provinceName}\nTanggal: ${_priceData!.date}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Province Dropdown
                      Text('Pilih Provinsi', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedProvince,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: _provinces.map((prov) {
                          return DropdownMenuItem(
                            value: prov,
                            child: Text(prov.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null && val != _selectedProvince) {
                            _selectedProvince = val;
                            _fetchPriceData();
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Age Dropdown
                      Text('Usia Tanam', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedAge,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: _priceData!.byAge.keys.map((age) {
                          final price = _priceData!.byAge[age];
                          return DropdownMenuItem(
                            value: age,
                            child: Text('$age (Rp $price/kg)'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedAge = val;
                            _calculate();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Weight Input
                      Text('Berat Panen (Kg)', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          hintText: 'Masukkan total berat (misal: 1500)',
                          prefixIcon: const Icon(Icons.scale),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                      const SizedBox(height: 32),
                      
                      // Result Card
                      Card(
                        elevation: 4,
                        shadowColor: colorScheme.primary.withOpacity(0.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [colorScheme.primary, colorScheme.primaryContainer],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'Estimasi Pendapatan',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${_calculatedTotal.toStringAsFixed(0).replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (match) => ".")}',
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: colorScheme.onPrimary.withOpacity(0.3)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Harga/kg:',
                                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary.withOpacity(0.8)),
                                  ),
                                  Text(
                                    'Rp ${_priceData!.byAge[_selectedAge]}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Berat:',
                                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary.withOpacity(0.8)),
                                  ),
                                  Text(
                                    '${_weightController.text.isEmpty ? "0" : _weightController.text} Kg',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
