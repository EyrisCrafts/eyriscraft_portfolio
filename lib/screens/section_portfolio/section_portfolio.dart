import 'package:eyris_portfolio/models/model_project_card.dart';
import 'package:eyris_portfolio/overlays/overlay_project.dart';
import 'package:eyris_portfolio/screens/section_portfolio/widgets/project_card.dart';
import 'package:eyris_portfolio/utils/my_assets.dart';
import 'package:eyris_portfolio/widgets/custom_image_viewer/custom_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../gen/assets.gen.dart';

class SectionPortfolio extends StatefulWidget {
  const SectionPortfolio({super.key});

  @override
  State<SectionPortfolio> createState() => _SectionPortfolioState();
}

class _SectionPortfolioState extends State<SectionPortfolio> {
  List<ModelProjectCard> allProjects = [
    ModelProjectCard(
        fullDescription: "Lot of features",
        listOfImages: [
          Assets.projectsImages.dawn1.path,
          Assets.projectsImages.dawn2.path,
          Assets.projectsImages.dawn3.path,
          Assets.projectsImages.dawn4.path,
        ],
        projectIcon: Assets.projectsImages.dawnLogo.path,
        smallDescription: 'A feature rich news app',
        title: 'Dawn News'),
    ModelProjectCard(
        fullDescription: "Lot of features",
        listOfImages: [
          Assets.projectsImages.swift1.path,
          Assets.projectsImages.swift2.path,
          Assets.projectsImages.swift3.path,
          Assets.projectsImages.swift4.path,
        ],
        projectIcon: Assets.projectsImages.swift.path,
        smallDescription: 'A minimalist Android Launcher',
        title: 'Swift Launcher'),
    ModelProjectCard(
        fullDescription: "Lot of features",
        listOfImages: [
          Assets.projectsImages.chessformer1.path,
          Assets.projectsImages.chessformer2.path,
          Assets.projectsImages.chessformer3.path,
          Assets.projectsImages.chessformer4.path,
        ],
        projectIcon: Assets.projectsImages.chessformer.path,
        smallDescription: 'A variant of chess with puzzles',
        title: 'Chessformer'),
    ModelProjectCard(
        fullDescription: "Lot of features",
        listOfImages: [
          Assets.projectsImages.cracking1.path,
          Assets.projectsImages.cracking2.path,
          Assets.projectsImages.cracking3.path,
          Assets.projectsImages.cracking4.path,
        ],
        projectIcon: Assets.projectsImages.cracking.path,
        smallDescription: 'Automatic Dictionary attack on WiFi networks',
        title: 'Cracking Utility'),
    ModelProjectCard(
        fullDescription: "Lot of features",
        listOfImages: [
          Assets.projectsImages.memax1.path,
          Assets.projectsImages.memax2.path,
          Assets.projectsImages.memax3.path,
          Assets.projectsImages.memax4.path,
        ],
        projectIcon: Assets.projectsImages.memax.path,
        smallDescription: 'A feature rich Memes App',
        title: 'Memax - Daily dose of laughter'),
    ModelProjectCard(
        fullDescription: "Lot of features",
        listOfImages: [
          Assets.projectsImages.paknews1.path,
          Assets.projectsImages.paknews2.path,
          Assets.projectsImages.paknews3.path,
          Assets.projectsImages.paknews4.path,
        ],
        projectIcon: Assets.projectsImages.paknews.path,
        smallDescription: 'Pakistan News in Urdi, feature rich',
        title: 'PakNews - Urdu'),
    ModelProjectCard(
        fullDescription: "",
        listOfImages: [
          Assets.projectsImages.javedChaudry1.path,
          Assets.projectsImages.javedChaudry2.path,
          Assets.projectsImages.javedChaudry3.path,
          Assets.projectsImages.javedChaudry4.path,
        ],
        projectIcon: Assets.projectsImages.javedChaudry.path,
        smallDescription: 'Read all columns of Javed Chaudhry',
        title: 'Javed Chaudhry'),
    ModelProjectCard(
        fullDescription: "",
        listOfImages: [
          Assets.projectsImages.tasbeehCounter1.path,
          Assets.projectsImages.tasbeehCounter2.path,
          Assets.projectsImages.tasbeehCounter3.path,
          Assets.projectsImages.tasbeehCounter4.path,
        ],
        projectIcon: Assets.projectsImages.tasbeehCounter.path,
        smallDescription: 'A user friendly Tasbeeh Counter',
        title: 'Tasbeeh Counter'),
  ];

  OverlayEntry? overlayEntry;
  late final List<GlobalKey> projectKeys;

  @override
  void initState() {
    super.initState();
    projectKeys = List.generate(allProjects.length, (index) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 0,
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) => ProjectCard(
        key: projectKeys[index],
        modelProjectCard: allProjects[index],
        onSelected: (ModelProjectCard modelProjectCard, double topOffset, double leftOffset, Size size) {
          //asd
          overlayEntry = OverlayEntry(
              builder: (context) => OverlayProject(
                  modelProjectCard: modelProjectCard,
                  topOffset: topOffset,
                  leftOffset: leftOffset,
                  size: size,
                  onDismiss: () {
                    overlayEntry?.remove();
                    final state = projectKeys[index].currentState as ProjectCardState;
                    state.enableIcon();
                  }));
          Overlay.of(context)?.insert(overlayEntry!);
        },
      ),
      itemCount: allProjects.length,
    );
  }
}
