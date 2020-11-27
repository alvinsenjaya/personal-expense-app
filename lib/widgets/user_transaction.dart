import 'package:flutter/material.dart';
import 'package:personal_expense_app/models/transaction.dart';
import 'package:personal_expense_app/storage/transaction_storage.dart';
import 'package:personal_expense_app/widgets/transaction_add.dart';
import 'package:personal_expense_app/widgets/transaction_chart.dart';
import 'package:personal_expense_app/widgets/transaction_list.dart';
import 'package:uuid/uuid.dart';

class UserTransaction extends StatefulWidget {
  @override
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  List<Transaction> _userTransactions = [];

  @override
  void initState() {
    TransactionStorage()
        .readTransaction()
        .then((List<Transaction> transactions) {
      setState(() {
        _userTransactions = transactions;
        _sortByDate(_userTransactions);
      });
    });

    super.initState();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _sortByDate(List<Transaction> transactions) {
    return transactions.sort((a, b) {
      return b.date.compareTo(a.date);
    });
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: TransactionAdd(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTransaction = Transaction(
      id: Uuid().v4(),
      title: title,
      amount: amount,
      date: dateTime,
    );

    setState(() {
      _userTransactions.add(newTransaction);
      _sortByDate(_userTransactions);
    });

    TransactionStorage().writeTransaction(_userTransactions);
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });

    TransactionStorage().writeTransaction(_userTransactions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Expense App'), actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _showAddTransaction(context);
          },
        ),
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: TransactionChart(_recentTransactions),
            ),
            Expanded(
              child: TransactionList(_userTransactions, _deleteTransaction),
            ),
          ],
        ),
      ),
    );
  }
}
