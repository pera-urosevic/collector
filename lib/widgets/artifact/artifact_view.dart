import 'package:flutter/material.dart';
import 'package:hoard/providers/artifact_provider.dart';
import 'package:hoard/providers/pile_provider.dart';
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

class ArtifactView extends StatelessWidget {
  const ArtifactView({super.key});

  @override
  Widget build(BuildContext context) {
    PileProvider providerPile = context.watch<PileProvider>();
    ArtifactProvider providerArtifact = context.watch<ArtifactProvider>();
    String markdown = convertHtmlToText(
      Template(providerPile.template, lenient: true).renderString(providerArtifact.markdownData),
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
