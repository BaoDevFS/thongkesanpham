
import 'package:flutter/material.dart';
import 'package:thongkehanghoa/control/controlTotalDay.dart';

class TotalDay extends StatefulWidget{
  ControlTotalDay controlTotalDay;
  TotalDay({this.controlTotalDay});
  @override
  State<StatefulWidget> createState() {
   return _TotalDayState();
    // TODO: implement createState
  }

}
class _TotalDayState extends State<TotalDay> {
  TextEditingController _edit= new TextEditingController(text: "0");
  @override
  void dispose() {
    // TODO: implement dispose
    _edit.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_)=>_edit.text="${widget.controlTotalDay.total}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tổng ngày"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: FutureBuilder<Map<String, int>>(
                  initialData: widget.controlTotalDay.list,
                  future: widget.controlTotalDay.getList(),
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.done:
                        if(snapshot.hasData){
                          _edit.text="${widget.controlTotalDay.total}";
                          var maps = snapshot.data;
                          return ListView.builder(
                              itemCount: maps.length,
                              itemBuilder: (context,i){
                                String name = maps.keys.elementAt(i);
                                int sl = maps[name];
                                return _rowInListView(name, sl, widget.controlTotalDay.listPrice.elementAt(i), i);
                              });
                        }else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                        break;
                      case ConnectionState.none:
                      // TODO: Handle this case.
                      case ConnectionState.waiting:
                      // TODO: Handle this case.
                      case ConnectionState.active:
                      // TODO: Handle this case.
                      default:return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
            ),
            Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                TextField(
                  controller: _edit,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText:"Tổng tiền thu",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                    )
                  ),
                )
                ],
              )
          ],
        ),
      ),
    );
  }
  Widget _rowInListView(String name, int sl , double price, int index){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(style: BorderStyle.solid,width: 0.5,color: Colors.black))
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$name',style: TextStyle(fontSize: 18,color: Colors.black54),),
              Text('SL: $sl',),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text('Tổng tiền:${sl*price}',style: TextStyle(fontSize: 16,color: Colors.blue)),
        ],
      ),
    );

  }
}