import 'package:flutter/material.dart';
import 'package:collector/widgets/item/item_appbar.dart';
import 'package:collector/widgets/item/item_edit.dart';
import 'package:collector/widgets/item/item_view.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:provider/provider.dart';

class ItemTall extends StatefulWidget {
  const ItemTall({super.key});

  @override
  State<ItemTall> createState() => _ItemTallState();
}

class _ItemTallState extends State<ItemTall> {
  int currentPageIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    ItemProvider providerItem = context.watch<ItemProvider>();

    return Scaffold(
      appBar: ItemAppBar(
        itemId: providerItem.id,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: const [
          ItemView(),
          ItemEdit(),
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
