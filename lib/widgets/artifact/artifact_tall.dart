import 'package:flutter/material.dart';
import 'package:hoard/widgets/artifact/artifact_appbar.dart';
import 'package:hoard/widgets/artifact/artifact_edit.dart';
import 'package:hoard/widgets/artifact/artifact_view.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:provider/provider.dart';

class ArtifactTall extends StatefulWidget {
  const ArtifactTall({super.key});

  @override
  State<ArtifactTall> createState() => _ArtifactTallState();
}

class _ArtifactTallState extends State<ArtifactTall> {
  int currentPageIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();

    return Scaffold(
      appBar: ArtifactAppBar(
        artifactId: providerArtifact.id,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: const [
          ArtifactView(),
          ArtifactEdit(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
          setState(() {
            currentPageIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Edit',
          ),
        ],
      ),
    );
  }
}
