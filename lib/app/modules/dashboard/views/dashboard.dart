import 'package:benevolent_crm_app/app/modules/leads/view/all_leads_page.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';

import 'package:benevolent_crm_app/app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/dashboard_controller.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = Get.put(DashboardController());

  Future<void> _refresh() async {
    await controller.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return ModernDrawerWrapper(
      child: Scaffold(
        backgroundColor: AppThemes.white,

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.dashboardModel.value;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        onTap: () => {Get.to(AllLeadsPage())},
                        Icons.person,
                        data.totLeads,
                        " Total \nLeads",
                      ),
                      _statCard(Icons.call, data.totColdCall, "Cold \nCalls"),

                      _statCard(
                        Icons.home,
                        data.totProperties,
                        "Converted Cold Calls",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _tabSelector(),
                  const SizedBox(height: 24),
                  _sectionTitle("Lead Overview"),
                  const SizedBox(height: 16),

                  _fullWidthChart(_barChart()),
                  const SizedBox(height: 24),
                  _sectionTitle("Deal Progress"),
                  const SizedBox(height: 16),

                  _fullWidthChart(_lineChart()),
                  const SizedBox(height: 24),
                  _sectionTitle("Sales Pipeline"),
                  _fullWidthChart(_doughnutChart()),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _fullWidthChart(Widget chart) {
    return SizedBox(width: double.infinity, child: chart);
  }

  Widget _statCard(
    IconData icon,
    int value,
    String label, {
    VoidCallback? onTap, // optional callback
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppThemes.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: AppThemes.lightGreylittle),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppThemes.primaryColor),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.backgroundColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _tabButton("Month"),
        _tabButton("Year", isActive: true),
        _tabButton("Date"),
      ],
    );
  }

  Widget _tabButton(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppThemes.primaryColor : AppThemes.lightGreyMore,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? AppThemes.white : AppThemes.primaryColor,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: TextStyles.Text23600);
  }

  Widget _barChart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 200,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppThemes.lightGreylittle),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(
                8,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      borderRadius: BorderRadius.circular(10),
                      toY: (i + 1) * 2.0,
                      color: i == 4 ? Colors.red : Colors.green,
                      width: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _lineChart() {
    return Padding(
      padding: EdgeInsets.zero, // No extra margin
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppThemes.lightGreylittle),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    12,
                    (i) => FlSpot(i.toDouble(), (i % 5 + 4).toDouble()),
                  ),
                  isCurved: true,
                  color: AppThemes.primaryColor,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppThemes.primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _doughnutChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          sections: [
            PieChartSectionData(
              value: 40,
              color: AppThemes.primaryColor,
              title: '40%',
            ),
            PieChartSectionData(
              value: 30,
              color: AppThemes.darkGrey,
              title: '30%',
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.grey.shade400,
              title: '20%',
            ),
            PieChartSectionData(
              value: 10,
              color: Colors.grey.shade200,
              title: '10%',
            ),
          ],
        ),
      ),
    );
  }
}
