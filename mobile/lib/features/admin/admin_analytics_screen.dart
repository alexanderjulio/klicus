import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/repositories/admin_repository.dart';
import 'admin_approval_screen.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  bool _isLoading = true;
  String _period = '7d'; // '7d' or '30d'
  Map<String, dynamic>? _data;
  final Color _navy = const Color(0xFF0E2244);
  final Color _yellow = const Color(0xFFE2E000);

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final repo = context.read<AdminRepository>();
      final res = await repo.getStats(period: _period);
      if (res.data['success'] == true) {
        setState(() {
          _data = res.data['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar analíticas')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          if (_isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (_data == null)
            const SliverFillRemaining(child: Center(child: Text('No hay datos disponibles')))
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPeriodSelector(),
                    const SizedBox(height: 24),
                    _buildQuickStats(),
                    const SizedBox(height: 32),
                    _buildChartHeader('TRÁFICO DE LA RED', 'Vistas vs Clics'),
                    const SizedBox(height: 16),
                    _buildTrafficChart(),
                    const SizedBox(height: 32),
                    _buildChartHeader('CRECIMIENTO', 'Nuevos usuarios y anuncios'),
                    const SizedBox(height: 16),
                    _buildGrowthChart(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: _navy,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
        title: Text(
          'CENTRO DE COMANDO',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: _yellow,
          ),
        ),
        background: Stack(
          children: [
            Positioned(
              right: -50,
              top: -20,
              child: Icon(Icons.analytics_outlined, size: 200, color: Colors.white.withOpacity(0.03)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPeriodBtn('7d', '7 DÍAS'),
          _buildPeriodBtn('30d', 'MES'),
        ],
      ),
    );
  }

  Widget _buildPeriodBtn(String val, String label) {
    bool selected = _period == val;
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() => _period = val);
          _loadStats();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _navy : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: selected ? _yellow : Colors.grey,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final stats = _data!['stats'];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard('USUARIOS', stats['users'].toString(), Icons.people_outline, Colors.blue),
        _buildStatCard('ANUNCIOS', stats['activeAds'].toString(), Icons.campaign_outlined, _yellow),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminApprovalScreen())),
          child: _buildStatCard('PENDIENTES', stats['pendingAds'].toString(), Icons.hourglass_empty, Colors.orange),
        ),
        _buildStatCard('RECAUDO', '\$${stats['revenue'].toString()}', Icons.payments_outlined, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: _navy)),
        ],
      ),
    );
  }

  Widget _buildChartHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: _navy.withOpacity(0.4), letterSpacing: 2)),
        const SizedBox(height: 4),
        Text(subtitle, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: _navy)),
      ],
    );
  }

  Widget _buildTrafficChart() {
    final List<dynamic> chartData = _data!['chartData'];
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: _buildChartTitles(chartData),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _buildLine(chartData, (d) => d['vistas'].toDouble(), Colors.blue),
            _buildLine(chartData, (d) => d['click'].toDouble(), _yellow),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLine(List<dynamic> data, double Function(dynamic) getter, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), getter(e.value))).toList(),
      isCurved: true,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.2), color.withOpacity(0)],
        ),
      ),
    );
  }

  Widget _buildGrowthChart() {
    final List<dynamic> chartData = _data!['chartData'];
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: _buildChartTitles(chartData),
          barGroups: chartData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(toY: e.value['anuncios'].toDouble(), color: _navy, width: 6),
                BarChartRodData(toY: e.value['usuarios'].toDouble(), color: _yellow, width: 6),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  FlTitlesData _buildChartTitles(List<dynamic> data) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (val, meta) {
            if (val.toInt() >= data.length) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                data[val.toInt()]['date'],
                style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (val, meta) => Text(
            val.toInt().toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 8),
          ),
        ),
      ),
    );
  }
}
