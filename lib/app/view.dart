import 'package:flutter/material.dart';

import 'controller.dart';
import 'person_model.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final controller = ViewController();

  List<PersonModel> persons = [];

  bool isLoading = false;

  Future<void> getPersons1() async {
    isLoading = true;
    setState(() {});

    persons = await controller.getPersons();

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Center(
              child: !isLoading
                  ? persons.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: persons.length,
                            itemBuilder: (
                              context,
                              index,
                            ) =>
                                Text(
                              'Nome: ${persons[index].name} e Idade: ${persons[index].age}',
                            ),
                          ),
                        )
                      : const Text('Sem pessoas!')
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async => await getPersons1(),
              label: const Text('Get Persons'),
            ),
          ),
        ),
      );
}
