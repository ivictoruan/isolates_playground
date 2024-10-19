import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'person_model.dart';

class ViewController {
  Future<List<PersonModel>> getPersons() async {
    final rp = ReceivePort();
    await Isolate.spawn<SendPort>(
      _getPersons,
      rp.sendPort,
    );

    return await rp.first;
  }

  void _getPersons(SendPort sp) async {
    const url = 'http://10.0.2.2:5500/apis/people1.json';
    try {
      final List<PersonModel> persons = await HttpClient()
          .getUrl(Uri.parse(url))
          .then((req) => req.close())
          .then((response) => response.transform(utf8.decoder).join())
          .then((stringJson) => jsonDecode(stringJson) as List<dynamic>)
          .then(
            (json) =>
                json.map((map) => PersonModel.fromJson(json: map)).toList(),
          );
      Isolate.exit(sp, persons);
    } catch (e) {
      log('Erro: $e');
    }
  }
}
