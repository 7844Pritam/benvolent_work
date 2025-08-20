import 'package:flutter/material.dart';

void main() => runApp(const LeadsApp());

class LeadsApp extends StatelessWidget {
  const LeadsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Regular Lead',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const LeadsPage(),
    );
  }
}

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F3FA); // soft pink/purple page bg
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2A47),
        foregroundColor: Colors.white,
        title: const Text('Regular Lead'),
        centerTitle: false,
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: Text('( 7 )', style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const DateHeader('2024-05-28'),
          LeadCard(
            leadId: '111006',
            name: 'test9',
            agentName: 'Test Singh',
            campaign: 'General Campaigns',
            statusChip: const StatusChip.followUp(),
            showAcceptRibbon: false,
          ),
          const DateHeader('2023-07-28'),
          LeadCard(
            leadId: '82661',
            name: 'Michal',
            agentName: 'Test Singh',
            campaign: 'General Campaigns',
            statusChip: const StatusChip.unattended(),
            showAcceptRibbon: true,
          ),
          LeadCard(
            leadId: '82662',
            name: 'John',
            agentName: 'Test Singh',
            campaign: 'General Campaigns',
            statusChip: const StatusChip.none(),
            showAcceptRibbon: false,
          ),
        ],
      ),
    );
  }
}

class DateHeader extends StatelessWidget {
  final String text;
  const DateHeader(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5B5D86),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: 16,
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final String leadId;
  final String name;
  final String agentName;
  final String campaign;
  final StatusChip statusChip;
  final bool showAcceptRibbon;

  const LeadCard({
    super.key,
    required this.leadId,
    required this.name,
    required this.agentName,
    required this.campaign,
    required this.statusChip,
    this.showAcceptRibbon = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Lead ID + call icon
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(
                        context,
                      ).style.copyWith(color: Colors.black87, fontSize: 14),
                      children: [
                        const TextSpan(text: 'Lead ID : '),
                        TextSpan(
                          text: leadId,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2ED573),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.call, size: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),

            // Agent
            Row(
              children: [
                const Icon(
                  Icons.groups_2_outlined,
                  size: 18,
                  color: Colors.pink,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(agentName, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Campaign
            Row(
              children: [
                const Icon(
                  Icons.campaign_outlined,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(campaign, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Divider + status chip on right
            Row(
              children: [
                Expanded(child: Container(height: 1, color: Colors.black12)),
                const SizedBox(width: 10),
                statusChip,
              ],
            ),

            const SizedBox(height: 12),

            // Bottom actions (WhatsApp, Mail, Copy)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionIcon(
                  bg: const Color(0xFF22C55E),
                  icon: Icons.chat_bubble_rounded, // WhatsApp-like
                ),
                _ActionIcon(
                  bg: Colors.white,
                  border: Border.all(color: Colors.black26),
                  icon: Icons.email_outlined,
                  iconColor: Colors.green.shade700,
                ),
                _ActionIcon(
                  bg: Colors.white,
                  border: Border.all(color: Colors.black26),
                  icon: Icons.copy_rounded,
                  iconColor: Colors.green.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (!showAcceptRibbon) return card;

    // Add “Accept” ribbon overlapping bottom (like screenshot)
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          left: 0,
          right: 0,
          bottom: -14,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final Color bg;
  final Border? border;
  final IconData icon;
  final Color? iconColor;
  const _ActionIcon({
    required this.bg,
    required this.icon,
    this.border,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        border: border,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor ?? Colors.white, size: 22),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String? text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  const StatusChip._({
    this.text,
    required this.bg,
    required this.fg,
    this.icon,
    super.key,
  });

  const StatusChip.none()
    : this._(text: null, bg: Colors.transparent, fg: Colors.transparent);

  const StatusChip.followUp()
    : this._(
        text: 'Follow-Up',
        bg: Colors.transparent,
        fg: const Color(0xFF0EA5E9),
        icon: Icons.account_balance_wallet_outlined,
      );

  const StatusChip.unattended()
    : this._(
        text: 'Unattended',
        bg: Colors.transparent,
        fg: const Color(0xFF0EA5E9),
        icon: Icons.credit_card_outlined,
      );

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 18, color: fg),
        if (icon != null) const SizedBox(width: 6),
        Text(
          text!,
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
