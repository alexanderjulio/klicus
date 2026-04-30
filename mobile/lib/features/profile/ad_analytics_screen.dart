import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/services/analytics_service.dart';
import '../../models/ad_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AdAnalyticsScreen extends StatefulWidget {
  final AdModel ad;
  const AdAnalyticsScreen({super.key, required this.ad});

  @override
  State<AdAnalyticsScreen> createState() => _AdAnalyticsScreenState();
}

class _AdAnalyticsScreenState extends State<AdAnalyticsScreen> {
  String _selectedRange = '30';
  bool _isLoading = true;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoading = true);
    try {
      final service = context.read<AnalyticsService>();
      final response = await service.getAdStats(widget.ad.id, range: _selectedRange);
      if (response.data['success'] == true) {
        setState(() {
          _data = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Stats Fetch Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);
    const bg = Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          widget.ad.title.toUpperCase(),
          style: GoogleFonts.outfit(color: navy, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
        ),
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: navy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ANÁLISIS DE RENDIMIENTO', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.4))),
            const SizedBox(height: 24),
            
            _buildRangeSelector(),
            const SizedBox(height: 32),
            
            if (_isLoading)
               const Center(child: CircularProgressIndicator(color: Color(0xFFE2E000)))
            else if (_data != null) ...[
              _buildSummaryCards(),
              const SizedBox(height: 48),
              const Text('TENDENCIA DIARIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey)),
              const SizedBox(height: 24),
              _buildChart(),
            ] else 
              const Center(child: Text('No hay datos disponibles')),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSelector() {
    return Row(
      children: [
        _rangeChip('7 Días', '7'),
        const SizedBox(width: 8),
        _rangeChip('30 Días', '30'),
        const SizedBox(width: 8),
        _rangeChip('Total', 'total'),
      ],
    );
  }

  Widget _rangeChip(String label, String value) {
    final isSelected = _selectedRange == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedRange = value);
        _fetchStats();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE2E000) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E2244) : Colors.grey[600],
            fontWeight: FontWeight.w900,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final stats = _data!['stats'] ?? {};
    return Row(
      children: [
        _statCard('VISTAS', (stats['views'] ?? 0).toString(), Icons.visibility),
        const SizedBox(width: 12),
        _statCard('CONTACTOS', (stats['contacts'] ?? 0).toString(), Icons.message),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    const navy = Color(0xFF0E2244);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFE2E000).withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFFE2E000), size: 18),
            ),
            const SizedBox(height: 16),
            Text(value, style: GoogleFonts.outfit(color: navy, fontSize: 24, fontWeight: FontWeight.w900)),
            Text(label, style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final List daily = _data!['timeSeries'] ?? [];
    if (daily.isEmpty) return const Center(child: Text('Sin actividad reciente'));

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: daily.asMap().entries.map((e) {
                final viewCount = double.tryParse(e.value['views'].toString()) ?? 0.0;
                return FlSpot(e.key.toDouble(), viewCount);
              }).toList(),
              isCurved: true,
              color: const Color(0xFFE2E000),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFFE2E000).withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
