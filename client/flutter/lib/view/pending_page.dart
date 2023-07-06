import 'package:flutter/material.dart';
import '../objects/singletons.dart';
import '../objects/transaction.dart';
import '../presenter/transaction_presenter.dart';
import 'package:intl/intl.dart';

import 'main_drawer_view.dart';

class PendingPage extends StatefulWidget {
  @override
  PendingPageState createState() => new PendingPageState();
}

class PendingPageState extends State<PendingPage> {
  TransactionPresenter presenter = new TransactionPresenter();
  List transactionList = AppContext().user?.pendingTransactions ?? [];
  final DateFormat dateFormatter = DateFormat('MMMM d');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pending Transactions")),
        body: buildBody(),
        drawer: MainDrawer());
  }

  Widget buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactionList.length * 2,
      itemBuilder: (context, item) {
        int index = item ~/ 2;
        if (item.isOdd) return Divider();
        if (index >= transactionList.length) return SizedBox();
        return buildRow(transactionList[index], index);
      },
    );
  }

  Widget buildRow(Transaction t, int index) {
    //TODO: See if the backend provides a better system to check if current user is the sender or receiver?
    String startString = "Are you sure you wish to ";
    bool usersRequest = false;
    String senderName = t.sender;
    String receiverName = t.receiver;
    if (senderName == "you") usersRequest = true;
    return Dismissible(
        key: ValueKey(t),
        onDismissed: (DismissDirection direction) {
          setState(() {
            //if the deletion was successful on the server
            if (usersRequest
                ? presenter.cancelRequest(t)
                : presenter.declinePayment(t)) //remove from list
              transactionList.removeAt(index);
          });
        },
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: usersRequest
                    ? Text(
                        startString + "delete your request to " + receiverName)
                    : Text(startString + "deny " + senderName + "'s request?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: usersRequest
                          ? const Text("DELETE")
                          : const Text("DENY")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("GO BACK"),
                  ),
                ],
              );
            },
          );
        },
        child: ListTile(
            title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                    t.receiver +
                        " requested " +
                        t.amount.toString() +
                        " MyCHIPs from " +
                        t.sender,
                    style: const TextStyle(fontSize: 15))),
            subtitle: Text(dateFormatter.format(t.date)),
            trailing: usersRequest
                ? MaterialButton(
                    onPressed: () {},
                    child: const Text('Send',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    color: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    elevation: 5,
                    height: 40,
                  )
                : MaterialButton(
                    onPressed: () {},
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    color: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    elevation: 5,
                    height: 40,
                  )));
  }

  confirmDelete(DismissDirection direction) async {}
}
