import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionChartBar extends StatelessWidget {
  final String _label;
  final double _amount;
  final double _percentage;

  const TransactionChartBar(this._label, this._amount, this._percentage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text('${NumberFormat.compact().format(_amount)}'),
        ),
        SizedBox(
          height: 4,
        ),
        Expanded(
          child: Container(
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: _percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text('${_label.toString()}'),
      ],
    );
  }
}
