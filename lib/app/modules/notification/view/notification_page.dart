// notification_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/modules/notification/models/notification_model.dart';
import 'package:benevolent_crm_app/app/modules/notification/controller/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController _c = Get.find<NotificationController>();

  bool _selectMode = false;
  final Set<int> _selected = <int>{};

  void _enterSelectMode(int id) {
    setState(() {
      _selectMode = true;
      _selected.add(id);
    });
  }

  void _exitSelectMode() {
    setState(() {
      _selectMode = false;
      _selected.clear();
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
        if (_selected.isEmpty) _selectMode = false;
      } else {
        _selected.add(id);
      }
    });
  }

  Future<void> _bulkDelete() async {
    if (_selected.isEmpty) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete selected?'),
        content: Text('This will delete ${_selected.length} notification(s).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final ids = _selected.toList();
    _c.removeLocalByIds(ids); // optimistic
    _exitSelectMode();

    try {
      await _c.commitDelete(ids); // server
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted ${ids.length} notification(s).')),
      );
    } catch (e) {
      await _c.fetchNotifications(); // recover state on failure
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  Future<void> _swipeDelete(DeviceNotification item, int index) async {
    // disable while in select mode
    if (_selectMode) return;

    _c.notifications.removeAt(index); // optimistic
    _c.unreadCount.value = _c.notifications.length;

    bool undone = false;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final sb = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${item.title}"'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            undone = true;
            _c.restoreLocalAt(item, index);
          },
        ),
      ),
    );
    await sb.closed;

    if (!undone) {
      try {
        await _c.commitDelete([item.id]);
      } catch (e) {
        _c.restoreLocalAt(item, index);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          _selectMode ? 'Select notifications' : 'Notifications',
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_selectMode) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${_selected.length} selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Delete selected',
              onPressed: _bulkDelete,
              icon: const Icon(LucideIcons.trash2),
            ),
            IconButton(
              tooltip: 'Cancel',
              onPressed: _exitSelectMode,
              icon: const Icon(LucideIcons.x),
            ),
          ] else ...[
            IconButton(
              tooltip: 'Refresh',
              onPressed: _c.refreshNotifications,
              icon: const Icon(LucideIcons.refreshCw),
            ),
          ],
        ],
      ),
      body: Obx(() {
        if (_c.isLoading.value) return const _LoadingList();
        if (_c.errorMessage.value != null) {
          return _ErrorState(
            message: _c.errorMessage.value!,
            onRetry: _c.fetchNotifications,
          );
        }
        if (_c.notifications.isEmpty)
          return _EmptyState(onRefresh: _c.fetchNotifications);

        return RefreshIndicator(
          onRefresh: _c.refreshNotifications,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: _c.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _c.notifications[index];
              final id = item.id;
              final selected = _selected.contains(id);

              final row = _NotificationCard(
                item: item,
                showCheckbox: _selectMode,
                selected: selected,
                onSelectChanged: (_) => _toggleSelection(id),
                onTap: () {
                  if (_selectMode) {
                    _toggleSelection(id);
                  } else {
                    // open details if needed
                  }
                },
                onLongPress: () => _enterSelectMode(id),
              );

              if (_selectMode) {
                // no swipe while selecting
                return row;
              }

              return Dismissible(
                key: ValueKey('notif-$id'),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(LucideIcons.trash2, color: Colors.red),
                ),
                onDismissed: (_) => _swipeDelete(item, index),
                child: row,
              );
            },
          ),
        );
      }),
      // ❌ No FAB needed — selection is via long press
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final DeviceNotification item;
  final bool showCheckbox;
  final bool selected;
  final ValueChanged<bool> onSelectChanged;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _NotificationCard({
    required this.item,
    required this.showCheckbox,
    required this.selected,
    required this.onSelectChanged,
    required this.onTap,
    required this.onLongPress,
  });

  IconData _pickIcon(DeviceNotification n) {
    final t = '${n.title} ${n.message}'.toLowerCase();
    if (t.contains('lead') && t.contains('assign')) return LucideIcons.userPlus;
    if (t.contains('call')) return LucideIcons.phoneCall;
    if (t.contains('comment')) return LucideIcons.messageCircle;
    if (t.contains('converted')) return LucideIcons.checkCircle;
    if (t.contains('reminder')) return LucideIcons.clock;
    if (t.contains('update') || t.contains('campaign'))
      return LucideIcons.refreshCw;
    if (t.contains('login') || t.contains('device')) return LucideIcons.monitor;
    if (t.contains('report') || t.contains('chart'))
      return LucideIcons.barChart2;
    if (t.contains('maint') || t.contains('system'))
      return LucideIcons.settings;
    if (t.contains('archive')) return LucideIcons.archive;
    if (t.contains('message') || t.contains('mail')) return LucideIcons.mail;
    if (t.contains('missed') || t.contains('alert'))
      return LucideIcons.alertCircle;
    return LucideIcons.bell;
  }

  String _timeAgo(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 45) return 'Just now';
    if (diff.inMinutes < 1) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    final weeks = (diff.inDays / 7).floor();
    if (weeks < 5) return '$weeks week${weeks > 1 ? 's' : ''} ago';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.blue.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: selected ? Colors.blue.shade200 : Colors.grey.shade200,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⬇️ Left-most checkbox, appears only in selection mode
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, anim) => SizeTransition(
                sizeFactor: anim,
                axis: Axis.horizontal,
                child: child,
              ),
              child: showCheckbox
                  ? Padding(
                      key: const ValueKey('cbx'),
                      padding: const EdgeInsets.only(right: 8),
                      child: Checkbox(
                        value: selected,
                        onChanged: (v) => onSelectChanged(v ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                  : const SizedBox(width: 0, key: ValueKey('spacer')),
            ),

            CircleAvatar(
              radius: 22,
              backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
              child: Icon(
                _pickIcon(item),
                color: AppThemes.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: 14.2,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _timeAgo(item.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyState({required this.onRefresh});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.bellOff, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              "You're all caught up!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "No notifications to show.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRefresh, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              size: 56,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}
