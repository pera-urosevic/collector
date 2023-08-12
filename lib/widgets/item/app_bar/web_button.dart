import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebButton extends StatefulWidget {
  const WebButton({super.key});

  @override
  State<WebButton> createState() => _WebButtonState();
}

class _WebButtonState extends State<WebButton> {
  @override
  Widget build(BuildContext context) {
    ItemProvider providerItem = context.watch<ItemProvider>();

    return IconButton(
      icon: const Icon(Icons.public),
      onPressed: () {
        String query = providerItem.uid.replaceAll(' ', '+');
        String url = 'https://www.google.com/search?q=$query';
        launchUrlString(url);
      },
    );
  }
}
