import 'package:flutter/material.dart';
import 'package:hoard/config.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:provider/provider.dart';

class PileBottomBar extends StatefulWidget {
  final PileProvider providerPile;

  const PileBottomBar({super.key, required this.providerPile});

  @override
  State<PileBottomBar> createState() => _PileBottomBarState();
}

class _PileBottomBarState extends State<PileBottomBar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocus;
  TextSelection _searchSelection = const TextSelection.collapsed(offset: 0);

  @override
  void initState() {
    _searchFocus = FocusNode();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    _searchController.value = TextEditingValue(
      selection: _searchSelection,
      text: providerPile.search,
    );

    if (config.get('mode') == 'wide') _searchFocus.requestFocus();

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 70, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.providerPile.filter.id),
          PopupMenuButton<String>(
            initialValue: widget.providerPile.filter.id,
            icon: const Icon(Icons.arrow_drop_down),
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context) => List.from(
              widget.providerPile.filters.map(
                (filter) => PopupMenuItem<String>(
                  value: filter.id,
                  child: Text(filter.id),
                  onTap: () {
                    widget.providerPile.filter = filter;
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: TextField(
              autofocus: true,
              controller: _searchController,
              style: const TextStyle(
                fontSize: 14,
              ),
              focusNode: _searchFocus,
              decoration: const InputDecoration(
                hintText: 'Search',
                fillColor: Colors.transparent,
                hoverColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
              ),
              onSubmitted: (value) {
                widget.providerPile.search = value;
                _searchFocus.requestFocus();
                _searchSelection = _searchController.selection;
              },
            ),
          ),
        ],
      ),
    );
  }
}
