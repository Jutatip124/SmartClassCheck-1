import 'package:flutter/material.dart';
import '../theme.dart';

/// Section card with title and children
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor ?? AppTheme.primaryBlue, size: 22),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// GPS status tile
class GpsTile extends StatelessWidget {
  final double? lat;
  final double? lng;
  final bool isLoading;

  const GpsTile({super.key, this.lat, this.lng, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lat != null ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: lat != null ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: lat != null ? AppTheme.successGreen : AppTheme.accentOrange,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isLoading
                ? const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Getting location...'),
                    ],
                  )
                : lat != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Location captured ✓',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successGreen)),
                          Text(
                            '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}',
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textGray),
                          ),
                        ],
                      )
                    : const Text('Location not captured',
                        style: TextStyle(color: AppTheme.accentOrange)),
          ),
        ],
      ),
    );
  }
}

/// QR result tile
class QrResultTile extends StatelessWidget {
  final String? value;

  const QrResultTile({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value != null ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value != null ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.qr_code_scanner,
            color: value != null ? AppTheme.successGreen : AppTheme.textGray,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: value != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('QR Code scanned ✓',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.successGreen)),
                      Text(value!,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )
                : const Text('QR Code not scanned yet',
                    style: TextStyle(color: AppTheme.textGray)),
          ),
        ],
      ),
    );
  }
}

/// Mood selector widget
class MoodSelector extends StatelessWidget {
  final int? selectedMood;
  final ValueChanged<int> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const moods = [
    {'score': 1, 'emoji': '😡', 'label': 'Very\nNeg'},
    {'score': 2, 'emoji': '🙁', 'label': 'Neg'},
    {'score': 3, 'emoji': '😐', 'label': 'Neutral'},
    {'score': 4, 'emoji': '🙂', 'label': 'Pos'},
    {'score': 5, 'emoji': '😄', 'label': 'Very\nPos'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moods.map((mood) {
        final score = mood['score'] as int;
        final isSelected = selectedMood == score;
        return GestureDetector(
          onTap: () => onMoodSelected(score),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(mood['emoji'] as String,
                    style: TextStyle(fontSize: isSelected ? 28 : 24)),
                const SizedBox(height: 4),
                Text(
                  mood['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white : AppTheme.textGray,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Status badge
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'checked_in':
        color = Colors.blue;
        label = 'In Class';
        icon = Icons.login;
        break;
      case 'completed':
        color = AppTheme.successGreen;
        label = 'Completed';
        icon = Icons.check_circle;
        break;
      default:
        color = AppTheme.textGray;
        label = 'Not Started';
        icon = Icons.radio_button_unchecked;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
