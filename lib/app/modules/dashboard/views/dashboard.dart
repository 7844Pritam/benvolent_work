import 'package:benevolent_crm_app/app/controllers/global_drawer_controller.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/views/cold_call_page.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/modules/leads/view/all_leads_page.dart';
import 'package:benevolent_crm_app/app/modules/notification/controller/notification_controller.dart';
import 'package:benevolent_crm_app/app/modules/notification/view/notification_page.dart';
import 'package:benevolent_crm_app/app/modules/profile/view/profile_page.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = Get.put(DashboardController());

  Future<void> _refresh() async {
    await controller.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        title: const Text('Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Get.find<GlobalDrawerController>().showDrawer();
          },
        ),
        actions: [
          Obx(() {
            final n = Get.find<NotificationController>();
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                  onPressed: () async {
                    await Get.to(() => NotificationPage());
                    n.refreshNotifications();
                  },
                ),
                if (n.unreadCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: _CountBadge(count: n.unreadCount.value),
                  ),
              ],
            );
          }),
          const SizedBox(width: 4),
          IconButton(
            iconSize: 30,
            icon: const Icon(Icons.account_circle),
            color: Colors.white,
            onPressed: () => Get.to(() => UserProfilePage()),
          ),
        ],
      ),
      backgroundColor: AppThemes.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.dashboardModel.value;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              /// ===== OVERVIEW HEADING =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text("Overview", style: TextStyles.Text18700),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        onTap: () => Get.to(AllLeadsPage()),
                        Icons.person,
                        data.leadsCounts,
                        "Total Leads",
                        Colors.blue,
                      ),
                      _statCard(
                        onTap: () => Get.to(ColdCallPage()),

                        Icons.call,
                        data.coldCallCounts,
                        "Cold Calls",
                        Colors.orange,
                      ),
                      _statCard(
                        onTap: () => Get.to(ConvertedCallsPage()),

                        Icons.check_circle,
                        data.coldCallConvertsCounts,
                        "Conversions",
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),

              /// ===== CHARTS =====
              _chartSection(
                "Leads",
                _barChart(data.leadsLabels, data.leadsData),
              ),
              _chartSection(
                "Cold Calls",
                _barChart(data.coldCallLabels, data.coldCallData),
              ),
              _chartSection(
                "Converted Calls",
                _lineChart(
                  data.coldCallConvertLabels,
                  data.coldCallConvertData,
                ),
              ),
              _chartSection(
                "Sales Pipeline",
                _doughnutChart(
                  data.coldCallCounts,
                  data.coldCallConvertsCounts,
                  data.leadsCounts,
                ),
              ),

              /// ===== FOOTER =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      "— Benevolent CRM —",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ===== CUSTOM WIDGETS =====
  Widget _statCard(
    IconData icon,
    int value,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartSection(String title, Widget chart) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.Text18700),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _barChart(List<String> labels, List<int> values) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // show left axis
                reservedSize: 42,

                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(), // e.g. 17 → "17"
                    style: const TextStyle(fontSize: 15),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    try {
                      final date = DateFormat("MMMM yyyy").parse(labels[index]);
                      final shortMonth = DateFormat("MMM").format(date);
                      return Text(
                        shortMonth,
                        style: const TextStyle(fontSize: 10),
                      );
                    } catch (_) {
                      return Text(
                        labels[index].substring(0, 3),
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          barGroups: List.generate(values.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i].toDouble(),
                  width: 16,
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [AppThemes.primaryColor, Colors.blueAccent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _lineChart(List<String> labels, List<int> values) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // show left axis
                reservedSize: 36, // prevent clipping
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(), // e.g. 17 → "17"
                    style: const TextStyle(fontSize: 15),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    try {
                      final date = DateFormat("MMMM yyyy").parse(labels[index]);
                      final shortMonth = DateFormat("MMM").format(date);
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          shortMonth,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    } catch (_) {
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          labels[index].substring(0, 3),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              gradient: LinearGradient(
                colors: [AppThemes.primaryColor, Colors.blueAccent],
              ),
              spots: List.generate(
                values.length,
                (i) => FlSpot(i.toDouble(), values[i].toDouble()),
              ),
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppThemes.primaryColor.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doughnutChart(int coldCalls, int converted, int leads) {
    final total = coldCalls + converted + leads;

    if (total == 0) {
      return const Center(
        child: Text(
          "No Data Available",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    }

    final dataMap = {
      "Leads": leads,
      "Cold Calls": coldCalls,
      "Converted": converted,
    };

    final colors = [
      Colors.blue, // same as stat card for Leads
      Colors.orange,
      Colors.green,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50,
                sectionsSpace: 2,
                sections: List.generate(dataMap.length, (index) {
                  final value = dataMap.values.elementAt(index);
                  return PieChartSectionData(
                    value: value.toDouble(),
                    color: colors[index],
                    title: "${((value / total) * 100).toStringAsFixed(1)}%",
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // ✅ make percent labels white
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: List.generate(dataMap.length, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[index],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${dataMap.keys.elementAt(index)} (${dataMap.values.elementAt(index)})",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final display = count > 99 ? '99+' : '$count';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, anim) =>
          ScaleTransition(scale: anim, child: child),
      child: Container(
        key: ValueKey(display),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        child: Text(
          display,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
