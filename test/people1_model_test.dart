import 'package:flutter_test/flutter_test.dart';
import 'package:isolates_playground/app/person_model.dart';

void main() {
  group(
    'Person1Model ',
    () {
      test(
        'fromJson should return a Person1Model with correct values',
        () async {
          // assert,
          final Map<String, dynamic> jsonMock = <String, dynamic>{
            "name": "Victor",
            "age": 27,
          };
          final person = PersonModel.fromJson(json: jsonMock);

          expect(person.age, 27);

          expect(person.name, "Victor");
        },
      );
    },
  );
}
