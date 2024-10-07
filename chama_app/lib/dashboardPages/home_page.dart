import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userRole;
  final double totalSavings;
  final double loansBorrowed;
  final double paymentsMade;
  final List<double> savingsTrends; // List of monthly savings data

  const HomePage({
    Key? key,
    required this.userRole,
    required this.totalSavings,
    required this.loansBorrowed,
    required this.paymentsMade,
    required this.savingsTrends,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedPointLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Savings Card
            _buildCard(
              title: 'Your Savings',
              amount: widget.totalSavings,
              description: 'This is the total amount you have saved.',
            ),

            const SizedBox(height: 16),

            // Savings Trends Chart
            const Text(
              'Savings Trend',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            AspectRatio(
              aspectRatio: 1.70,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false), // Hide grid lines
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide left titles
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _getMonthName(value.toInt()), // Display month names
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide top titles
                    ),
                  ),
                  borderData: FlBorderData(show: false), // Hide borders
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        widget.savingsTrends.length,
                        (index) => FlSpot(index.toDouble(), widget.savingsTrends[index]),
                      ),
                      isCurved: true,
                      gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
                      barWidth: 4,
                      belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.3)),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot spot) {
                          return LineTooltipItem(
                            '${_getMonthName(spot.x.toInt())}: Ksh ${spot.y.toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    touchCallback: (event, response) {
                      if (response != null && response.lineBarSpots != null) {
                        setState(() {
                          if (response.lineBarSpots!.isNotEmpty) {
                            _selectedPointLabel =
                                '${_getMonthName(response.lineBarSpots![0].x.toInt())}: Ksh ${response.lineBarSpots![0].y.toStringAsFixed(2)}';
                          } else {
                            _selectedPointLabel = null; // Clear the label if nothing is tapped
                          }
                        });
                      }
                    },
                    handleBuiltInTouches: true, // Enable built-in touch handling
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Display selected point label if any
            if (_selectedPointLabel != null)
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.green.withOpacity(0.1),
                child: Text(
                  _selectedPointLabel!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 20),

            // Row for Loans Borrowed and Payments Made Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Loans Borrowed Card with Pay Now Button
                Expanded(
                  child: _buildCardWithButton(
                    title: 'Loans Borrowed',
                    amount: widget.loansBorrowed,
                    description: 'This is the total amount of loans borrowed.',
                    buttonText: 'Pay Now',
                    onPressed: () {
                      // Handle pay now action
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Payments Made Card
                Expanded(
                  child: _buildCard(
                    title: 'Payments Made',
                    amount: widget.paymentsMade,
                    description: 'This is the total amount of payments made.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required double amount, required String description}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ksh ${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWithButton({
    required String title,
    required double amount,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ksh ${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int monthIndex) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[monthIndex % 12];
  }
}
