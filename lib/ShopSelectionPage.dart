import 'package:flutter/material.dart';
import 'package:task/ProductSelectionWidget.dart';

import 'Homepage.dart';

class ShopSelectionPage extends StatefulWidget {
  List<String> Shopnames;
  String? area;
  String? city;
  String? sector;

  ShopSelectionPage(
      {required this.Shopnames,
      required this.area,
      required this.city,
      required this.sector});

  @override
  _ShopSelectionPageState createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  late List<String> _shopNames;
  late String _selectedShop;

  @override
  void initState() {
    super.initState();
    _shopNames = widget.Shopnames;
    _selectedShop = _shopNames.first;
  }

  String productname = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _selectedShop);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, _selectedShop);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text('Clients'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Select Your Party',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedShop,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedShop = newValue!;
                      });
                    },
                    items: _shopNames.map((String shopName) {
                      return DropdownMenuItem<String>(
                        value: shopName,
                        child: Text(shopName),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            style: BorderStyle.solid)))),
                            onPressed: () {
                              Navigator.pop(context, MyHomePage());
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            style: BorderStyle.solid)))),
                            onPressed: () async {
                              productname = "";

                              var products = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductSelectionWidget(city: widget.city,area:  widget.area,sector:  widget.sector,party: _selectedShop,)));
                              if (products != null) {
                                productname = products;
                                setState(() {});
                              }
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )),

                        // ElevatedButton(
                        //     style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(style: BorderStyle.solid)))),
                        //     onPressed: () {
                        //       Navigator.push(context, MaterialPageRoute(builder: (context) => PartiesDropDown(),));
                        //     }, child: Text('Next',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     productname = "";
                  //
                  //     var products = await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 ProductPage(selectedshop: _selectedShop)));
                  //     if (products != null) {
                  //       productname = products;
                  //       setState(() {});
                  //     }
                  //   },
                  //   child: Text('Select Product'),
                  // ),
                  // if (productname != "") Text("Selected product   :$productname")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
