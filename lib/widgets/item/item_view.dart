import 'package:flutter/material.dart';
import 'package:collector/providers/item_provider.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mustache_template/mustache.dart';

String convertHtmlToText(String html) {
  try {
    final document = parse(html);
    final String text = parse(document.body!.text).documentElement!.text;
    return text;
  } catch (e) {
    return html;
  }
}

class ItemView extends StatelessWidget {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionProvider providerCollection = context.watch<CollectionProvider>();
    ItemProvider providerItem = context.watch<ItemProvider>();
    String markdown = convertHtmlToText(
      Template(providerCollection.template, lenient: true).renderString(providerItem.markdownData),
    );

    return Markdown(
      data: markdown,
      shrinkWrap: true,
      selectable: true,
      onTapLink: (text, href, title) async {
        String url = href.toString();
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url, mode: LaunchMode.platformDefault);
        } else {
          debugPrint('Could not launch $href');
        }
      },
    );
  }
}
