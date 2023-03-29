import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:task/OrdersPage.dart';

class ProductSelectionWidget extends StatefulWidget {
  final city, area, sector, party;

  const ProductSelectionWidget(
      {super.key,
      required this.city,
      required this.area,
      required this.sector,
      required this.party});

  @override
  _ProductSelectionWidgetState createState() => _ProductSelectionWidgetState();
}

class _ProductSelectionWidgetState extends State<ProductSelectionWidget> {
  List<String> _productNames = [
    'ARIA SYP 60ML',
    'CYROCIN 250MG TAB 10,S',
    'CYROCIN 500MG TAB 10,S',
    'ALCAL 0.5MG TAB 10,S ',
    'ARTECXIN FORT DIS Tb 8,S',
    'ARTECXIN PLUS TAB 6,S',
    'AEROTEC 200MG CAP 30,S',
    'AEROTEC-B FORTE 30,S',
    'AEROTEC-B CAP 30,S',
    'AEROTEL TAB 5MG 14,S',
  ].toSet().toList();

  List<Map<String, dynamic>> _selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Selection'),
      ),
      body: ListView.builder(
        itemCount: _productNames.length,
        itemBuilder: (BuildContext context, int index) {
          final product = _productNames[index];
          return ListTile(
            leading: Checkbox(
              value: _selectedProducts
                  .any((element) => element['name'] == product),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedProducts
                        .add({'name': product, 'type': 'S', 'quantity': '1'});
                  } else {
                    _selectedProducts
                        .removeWhere((element) => element['name'] == product);
                  }
                });
              },
            ),
            title: Text(product),
            subtitle: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Quantity"),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedProducts.firstWhere((element) =>
                                element['name'] == product)['quantity'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Quantity Type"),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Quantity Type',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedProducts.firstWhere((element) =>
                                element['name'] == product)['type'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(_selectedProducts);
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("orders").push();

          await ref.set({
            "city": widget.city.toString(),
            "area": widget.area.toString(),
            "sector": widget.sector.toString(),
            "party": widget.party.toString(),
            "products": _selectedProducts
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersList(),
              ));
        },
        child: Icon(Icons.check),
      ),
    );
  }

  var val = "S";
}
