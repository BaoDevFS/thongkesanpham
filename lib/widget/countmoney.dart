import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:thongkehanghoa/widget/morningSession.dart';

class CountMoney extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CountMoneyState();
  }
}

class CountMoneyState extends State<CountMoney> {
  List<TextEditingController> listEdit;
  var sumary;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar() {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text("Bạn muốn trở về"),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      ),
    ));
  }

  generateListEditControl() {
    listEdit = new List();
    for (int i = 0; i < 10; i++) {
      listEdit.add(new TextEditingController());
    }
  }

  sumaryMoney() {
    var tmp = 0;
    tmp += ((int.parse(listEdit.elementAt(0).text == ""
                ? "0"
                : listEdit.elementAt(0).text) *
            500000) +
        (int.parse(listEdit.elementAt(1).text == "" ? "0" : listEdit.elementAt(1).text) *
            200000) +
        (int.parse(listEdit.elementAt(2).text == "" ? "0" : listEdit.elementAt(2).text) *
            100000) +
        (int.parse(listEdit.elementAt(3).text == "" ? "0" : listEdit.elementAt(3).text) *
            50000) +
        (int.parse(listEdit.elementAt(4).text == "" ? "0" : listEdit.elementAt(4).text) *
            20000) +
        (int.parse(listEdit.elementAt(5).text == "" ? "0" : listEdit.elementAt(5).text) *
            10000) +
        (int.parse(listEdit.elementAt(6).text == "" ? "0" : listEdit.elementAt(6).text) *
            5000) +
        (int.parse(listEdit.elementAt(7).text == "" ? "0" : listEdit.elementAt(7).text) *
            2000) +
        (int.parse(listEdit.elementAt(8).text == ""
                ? "0"
                : listEdit.elementAt(8).text) *
            1000) +
        (int.parse(listEdit.elementAt(9).text == ""
                ? "0"
                : listEdit.elementAt(9).text) *
            500));
    FlutterMoneyFormatter fb =
        new FlutterMoneyFormatter(amount: double.parse(tmp.toString()));
    setState(() {
      sumary = fb.output.withoutFractionDigits;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    generateListEditControl();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Text("Đếm tiền"),
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            showInSnackBar();
          },
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "500k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(0),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      autofocus: true,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "200k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(1),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "100k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(2),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "50k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(3),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "20k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(4),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "10k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(5),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "5k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(6),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "2k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(7),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "1k:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(8),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 70,
                    child: Text(
                      "500d:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: listEdit.elementAt(9),
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Tổng tiền:${sumary == null ? 0 : sumary}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RaisedButton(
                    child: Text("ENTER"),
                    onPressed: () {
                      sumaryMoney();
                      print(sumary);
                    },
                  )
                ],
              )
            ],
          ),
        ));
    throw UnimplementedError();
  }
}
