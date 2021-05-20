import 'package:flutter/material.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;

GlobalKey _key = GlobalKey();

class AddExerciseInsideAlertDialog extends StatefulWidget {

  final String title;
  final dynamic content;

  const AddExerciseInsideAlertDialog({Key key, this.title, this.content}): super(key: key);

  @override
  _AddExerciseInsideAlertDialogState createState() => _AddExerciseInsideAlertDialogState();
}


class _AddExerciseInsideAlertDialogState extends State<AddExerciseInsideAlertDialog> {
  

  double
    _widthOfContainerForContent = WidgetsBinding.instance.window.physicalSize.width, // screen's width
    _staticHeight = 51.0,
    _dynamicHeight = 51.0,
    _titleHeight = 30.0,
    _top = 0.0,
    _maxHeight = 150.0,
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

  void afterBuild(BuildContext context) {
      RenderBox renderedWidget = _key.currentContext.findRenderObject();
      double widgetsWidth = renderedWidget.size.width;
      if(widgetsWidth != _widthOfContainerForContent) setState(() {
        _widthOfContainerForContent = widgetsWidth;
      });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
    
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

// print(_dynamicHeight);
      return Container(
        height: _dynamicHeight + _titleHeight,
        // color: Colors.green,
        child: Column(
          children: [
            Container(
              key: _key,
              width: double.infinity,
              height: _titleHeight,
              // color: Colors.grey,
              child: Center(child: Text(widget.title, style: TextStyle(fontSize: 18))),
              decoration: BoxDecoration(
                color: Colors.lime,
                // borderRadius: BorderRadius.circular(10),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              )
            ),
            SizedBox(
              height: _dynamicHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    // bottom: 51,
                    child: Container(
                      width: double.infinity,
                      height: _top,
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.GHOST_WHITE),
                        border: Border(
                          left: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                          right: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        )
                      ),
                      // color: Color(ColorConstants.GHOST_WHITE),
                      child: SingleChildScrollView(
                        child: widget.content
                      ),
                    ),
                  ),
                  Positioned(
                    top: _top,
                    // height: _height,
                    child: GestureDetector(
                      // behavior: HitTestBehavior.translucent,
                      // behavior: HitTestBehavior.opaque,
                      child: CustomPaint(
                        // size: Size(400, 51),
                        child: ClipPath(
                          child: Container(
                            width: _widthOfContainerForContent,
                            // We can just use width: MediaQuery.of(context).size.width - 65
                            // but it is a hardocded workaround, so we use afterBuild() method
                            // in this case we have not a good situation - calling twice build() method
                            // but we solve for sure hardcoded magic number 65 (MediaQuery.of(context).size.width - 65)
                            // Maybe we can use it, but for now let it be with afterBuild() method to be sure
                            // it will be Ok on all devices with different screens and paddings/margins
                            // width: MediaQuery.of(context).size.width - 65,
                            height: 51.0,
                            color: Colors.lightGreen,
                            child: Center(
                              child: Icon(
                                _top == 0 ? Icons.expand_more : Icons.expand_less,
                                // size: 40.0,
                                color: Colors.black54)
                            ),
                          ),
                          clipper: CustomClipPath(),
                        )
                      ),
                      onTap: () async{
                        print('Tapped');
                        if(_top == 0) { // expand it at all on click
                          int _delayMilliseconds = 1;
                          for(int i = 0; i <= _maxHeight; i++) {
                            // if(i % 3 == 0) is neede here because if we have the height of e.g. 400 pixels to go, we can get
                            // the smallest int of millisecond - 1, so it will be expanded for 400 milliseconds, which is long
                            // therefore we just get each third pixels and we'll get x3 speed of expanding
                            if(i % 3 == 0 || i == _maxHeight) {
                              await Future.delayed(Duration(milliseconds: _delayMilliseconds), () => {});
                              setState(() {
                                _top = i.toDouble();
                                _dynamicHeight = _staticHeight + _top;
                              });
                            }
                          }
                        } else if(_top == _maxHeight) {
                          int _delayMilliseconds = 1;
                          for(int i = _maxHeight.toInt(); i >= 0; i--) {
                            // if(i % 3 == 0) is neede here because if we have the height of e.g. 400 pixels to go, we can get
                            // the smallest int of millisecond - 1, so it will be expanded for 400 milliseconds, which is long
                            // therefore we just get each third pixels and we'll get x3 speed of expanding
                            if(i % 3 == 0 || i == 0) {
                              await Future.delayed(Duration(milliseconds: _delayMilliseconds), () => {});
                              setState(() {
                                _top = i.toDouble();
                                _dynamicHeight = _staticHeight +_top;
                              });
                            }
                          }
                        }
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
                          for(int i = _top.round(); i >= 0; i--) {
                            await Future.delayed(Duration(milliseconds: _delayMilliseconds), () => {});
                            setState(() {
                              _top = i.toDouble();
                              _dynamicHeight = _staticHeight + _top;
                            });
                          }
                        } else if(_top > _maxCollapseHeight && _top != _maxHeight) { // if we expanded more then 50 pixels, expand it at all
                          int _delayMilliseconds = (_timeToAutoCollapseExpandMilliseconds / (_maxHeight - _top).round()).round();
                          for(int i = (_maxHeight - (_maxHeight - _top)).round(); i <= _maxHeight; i++) {
                            // if(i % 3 == 0) is neede here because if we have e.g. 184 pixels to go, we can get
                            // the smallest int of millisecond - 1, so it will be expanded for 184 milliseconds, which is long
                            // therefore we just get each third pixels and we'll get x3 speed of expanding
                            if(i % 3 == 0 || i == _maxHeight) {
                              await Future.delayed(Duration(milliseconds: _delayMilliseconds), () => {});
                              setState(() {
                                _top = i.toDouble();
                                _dynamicHeight = _staticHeight + _top;
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
    RenderBox renderedWidget = _key.currentContext.findRenderObject();
    double widgetsWidth = renderedWidget.size.width;
    // var qwe = () {
    //   RenderBox asd = _key.currentContext.findRenderObject();
    //   double zxc = asd.size.width;
    //   return zxc;
    // }();
    // print(qwe);
    double coefficient = 400 / widgetsWidth;

    double leftSideFirstX = 150 / coefficient;
    double leftSideSecondX = 100 / coefficient;
    double leftSideThirdX = 200 / coefficient;

    double rightSideFirstX = 300 / coefficient;
    double rightSideSecondX = 250 / coefficient;
    double rightSideThirdX = 400 / coefficient;

    Path path = Path();
    path.lineTo(0, 1);
    path.cubicTo(leftSideFirstX, 1, leftSideSecondX, 51, leftSideThirdX, 51);
    path.cubicTo(rightSideFirstX, 51, rightSideSecondX, 1, rightSideThirdX, 1);
    path.lineTo(widgetsWidth, 0);
    path.lineTo(0, 0);
    path.close();

    // Path path = Path();
    // path.lineTo(0, 1);
    // path.cubicTo(150, 1, 100, 51, 200, 51);
    // path.cubicTo(300, 51, 250, 1, 400, 1);
    // path.lineTo(400, 0);
    // path.lineTo(0, 0);
    // path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  
}