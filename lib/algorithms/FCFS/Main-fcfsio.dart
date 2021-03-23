import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'fcfs_io.dart';
import 'table.dart';
import 'gantt.dart';
//import 'Main-fcfsio.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class fcfsio_page extends StatefulWidget {
  @override
  _fcfsio_pageState createState() => _fcfsio_pageState();
}

class _fcfsio_pageState extends State<fcfsio_page> {
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

  List<ioprocess> prs = [];
  FocusNode nodebt = FocusNode();
  FocusNode nodebt2 = FocusNode();
  FocusNode nodeiobt = FocusNode();

  //control1 - at, control2 - bt1, control3 - iobt, control4 - bt2
  add(TextEditingController control1, TextEditingController control2,
      TextEditingController control3, TextEditingController control4) {
    setState(() {
      prs.sort((a, b) => a.pid.compareTo(b.pid));
      //prs.add(ioprocess(0, 6, 10, 4));
      //prs.add(ioprocess(0, 9, 15, 6));
      //prs.add(ioprocess(0, 3, 5, 2));
      int at = int.parse(control1.text);
      int bt1 = int.parse(control2.text);
      int bt2 = int.parse(control4.text);
      int iobt = int.parse(control3.text);
      //prs.add(ioprocess(int.parse(control1.text), int.parse(control2.text),
      //int.parse(control3.text), int.parse(control4.text)));
      prs.add(ioprocess(at, bt1, iobt, bt2));
      assignPid(prs);
      prs.sort((a, b) => a.at.compareTo(b.at));
      prs = fcfsioalgo(prs);
      //printprocess(prs);
      control1.clear();
      control2.clear();
      control3.clear();
      control4.clear();
      // prs.sort((a, b) => a.pid.compareTo(b.pid));
    });
  }

  TextEditingController control1 = new TextEditingController();
  TextEditingController control2 = new TextEditingController();
  TextEditingController control3 = new TextEditingController();
  TextEditingController control4 = new TextEditingController();

  createaddDialog(BuildContext context, List<ioprocess> prs) {
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
                                    FocusScope.of(context)
                                        .requestFocus(nodeiobt);
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
                                  'iobt:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextField(
                                  textAlign: TextAlign.center,
                                  focusNode: nodeiobt,
                                  cursorWidth: 3,
                                  cursorColor: Color(0XFFF36735),
                                  showCursor: true,
                                  controller: control3,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (control3) {
                                    FocusScope.of(context).requestFocus(nodebt);
                                  },
                                  /*(text) {
                                    add(control1, control2);
                                    Navigator.of(context)
                                        .pop(); // Redraw the Stateful Widget
                                  },*/
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                  'bt1:',
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
                                  focusNode: nodebt,
                                  textAlign: TextAlign.center,
                                  showCursor: true,
                                  controller: control2,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (control2) {
                                    FocusScope.of(context)
                                        .requestFocus(nodebt2);
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
                                  'bt2:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextField(
                                  textAlign: TextAlign.center,
                                  focusNode: nodebt2,
                                  cursorWidth: 3,
                                  cursorColor: Color(0XFFF36735),
                                  showCursor: true,
                                  controller: control4,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (text) {
                                    add(control1, control2, control3, control4);
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
                                control3.clear();
                                control4.clear();
                                Navigator.of(context).pop();
                              }),
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Submit"),
                              onPressed: () {
                                add(control1, control2, control3, control4);
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
        title: Text('FCFS IO'),
        backgroundColor: Color(0xff22456d),
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
      floatingActionButton: FabCircularMenu(
        ringDiameter: 500,
        ringWidth: 100,
        ringColor: Color(0xFFc3ebef),
        fabColor: Color(0xffc3ebef),
        children: <Widget>[
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.settings_input_component_rounded),
            onPressed: () {
              prs.sort((a, b) => a.pid.compareTo(b.pid));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => fcfsio_page(),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.table_chart_rounded),
            onPressed: () {
              prs.sort((a, b) => a.pid.compareTo(b.pid));
              Navigator.push(
                context,
                MaterialPageRoute(
                    // builder: (context) => TheTable(prs),
                    ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              prs.sort((a, b) => a.pid.compareTo(b.pid));
              Navigator.push(
                context,
                MaterialPageRoute(
                    //
                    ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.add_circle),
            onPressed: () {
              createaddDialog(context, prs);
            },
          ),
        ],
      ),
    );
  }

  Widget buildProcesscard(BuildContext context, int index) {
    TextEditingController econtrol1 = new TextEditingController();
    TextEditingController econtrol2 = new TextEditingController();
    TextEditingController econtrol3 = new TextEditingController();
    TextEditingController econtrol4 = new TextEditingController();

    econtrol1 = TextEditingController(text: prs[index].at.toString());
    econtrol2 = TextEditingController(text: prs[index].bt1.toString());
    econtrol3 = TextEditingController(text: prs[index].iobt.toString());
    econtrol4 = TextEditingController(text: prs[index].bt2.toString());

    int at = prs[index].at;
    int bt = prs[index].bt1;
    int bt2 = prs[index].bt2;
    int iobt = prs[index].iobt;
    int tat = prs[index].tat;
    int start = prs[index].start_time;
    int end = prs[index].ct;
    int wt = prs[index].wt;

    void deleteprs(int index) {
      setState(() {
        if (prs.length > 0) {
          prs.removeAt(index);
          prs.sort((a, b) => a.at.compareTo(b.at));
          prs = fcfsioalgo(prs);
        }
      });
    }

    void editprs(
        int index,
        TextEditingController econtrol1,
        TextEditingController econtrol2,
        TextEditingController econtrol3,
        TextEditingController econtrol4) {
      setState(() {
        prs[index].at = int.parse(econtrol1.text);
        prs[index].bt1 = int.parse(econtrol2.text);
        prs[index].iobt = int.parse(econtrol3.text);
        prs[index].bt2 = int.parse(econtrol4.text);
        prs.sort((a, b) => a.at.compareTo(b.at));
        prs = fcfsioalgo(prs);
        //prs.sort((a, b) => a.pid.compareTo(b.pid));
      });
    }

    editDialog(BuildContext context, List<ioprocess> prs, int index) {
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
                                          .requestFocus(nodeiobt);
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
                                    'iobt:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextField(
                                    textAlign: TextAlign.center,
                                    focusNode: nodeiobt,
                                    cursorWidth: 3,
                                    cursorColor: Colors.amber,
                                    showCursor: true,
                                    controller: econtrol3,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      FocusScope.of(context)
                                          .requestFocus(nodebt);
                                    },
                                    /*(text) {
                                      editprs(index, econtrol1, econtrol2);
                                      Navigator.of(context)
                                          .pop(); // Redraw the Stateful Widget
                                    },*/
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                    'bt1:',
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
                                    controller: econtrol2,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      FocusScope.of(context)
                                          .requestFocus(nodebt2);
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
                                    'bt2:',
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
                                    controller: econtrol4,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      editprs(index, econtrol1, econtrol2,
                                          econtrol3, econtrol4);
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
                                  editprs(index, econtrol1, econtrol2,
                                      econtrol3, econtrol4);
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
              "at: $at\t bt1: $bt\t bt2: $bt2\t iobt: $iobt",
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
                //prs.removeAt(index);
                deleteprs(index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
