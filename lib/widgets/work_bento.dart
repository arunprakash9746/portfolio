import 'package:flutter/material.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class WorkBento extends StatelessWidget {
  const WorkBento({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    const w = Profile.work;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(label: 'At Amdocs', title: 'What I build at Amdocs'),
        BentoRow(
          flex: const [7, 5],
          children: [const _PipelineTile(), _WorkTile(w[0])],
        ),
        const SizedBox(height: bentoGap),
        if (bp == Breakpoint.wide)
          BentoRow(flex: const [1, 1, 1], children: [for (final i in w.skip(1)) _WorkTile(i)])
        else ...[
          BentoRow(flex: const [1, 1], children: [_WorkTile(w[1]), _WorkTile(w[2])]),
          const SizedBox(height: bentoGap),
          _WorkTile(w[3]),
        ],
        const SizedBox(height: bentoGap),
        const _ExperienceTile(),
      ],
    );
  }
}

class _WorkTile extends StatelessWidget {
  const _WorkTile(this.item);

  final WorkItem item;

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.index, style: AppType.mono(size: 12, color: AppColors.accent)),
              const SizedBox(height: 18),
              Text(item.title, style: AppType.display(size: 24, height: 1.12)),
              const SizedBox(height: 12),
              Text(item.summary, style: AppType.sans(size: 14.5)),
              const SizedBox(height: 16),
              Text(
                item.outcome,
                style: AppType.sans(size: 14, color: AppColors.ink, weight: FontWeight.w500, height: 1.4),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final t in item.tags) Chip2(t, color: AppColors.muted)],
          ),
        ],
      ),
    );
  }
}

class _PipelineTile extends StatefulWidget {
  const _PipelineTile();

  @override
  State<_PipelineTile> createState() => _PipelineTileState();
}

class _PipelineTileState extends State<_PipelineTile> with SingleTickerProviderStateMixin {
  late final AnimationController _flow;

  static const _stageColors = [
    AppColors.muted,
    Color(0xFFD08A5B),
    Color(0xFFC9CED6),
    AppColors.accent,
  ];

  @override
  void initState() {
    super.initState();
    _flow = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    if (WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
      _flow.value = 1;
    } else {
      _flow.repeat();
    }
  }

  @override
  void dispose() {
    _flow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final narrow = breakpointOf(MediaQuery.sizeOf(context).width) == Breakpoint.narrow;
    const stages = Profile.stages;

    return BentoTile(
      padding: const EdgeInsets.all(26),
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0x14FFB547), Color(0x00131316)],
        stops: [0, 0.6],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: TileLabel('Medallion lakehouse')),
                  const LiveDot(),
                  const SizedBox(width: 8),
                  Text('streaming', style: AppType.mono(size: 11, color: AppColors.signal)),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Raw events in, trusted tables out.',
                style: AppType.display(size: narrow ? 26 : 32, height: 1.08),
              ),
              const SizedBox(height: 28),
            ],
          ),
          AnimatedBuilder(
            animation: _flow,
            builder: (context, _) {
              final active = (_flow.value * stages.length).floor().clamp(0, stages.length - 1);
              final nodes = [
                for (var i = 0; i < stages.length; i++)
                  _StageNode(stage: stages[i], color: _stageColors[i], active: i == active),
              ];
              if (narrow) {
                return Column(
                  children: [
                    for (var i = 0; i < nodes.length; i++) ...[
                      if (i > 0) const SizedBox(height: 8),
                      nodes[i],
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < nodes.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: i == active ? AppColors.accent : AppColors.faint,
                        ),
                      ),
                    Expanded(child: nodes[i]),
                  ],
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              'Quality checks in Delta Live Tables gate every hop, and Unity Catalog governs who reads what.',
              style: AppType.sans(size: 14, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({required this.stage, required this.color, required this.active});

  final Stage stage;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: active ? AppColors.tileHi : AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? color : AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  stage.title,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.display(size: 16, height: 1.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(stage.detail, style: AppType.sans(size: 12.5, color: AppColors.muted, height: 1.4)),
        ],
      ),
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  const _ExperienceTile();

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SEP 2023  —  PRESENT', style: AppType.mono(size: 11, color: AppColors.accent)),
        const SizedBox(height: 14),
        Text(Profile.role, style: AppType.display(size: 28)),
        const SizedBox(height: 6),
        Text(
          '${Profile.company}  ·  ${Profile.city}',
          style: AppType.sans(size: 15, color: AppColors.body),
        ),
      ],
    );
    final bullets = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final f in Profile.focus)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(width: 5, height: 5, color: AppColors.accent),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(f, style: AppType.sans(size: 15))),
              ],
            ),
          ),
      ],
    );

    return BentoTile(
      padding: EdgeInsets.all(bp == Breakpoint.narrow ? 24 : 32),
      child: bp == Breakpoint.narrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [header, const SizedBox(height: 24), bullets],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: header),
                const SizedBox(width: 32),
                Expanded(flex: 8, child: bullets),
              ],
            ),
    );
  }
}
