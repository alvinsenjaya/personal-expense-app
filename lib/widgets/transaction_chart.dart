import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_app/models/transaction.dart';
import 'package:personal_expense_app/widgets/transaction_chart_bar.dart';

class TransactionChart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const TransactionChart(this._recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalAmount = 0.0;

      for (var i = 0; i < _recentTransactions.length; i++) {
        if (_recentTransactions[i].date.day == weekDay.day &&
            _recentTransactions[i].date.month == weekDay.month &&
            _recentTransactions[i].date.year == weekDay.year) {
          totalAmount = totalAmount + _recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalAmount
      };
    }).reversed.toList();
  }

  double get totalAmount {
    return groupedTransactionValues.fold(0.0, (sum, transaction) {
      return sum + transaction['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            width: double.infinity,
            child: Text(
              'Last Week Summary (IDR) :',
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: groupedTransactionValues.map((data) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: TransactionChartBar(
                        data['day'],
                        data['amount'],
                        totalAmount == 0
                            ? 0
                            : (data['amount'] as double) / totalAmount,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
