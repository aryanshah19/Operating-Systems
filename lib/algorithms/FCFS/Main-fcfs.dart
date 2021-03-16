import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'fcfs.dart';
import 'table.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Algorithm(),
    );
  }
}

class Algorithm extends StatefulWidget {
  @override
  _AlgorithmState createState() => _AlgorithmState();
}

class _AlgorithmState extends State<Algorithm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 800), () {
      completer.complete();
    });
    setState(() {
      prs.removeRange(0, prs.length);
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  List<Process> prs = [];
  FocusNode nodebt = FocusNode();

  add(TextEditingController control1, TextEditingController control2) {
    setState(() {
      prs.sort((a, b) => a.pid.compareTo(b.pid));
      prs.add(Process(int.parse(control1.text), int.parse(control2.text)));
      control1.clear();
      control2.clear();
      assignPid(prs);
      fcfsalgo(prs);
      prs.sort((a, b) => a.at.compareTo(b.at));
    });
  }

  delete() {
    setState(() {
      prs.sort((a, b) => a.pid.compareTo(b.pid));
      if (prs.length > 1) {
        prs.removeLast();
      } else {
        prs.remove(prs.length - 1);
      }
      assignPid(prs);
      fcfsalgo(prs);
      prs.sort((a, b) => a.at.compareTo(b.at));
    });
  }

  TextEditingController control1 = new TextEditingController();
  TextEditingController control2 = new TextEditingController();

  createaddDialog(BuildContext context, List<Process> prs) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ), //this right here
            child: Container(
              height: 280.0,
              width: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'at:',
                                  style: TextStyle(
                                    color: Color(0xFF22456D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorWidth: 3,
                                  cursorColor: Color(0XFFF36735),
                                  textAlign: TextAlign.center,
                                  showCursor: true,
                                  controller: control1,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (control1) {
                                    FocusScope.of(context).requestFocus(nodebt);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'bt:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextField(
                                  textAlign: TextAlign.center,
                                  focusNode: nodebt,
                                  cursorWidth: 3,
                                  cursorColor: Color(0XFFF36735),
                                  showCursor: true,
                                  controller: control2,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (text) {
                                    add(control1, control2);
                                    Navigator.of(context)
                                        .pop(); // Redraw the Stateful Widget
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 38),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Cancel"),
                              onPressed: () {
                                control1.clear();
                                control2.clear();
                                Navigator.of(context).pop();
                              }),
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Submit"),
                              onPressed: () {
                                add(control1, control2);
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCFS'),
        backgroundColor: Color(0xff22456d),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: FlatButton(
              color: Color(0xff22456d),
              onPressed: //null,
                  () {
                prs.sort((a, b) => a.pid.compareTo(b.pid));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TheTable(prs),
                  ),
                );
              },
              child: Icon(
                Icons.table_view_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 70),
            child: Container(
              color: Color(0xff22456d),
              width: 60,
              child: FlatButton(
                onPressed: () {
                  createaddDialog(context, prs);
                },
                child: Icon(
                  Icons.add_box,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: LiquidPullToRefresh(
              animSpeedFactor: 2.5,
              onRefresh: _handleRefresh,
              child: ListView.builder(
                  itemCount: prs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildProcesscard(context, index)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProcesscard(BuildContext context, int index) {
    TextEditingController econtrol1 = new TextEditingController();
    TextEditingController econtrol2 = new TextEditingController();

    econtrol1 = TextEditingController(text: prs[index].at.toString());
    econtrol2 = TextEditingController(text: prs[index].bt.toString());

    var at = prs[index].at.toString();
    var bt = prs[index].bt.toString();
    var tat = prs[index].tat.toString();
    var start = prs[index].start_time.toString();
    var end = prs[index].ct.toString();
    var wt = prs[index].wt.toString();

    void deleteprs(int index) {
      setState(() {
        if (prs.length > 0) {
          prs.removeAt(index);
          fcfsalgo(prs);
        } else {
          setState(() {});
        }
      });
    }

    void editprs(int index, TextEditingController econtrol1,
        TextEditingController econtrol2) {
      setState(() {
        prs[index].at = int.parse(econtrol1.text);
        prs[index].bt = int.parse(econtrol2.text);
        fcfsalgo(prs);
        prs.sort((a, b) => a.at.compareTo(b.at));
      });
    }

    editDialog(BuildContext context, List<Process> prs, int index) {
      return showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ), //this right here
              child: Container(
                height: 280.0,
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'at:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextField(
                                    autofocus: true,
                                    cursorWidth: 3,
                                    cursorColor: Colors.amber,
                                    textAlign: TextAlign.center,
                                    showCursor: true,
                                    controller: econtrol1,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      FocusScope.of(context)
                                          .requestFocus(nodebt);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'bt:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextField(
                                    textAlign: TextAlign.center,
                                    focusNode: nodebt,
                                    cursorWidth: 3,
                                    cursorColor: Colors.amber,
                                    showCursor: true,
                                    controller: econtrol2,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      editprs(index, econtrol1, econtrol2);
                                      Navigator.of(context)
                                          .pop(); // Redraw the Stateful Widget
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 38),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text("Cancel"),
                                onPressed: () {
                                  control1.clear();
                                  control2.clear();
                                  Navigator.of(context).pop();
                                }),
                            RaisedButton(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text("Submit"),
                                onPressed: () {
                                  editprs(index, econtrol1, econtrol2);
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ExpansionTile(
            title: Text(
              "at: $at\t      \t bt: $bt",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade200,
              child: Text(
                prs[index].pid,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Icon(
              Icons.arrow_drop_down_circle_outlined,
            ),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Start Process: $start",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "End Process: $end",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "TAT: $tat",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "WT: $wt",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Card(
            //radius: 30,
            //margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: IconSlideAction(
              //caption: 'Text1',
              color: Colors.green,
              icon: Icons.edit_outlined,
              onTap: () {
                editDialog(context, prs, index);
                setState(() {});
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Card(
            //radius: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: IconSlideAction(
              //caption: 'Text2',
              color: Color(0XFFF36735),
              icon: Icons.delete_rounded,
              onTap: () {
                prs.removeAt(index);
                deleteprs(index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
