import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<Map<dynamic, dynamic>> _ordersList = [];
  List<String> _orderKey = [];

  @override
  void initState() {
    super.initState();
    // Initialize the database reference

    // Retrieve the data from the database
    getUsers();
  }


  getUsers() async {
    FirebaseDatabase.instance.ref('orders').onValue.listen((DatabaseEvent event) {
     try{
       final data=event.snapshot.value;
       if(data!=null) {
         final map = data as Map<dynamic, dynamic>;
         _ordersList.clear();
         _orderKey.clear();
         map.forEach((key, value) {
           _ordersList.add(value);
           _orderKey.add(key);
         });
       }else{
         _ordersList.clear();
         _orderKey.clear();
       }
     }catch(e){
       print(e);

     }

      print(_orderKey);
      if(mounted)setState(() {});
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders List"),
      ),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          return true;
        },
        child: ListView.builder(
          itemCount: _ordersList.length,
          itemBuilder: (context, index) {
            // Get the data for each item
            final order = _ordersList[index];
            // Build the list item widget
            return ListTile(
              title: Text("Order ID: ${_orderKey[index]}"),
              subtitle: Text("Party: ${order['party']}"),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () async {

                  bool confirmDelete = await showDeleteConfirmationDialog(context);
                  if (confirmDelete) {
                    // Perform delete action
                    await FirebaseDatabase.instance
                        .ref('orders/${_orderKey[index]}')
                        .remove();
                    await getUsers();
                  } else {
                    // Cancel delete action
                  }

                },
              ),
              onTap: () {
                // Show more details about the order on tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(order),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final Map<dynamic, dynamic> orderData;

  OrderDetails(this.orderData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Area: ${orderData['area']}"),
            Text("City: ${orderData['city']}"),
            Text("Party: ${orderData['party']}"),
            Text("Products:"),
            Column(
              children: orderData['products'].map<Widget>((product) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${product['name']}"),
                    Text("Quantity: ${product['quantity']}"),
                    Text("Type: ${product['type']}"),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
            Text("Sector: ${orderData['sector']}"),
          ],
        ),
      ),
    );
  }
}
Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Confirmation"),
        content: Text("Are you sure you want to delete this item?"),
        actions: <Widget>[
          TextButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text("DELETE"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
