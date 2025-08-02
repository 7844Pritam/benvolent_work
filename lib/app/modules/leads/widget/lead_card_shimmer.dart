import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeadCardShimmer extends StatelessWidget {
  const LeadCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        width: double.infinity,
      ),
    );
  }
}
