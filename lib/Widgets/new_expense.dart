import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // var enteredTitle =
  //     ''; //initial state when the user hasnt entered anything, its empty
  // void saveTitleInput(String inputValue) {
  //   //anytime the function is called, itll always pass a string as an argumet, in this case, inputValue
  //   enteredTitle =
  //       inputValue; //updating the enteredTitle with the input entered by the user
  // }
//Alternatively, we can use TextEditingController for flutter to manage it itself
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.travel;

  @override
  void dispose() {
    titleController
        .dispose(); //we do this because we want TextEditingController to be destroyed/disposed when the widget (in this case, the modal) it is in is not visible anymore so that it will not be continued to be stored in memory
    amountController.dispose();
    super.dispose();
  }

//In Dart and Flutter, async and await are used for asynchronous programming. They allow your program to perform other tasks while waiting for an operation to complete.
// An async function returns a Future. A Future represents a potential value or error that will be available at some time in the future.
  void presentDayPicker() async {
    final initialDate =
        DateTime.now(); //setting the initial date to todays date
    final firstDate = DateTime(initialDate.year - 1, initialDate.month,
        initialDate.day); //setting the firstDate to todays date a year ago

//await: The await keyword works only in async functions. It makes Dart pause execution of the function until the awaited expression (which should return a Future) completes. in this case, flutter should wait for the value, before its stored in the pickedDate variable. After the awaited operation completes, Dart resumes execution of the function.
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate:
            initialDate, //lastDate is the last possible you can set for this
        initialDate: initialDate);
    setState(() {
      selectedDate = pickedDate; //setting the selected date to the picked date
    });
  }

  void determineDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: Text(
                  'Invalid Input',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                content: Text(
                  'Please make sure the required fields are filled',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid Input',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          content: Text(
            'Please make sure the required fields are filled',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    }
  }

  void submitFormData() {
    final enteredAmount = double.tryParse(amountController
        .text); //tryParse returns a double if the value is a number, else it returns null
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    final enteredTitleIsInvalid =
        titleController.text.trim().isEmpty; //trim removes white spaces
    if (enteredTitleIsInvalid || amountIsInvalid || selectedDate == null) {
      determineDialog();
      return;
    }
    widget.onAddExpense(Expense(
      title: titleController.text,
      amount: enteredAmount,
      date: selectedDate!,
      category: selectedCategory,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //this object contains extra information about UI elements that might be overlapping certain parts of the UI in this case, the bottom, it helps us to get the amount of space taken by the keyboard(whivh is overlapping the UI)
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    //to make the modal overlay scrollable, we wrap the column in a singlechildscrollview
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: titleController,
                            // onChanged:
                            //     saveTitleInput, //allows us to register a function that will be triggered whenever the value in that Textfield changes, e.g everytime the user presses  a key
                            maxLength: 50, //maximum length of characters
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ', //adds a prefix text
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: titleController,
                      // onChanged:
                      //     saveTitleInput, //allows us to register a function that will be triggered whenever the value in that Textfield changes, e.g everytime the user presses  a key
                      maxLength: 50, //maximum length of characters
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton(
                              value:
                                  selectedCategory, //allows the selected value to be shown on the screen
                              items: Category.values
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value:
                                          category, //were saying that the value that should be returned is category, we have to set this because by default, it is dynamic
                                      child: Text(category.name
                                              .toUpperCase() //converting each category to a string
                                          ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  selectedCategory = value;
                                });
                              }), //value here will be the category of the selected item
                          const SizedBox(
                            width: 24,
                          ),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(selectedDate == null
                                    ? 'No Date Selected'
                                    : formatter.format(selectedDate!)),
                                IconButton(
                                    onPressed: () {
                                      presentDayPicker();
                                    },
                                    icon: const Icon(Icons.calendar_month)),
                              ],
                            ),
                          )
                        ])
                  else
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ', //adds a prefix text
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(selectedDate == null
                                ? 'No Date Selected'
                                : formatter.format(selectedDate!)),
                            IconButton(
                                onPressed: () {
                                  presentDayPicker();
                                },
                                icon: const Icon(Icons.calendar_month)),
                          ],
                        ),
                      )
                    ]),
                  const SizedBox(
                    height: 20,
                  ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context); //This allows us to close the modal overlay
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              submitFormData();
                            },
                            child: const Text('Save Expense')),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value:
                                selectedCategory, //allows the selected value to be shown on the screen
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value:
                                        category, //were saying that the value that should be returned is category, we have to set this because by default, it is dynamic
                                    child: Text(category.name
                                            .toUpperCase() //converting each category to a string
                                        ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }), //value here will be the category of the selected item
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context); //This allows us to close the modal overlay
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              submitFormData();
                            },
                            child: const Text('Save Expense')),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
