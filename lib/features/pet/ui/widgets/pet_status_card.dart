import 'package:flutter/material.dart';
import '../../model/models.dart';

class PetStatusCard extends StatelessWidget {
  const PetStatusCard({
    super.key,
    required this.name,
    required this.mood,
    required this.skinKey,
    required this.hunger,
    required this.energy,
    required this.clean,
    required this.happy,
    required this.level,
    required this.xp,
    required this.xpNeed,
    required this.coins,
    required this.nextUnlockLabel,
  });

  final String name;
  final PetMood mood;
  final String skinKey;

  final int hunger;
  final int energy;
  final int clean;
  final int happy;

  final int level;
  final int xp;
  final int xpNeed;
  final int coins;

  final String nextUnlockLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final moodText = moodLabel(mood);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Header(
              name: name,
              moodText: moodText,
              skinKey: skinKey,
            ),
            const SizedBox(height: 14),

            // Avatar block (alive)
            _AvatarBlock(mood: mood, skinKey: skinKey),

            const SizedBox(height: 14),

            // Stats
            _StatRow(
              icon: Icons.restaurant_rounded,
              label: "Hunger",
              value: hunger,
              percent: hunger / 100.0,
            ),
            const SizedBox(height: 10),
            _StatRow(
              icon: Icons.bolt_rounded,
              label: "Energy",
              value: energy,
              percent: energy / 100.0,
            ),
            const SizedBox(height: 10),
            _StatRow(
              icon: Icons.cleaning_services_rounded,
              label: "Clean",
              value: clean,
              percent: clean / 100.0,
            ),
            const SizedBox(height: 10),
            _StatRow(
              icon: Icons.sentiment_satisfied_alt_rounded,
              label: "Happy",
              value: happy,
              percent: happy / 100.0,
            ),

            const SizedBox(height: 16),

            // Progress strip
            _ProgressStrip(
              level: level,
              xp: xp,
              xpNeed: xpNeed,
              coins: coins,
            ),

            const SizedBox(height: 10),

            // Next unlock hint
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_open_rounded, size: 18, color: cs.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nextUnlockLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.moodText,
    required this.skinKey,
  });

  final String name;
  final String moodText;
  final String skinKey;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(text: moodText),
                  _Pill(text: "Skin: $skinKey"),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.pets_rounded, color: cs.onSurfaceVariant),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
        color: cs.surface,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock({required this.mood, required this.skinKey});

  final PetMood mood;
  final String skinKey;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final emoji = switch (mood) {
      PetMood.happy => "😄",
      PetMood.idle => "🙂",
      PetMood.hungry => "🥺",
      PetMood.sleepy => "😴",
      PetMood.dirty => "😵‍💫",
      PetMood.sad => "😔",
    };

    // subtle alive effect based on mood
    final scale = switch (mood) {
      PetMood.happy => 1.03,
      PetMood.hungry || PetMood.sad => 0.98,
      _ => 1.0,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: Text(emoji, style: const TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 6),
          Text(
            "Care. Play. Grow.",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.percent,
  });

  final IconData icon;
  final String label;
  final int value;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: cs.onSurfaceVariant),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(cs.primary),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 34,
          child: Text(
            "$value",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ],
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({
    required this.level,
    required this.xp,
    required this.xpNeed,
    required this.coins,
  });

  final int level;
  final int xp;
  final int xpNeed;
  final int coins;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pct = (xp / xpNeed).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Metric(label: "Level", value: "$level"),
              _Divider(),
              _Metric(label: "XP", value: "$xp / $xpNeed"),
              _Divider(),
              _Metric(label: "Coins", value: "$coins"),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: cs.outlineVariant,
    );
  }
}

