import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlobalReportsPage extends StatelessWidget {
  const GlobalReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Reports'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Global Chama Statistics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Overview Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  title: 'Total Chamas',
                  value: '24', // Replace with real data
                  icon: Icons.group,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  title: 'Total Savings',
                  value: 'Ksh 1.2M', // Replace with real data
                  icon: Icons.savings,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  title: 'Total Loans Borrowed',
                  value: 'Ksh 500K', // Replace with real data
                  icon: Icons.monetization_on,
                  color: Colors.orange,
                ),
                _buildStatCard(
                  title: 'Total Payments Made',
                  value: 'Ksh 300K', // Replace with real data
                  icon: Icons.payment,
                  color: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Savings Trend Chart
            const Text(
              'Savings Distribution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display a Bar Chart or Pie Chart for savings
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.70,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, _) {
                            return Text(
                              'Chama ${value.toInt()}',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: 100000, // Updated from 'y' to 'toY'
                            color: Colors.green,
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: 150000, // Updated from 'y' to 'toY'
                            color: Colors.green,
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: 200000, // Updated from 'y' to 'toY'
                            color: Colors.green,
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: 250000, // Updated from 'y' to 'toY'
                            color: Colors.green,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
