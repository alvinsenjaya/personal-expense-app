import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  const TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: transactions.isEmpty
          ? buildNoTransactionContent()
          : buildTransactionList(context),
    );
  }

  ListView buildTransactionList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (buildContext, index) {
        return Card(
          margin: EdgeInsets.all(2),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 70.0,
                color: Theme.of(context).primaryColorLight,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      'IDR ${NumberFormat.compact().format(transactions[index].amount)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              transactions[index].title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            subtitle: Text(
              DateFormat('dd MMM yyyy').format(transactions[index].date),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                _deleteTransaction(transactions[index].id);
              },
            ),
          ),
        );
      },
      itemCount: transactions.length,
    );
  }

  LayoutBuilder buildNoTransactionContent() {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: constraint.maxHeight * 0.1,
          ),
          Text(
            'No Transaction Added Yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.1,
          ),
          Container(
            height: constraint.maxHeight * 0.5,
            child: Image.asset(
              'assets/images/waiting.png',
              fit: BoxFit.contain,
              color: Color.fromRGBO(255, 255, 255, 0.15),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
      );
    });
  }
}
