import 'package:hoard/models/forge_model.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker.dart';

const refs = [
  {
    'id': 'Scribed A',
    'date': '2022-02-22',
    'image': 'http://localhost/test/testing.png',
    'text': 'a4\na5\na6',
    'markdown': 'a1\na2\na3\na4\na5\na6',
    'select': 'A - AAA',
    'string': 'a string',
    'boolean': true,
    'list': ['a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a0'],
    'tags': ['TagA1', 'TagA2', 'TagA3', 'TagA4', 'TagA5'],
  },
  {
    'id': 'Scribed B',
    'date': '',
    'image': '',
    'text': '',
    'markdown': '',
    'select': '',
    'string': '',
    'boolean': false,
    'list': [],
    'tags': [],
  },
];

class ForgeWorkerTest extends ForgeWorker {
  @override
  Future<List<Map>> search(String query) async {
    return [
      {'id': '1', 'label': 'Scribed 1', 'ref': refs[0]},
      {'id': '2', 'label': 'Scribed 2', 'ref': refs[1]},
    ];
  }

  @override
  Future<ForgingModel> fetch(Map ref) async {
    ForgingModel forging = ForgingModel.from(ref);
    return forging;
  }
}
