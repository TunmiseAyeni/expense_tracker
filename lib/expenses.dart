import 'package:expense_tracker/Widgets/expenses_list.dart';
import 'package:expense_tracker/Widgets/new_expense.dart';
import 'package:expense_tracker/chart/chart.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//A context is an object full of metadata that is managed by flutter that belongs to a specific widget, that contains metadata information related to the widget and the widgets position in the overall UI and widget tree.

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  //creating a list of dummy data using the expense data model class
  final registeredExpenses = [
    Expense(
      title: 'Groceries',
      amount: 100.00,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Flight to Dubai',
      amount: 1000.00,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void openAddExpenseOverlay() {
    showModalBottomSheet(
        // useSafeArea: true,
        isScrollControlled:
            true, //this makes the modal sheet take up the full screen
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: addExpense,
            ));
  }

  void addExpense(Expense expense) {
    //we are adding the new expense to the list of expenses
    setState(() {
      registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = registeredExpenses.indexOf(expense);
    setState(
      () {
        registeredExpenses.remove(expense);
      },
    );
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); //this hides the current snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              registeredExpenses.insert(expenseIndex,
                  expense); //inserts the expense back into the list of expenses
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //we are getting the width of the screen using the mediaquery
    final width = MediaQuery.of(context).size.width;

    //if the list of expenses is empty, we display a text widget that says 'No expenses added yet'
    Widget mainContent = const Center(
      child: Text('No expenses added yet'),
    );
    if (registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        registeredExpenses: registeredExpenses,
        onRemoveExpense: removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Expense Tracker',
            textAlign: TextAlign.start,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 15,
            )),
        // backgroundColor: const Color.fromARGB(255, 70, 5, 82),
        actions: [
          IconButton(
            onPressed: () {
              openAddExpenseOverlay();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      //if the width of the screen is less than 600, we display the chart and the list of expenses in a column, else we display them in a row
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                //we are using the expanded widget to make sure the chart takes up the available space
                Expanded(
                  child: Chart(expenses: registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
