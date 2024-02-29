// data model for expense
//added a uuid package thatll help us in generating unique ids for our expenses dynamically
//added an intl package to help us with formatting dates
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid(); // Creating a Uuid instance of the uuid package
DateFormat formatter = DateFormat
    .yMd(); //creating a formatter instance of the intl package, ymd means year, month and date

// enum is a special data type that allows for a variable to be a set of predefined constants
enum Category {
  food,
  travel,
  leisure,
  work,
}

//Creating a map that stores the icons for each category
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};
//note: an enum can not be used in a class as a property type

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid
            .v4(); // Generating a unique id for each expense using the uuid package
  // the initializer list is used to initialize properties that can not be initialized in the constructor function body

  final String id;
  final String title;
  final double amount;
  final DateTime
      date; //Date time data type allows us to store date in a single value
  final Category category;

  String get formattedDate {
    return formatter.format(date); //format is from the int9iul package
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

//creating an alternative consstructor that helps filter the expenses based on the category
//basically, this alternative function helps us to filter out the expenses based on the category, we create a new list of expenses called all expenses and pass it as a parameter to the constructor function alongside the category we want to filter by, we use the initializer list to initalize the allexpenses since we cant initialize it in the constructor function body. We assign the allexpenses to the already created expenses list. The allexpenses.where function goes through every list expense and takes each expense as an argument passed into 'expense' and checks if the category of the expense is equal to the category we want to filter by, if it is, it adds it to the list of filtered expenses, if not, it doesnt add it to the list of expenses. The toList() function is used to convert the iterable to a list.
  ExpenseBucket.forCategory(
    final List<Expense> allExpenses, 
    {
    required this.category,
  }) : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    //the for in lopop is best used when you want to iterate over the elements of a list
    for (final expense in expenses) {
      sum += expense
          .amount; //summing up the amount of all the expenses in the list
    }
    return sum;
  }
}
