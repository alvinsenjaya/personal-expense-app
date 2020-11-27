import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:personal_expense_app/models/transaction.dart';

class TransactionStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/transactions.json');
  }

  Future<List<Transaction>> readTransaction() async {
    try {
      final file = await _localFile;

      // Read the file
      String jsonString = await file.readAsString();
      final jsonResponse = json.decode(jsonString);

      final List<Transaction> transactions = jsonResponse
          .map<Transaction>((i) => Transaction.fromJson(i))
          .toList();

      return transactions;
    } catch (e) {
      // If encountering an error, return empty list
      print(e);
      print('something error happen');
      return [];
    }
  }

  Future<File> writeTransaction(List<Transaction> transactions) async {
    final file = await _localFile;

    String jsonString =
        jsonEncode(transactions.map((i) => i.toJson()).toList()).toString();

    // Write the file
    return file.writeAsString(jsonString);
  }
}
