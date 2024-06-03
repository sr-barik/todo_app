import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/changes.dart';
import 'package:todo_app/schema/model.dart'; // Ensure to import the Note class here

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Providerclass>(
      builder: (context, provider, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 13, 10, 19),
                Color.fromARGB(255, 82, 50, 150),
                Color.fromARGB(255, 13, 10, 19),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'To-Do',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15, left: 15),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 218, 214, 214),
                    hintText: 'Search here...',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
              Expanded(
                child: provider.note.isNotEmpty
                    ? ListView.builder(
                        itemCount: provider.note.length,
                        itemBuilder: ((context, index) {
                          final note = provider.note[index];
                          final formattedDate =
                              DateFormat.yMd().format(note.date);
                          return Dismissible(
                            key: Key(note.id), // Unique key for each item
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              provider.removeNoteById(note.id);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              color: Colors.deepPurpleAccent,
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Title: ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              note.title,
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.white),
                                              onPressed: () {
                                                _showBottomSheet(context,
                                                    noteToEdit: note);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Description: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          note.description,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Date: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      )
                    : const Center(
                        child: Text(
                          'Add anything....',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 22),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, {Note? noteToEdit}) {
    final formatter = DateFormat.yMd();
    final provider = Provider.of<Providerclass>(context, listen: false);
    TextEditingController titleController =
        TextEditingController(text: noteToEdit?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: noteToEdit?.description ?? '');

    if (noteToEdit != null) {
      provider.setDate(noteToEdit.date);
    }

    void presentDatePicker() async {
      final now = DateTime.now();
      final firstDate = DateTime(now.year - 1, now.month, now.day);
      final lastDate = DateTime(now.year + 1, now.month, now.day);
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: firstDate,
          lastDate: lastDate);

      if (pickedDate != null) {
        provider.setDate(pickedDate);
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Add Note',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    'Title:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: titleController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: descriptionController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Date:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Consumer<Providerclass>(
                    builder: (context, provider, child) => Row(
                      children: [
                        Text(provider.date == null
                            ? 'No Date Selected'
                            : formatter.format(provider.date!)),
                        IconButton(
                          onPressed: presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          if (noteToEdit != null) {
                            provider.editNote(
                              noteToEdit.id,
                              titleController.text,
                              descriptionController.text,
                              provider.date!,
                            );
                          } else {
                            provider.addNote(
                              titleController.text,
                              descriptionController.text,
                            );
                          }
                          Navigator.pop(context);
                        },
                        child: const Text("Save"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
