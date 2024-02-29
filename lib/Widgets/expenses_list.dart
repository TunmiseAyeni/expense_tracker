import 'package:expense_tracker/Widgets/expenses_item.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

//note: dont use columns for long list of items where the length of the list is unknown, use listview instead
//Using Listview(children:[]) will still render all the items in the list at once, which is not efficient, only different thing is that it will allow scrolling
//so we use Listview.builder() instead, which tells flutter that it should build,render or create the list items only when they visible or about to be visible on the screen not all at once.
// Creates a scrollable, linear array of widgets that are created on demand.
//This constructor is appropriate for list views with a large (or infinite) number of children because the builder is called only for those children that are actually visible.
//Providing a non-null itemCount improves the ability of the [ListView] to estimate the maximum scroll extent
//The [itemBuilder] callback will be called only with indices greater than or equal to zero and less than itemCount.
//for every item in the list, the itemBuilder function will be called and the item will be rendered on the screen
//The itemBuilder function is called for every item in the list, and it returns a widget that will be rendered on the screen
//for every time the function is called, the index of the item in the list is passed to the function
//for every function call, index would be incremented by 1
//for every item in the list, the itemBuilder function will be called and the item will be rendered on the screen
class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key,
      required this.registeredExpenses,
      required this.onRemoveExpense});
  final List<Expense> registeredExpenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: registeredExpenses.length,
        itemBuilder: (context, index) => Dismissible(
            onDismissed: //this function is called when the item is dismissed/swiped away
                (direction) => onRemoveExpense(registeredExpenses[
                    index]), // we are calling the onRemoveExpense function and passing the expense that was swiped away as an argument
            key: ValueKey(registeredExpenses[index].id), //unique key for each item
            background: Container(
              color: Theme.of(context).colorScheme.error,
              margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal),//we are using the cardTheme margin to make sure the background color is the same as the card
            ),
            child: ExpensesItem(registeredExpenses[index])));
  }
}
