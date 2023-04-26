import 'package:flutter/material.dart';
import 'package:hoard/config.dart';
import 'package:hoard/widgets/pile.dart';
import 'package:hoard/widgets/prompt.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:provider/provider.dart';
import 'package:hoard/providers/hoard_provider.dart';

class Hoard extends StatefulWidget {
  const Hoard({super.key});

  @override
  State<Hoard> createState() => _HoardState();
}

class _HoardState extends State<Hoard> {
  late String mode;

  @override
  initState() {
    mode = config.get('mode');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HoardProvider providerHoard = context.watch<HoardProvider>();
    PileProvider providerPile = context.watch<PileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoard'),
        actions: [
          IconButton(
            icon: Icon(
              mode == 'tall' ? Icons.horizontal_distribute : Icons.vertical_distribute,
            ),
            onPressed: () async {
              String newMode = mode == 'tall' ? 'wide' : 'tall';
              config.set('mode', newMode);
              setState(() => mode = newMode);
            },
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: Center(
        // list of piles
        child: ListView.builder(
          itemCount: providerHoard.size,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              providerHoard.pileIds[index],
            ),
            onTap: () async {
              await providerPile.loadPile(providerHoard.pileIds[index]);
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pile(),
                ),
              );
            },
          ),
        ),
      ),
      // add a new pile
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String newPileId = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Prompt(
                title: 'Create new pile',
                hint: 'Pile ID',
                valid: (value) => RegExp('^[a-zA-Z0-9]+\$').hasMatch(value),
              ),
            ),
          );
          await providerHoard.createPile(newPileId);
        },
      ),
    );
  }
}
