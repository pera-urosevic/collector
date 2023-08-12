import 'package:flutter/material.dart';
import 'package:collector/config.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:provider/provider.dart';

class CollectionBottomBar extends StatefulWidget {
  final CollectionProvider providerCollection;

  const CollectionBottomBar({super.key, required this.providerCollection});

  @override
  State<CollectionBottomBar> createState() => _CollectionBottomBarState();
}

class _CollectionBottomBarState extends State<CollectionBottomBar> {
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
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    _searchController.value = TextEditingValue(
      selection: _searchSelection,
      text: providerCollection.search,
    );

    if (config.get('mode') == 'wide') _searchFocus.requestFocus();

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 70, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.providerCollection.filter.id),
          PopupMenuButton<String>(
            initialValue: widget.providerCollection.filter.id,
            icon: const Icon(Icons.arrow_drop_down),
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context) => List.from(
              widget.providerCollection.filters.map(
                (filter) => PopupMenuItem<String>(
                  value: filter.id,
                  child: Text(filter.id),
                  onTap: () {
                    widget.providerCollection.filter = filter;
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
                widget.providerCollection.search = value;
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
