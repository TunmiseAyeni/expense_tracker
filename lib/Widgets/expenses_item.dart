import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem(this.expense, {super.key});

  final Expense expense; //instance of the expense data model class

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Amount: \$${expense.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    // fontSize: 20,
                  ),
                ),
                const Spacer(), //takes up the available space, pushes the contents of the row to the right and the text to the left
                Row(
                  children: [
                     Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 5),
                    Text(expense.formattedDate),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
