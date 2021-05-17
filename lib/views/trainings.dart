import 'package:flutter/material.dart';

class Trainings extends StatefulWidget {

  @override
  _TrainingsState createState() => _TrainingsState();
}


class _TrainingsState extends State<Trainings> {
  

  double
    _height = 500.0,
    _top = 0.0,
    _maxHeight = 200.0,
    _maxCollapseHeight = 50.0;
  int _timeToAutoCollapseExpandMilliseconds = 100;

// @override
// void dispose() {
//   super.dispose();
//   print('dispose');
// }

@override
void deactivate() {
  _top = 0;
}

  @override
  Widget build(BuildContext context) {
    // return Center(child: Text('Progress'));
    // return Container(
    //   child: Align(
    //     alignment: Alignment.bottomRight,
    //     child: Container(
    //       margin: EdgeInsets.all(15.0),
    //       child: RaisedButton(
    //         shape: CircleBorder(side: BorderSide(color: Colors.black87)),
    //         color: Colors.white,
    //         child: Icon(Icons.add, color: Colors.black87, size: 60),
    //         onPressed: () {},
    //       ),
    //     )
    //   )
    // );


      return Container(
        padding: const EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          // color: Colors.orange,
        ),
        child: Column(
          children: [
            Container(
              width: 400.0,
              height: 30.0,
              // color: Colors.grey,
              child: Center(child: Text('Add exercise', style: TextStyle(fontSize: 18))),
              decoration: BoxDecoration(
                color: Colors.lime,
                // borderRadius: BorderRadius.circular(10),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              )
            ),






            SizedBox(
        height: _height,
        child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  // bottom: 51,
                  child: Container(
                    width: 400.0,
                    height: _top,
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Some content'),
                          Text('Some content'),
                          Text('Some content'),
                          Text('Some content'),
                          Text('Some content'),
                          Text('Some content'),
                          Text('Some content'),
                          Text('Some content'),
                        ]
                      )
                    ),
                  ),
                ),
                Positioned(
                  top: _top,
                  // height: _height,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: CustomPaint(
                      size: Size(400, 51),
                      child: ClipPath(
                        child: Container(
                          width: 400.0,
                          height: 51.0,
                          color: Colors.lightGreen,
                          child: Center(
                            child: Text(
                              'Pull',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                        ),
                        clipper: CustomClipPath(),
                      )
                    ),
                    onTap: () {
                      print('Clicked');
                    },
                    onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                      setState(() {
                        if((_top + dragUpdateDetails.delta.dy) < 0) {
                          _top = 0;
                        } else if((_top + dragUpdateDetails.delta.dy) > _maxHeight) {
                          _top = _maxHeight;
                        } else {
                          _top += dragUpdateDetails.delta.dy;
                        }
                      });
                    },
                    onPanEnd: (DragEndDetails dragEndDetails) async{
                      if(_top <= _maxCollapseHeight && _top != 0) { // if we expanded less then 50 pixels, collapse it at all
                        int _delayMilliseconds = (_timeToAutoCollapseExpandMilliseconds / _top.round()).round();
                        // print(_delayMilliseconds);
                        for(int i = _top.round(); i >= 0; i--) {
                          await Future.delayed(Duration(milliseconds: _delayMilliseconds), () => {});
                          setState(() {
                            _top = i.toDouble();
                          });
                        }
                      } else if(_top > _maxCollapseHeight && _top != _maxHeight) { // if we expanded more then 50 pixels, expand it at all
                        int _delayMilliseconds = (_timeToAutoCollapseExpandMilliseconds / (_maxHeight - _top).round()).round();
                        // print(_delayMilliseconds);
                        for(int i = (_maxHeight - (_maxHeight - _top)).round(); i <= _maxHeight; i++) {
                          // if(i % 3 == 0) is neede here because if we have e.g. 184 pixels to go, we can get
                          // the smallest int of millisecond - 1, so it will be expanded for 184 milliseconds, which is long
                          // therefore we just get each third pixels and we'll get x3 speed of expanding
                          if(i % 3 == 0) {
                            await Future.delayed(Duration(milliseconds: _delayMilliseconds), () => {});
                            setState(() {
                              _top = i.toDouble();
                            });
                          }

                        }
                      }
                    }
                  )
                )
              ],
              overflow: Overflow.visible,
            )
            )










          ]
        )
      );

  }
}
class CustomClipPath extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, 150);
    // path.cubicTo(150, 150, 100, 200, 200, 200);
    // path.cubicTo(300, 200, 250, 150, 400, 150);
    // path.lineTo(400, 0);

    path.lineTo(0, 1);
    path.cubicTo(150, 1, 100, 51, 200, 51);
    path.cubicTo(300, 51, 250, 1, 400, 1);
    path.lineTo(400, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  
}