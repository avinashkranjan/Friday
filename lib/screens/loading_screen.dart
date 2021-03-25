import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _animationLeft;
  Animation<Color> _animationRight;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _animationLeft =
        ColorTween(begin: Colors.grey[700], end: Colors.grey.shade100)
            .animate(_controller);

    _animationRight =
        ColorTween(begin: Colors.grey.shade100, end: Colors.grey[700])
            .animate(_controller);

    _controller.forward();

    _controller.addListener(listener);
  }

  void listener() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
    this.setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            colors: [_animationLeft.value, _animationRight.value],
          ).createShader(rect);
        },
        
        child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Spacing
            SizedBox(
              height: 0.1 * MediaQuery.of(context).size.height,
            ),
            // Header
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding:
                    EdgeInsets.all(20), //.fromLTRB(30.0, 50.0, 30.0, 30.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey[700],
                      radius: 30,
                    ),
                    Container(
                      height: 20,
                      width: 0.5 * MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[700],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[700],
                      radius: 25,
                    ),
                  ],
                ),
              ),
            ),
            //Search Bar
            Container(
              height: 0.05 * MediaQuery.of(context).size.height,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.grey[700],
              ),
            ),

            SizedBox(
              height: 30,
            ),
            // Body
            Container(
              // height: 0.05 * MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(35.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: List.generate(
                  3,
                  (index) {
                    return Container(
                      height: 0.1 * MediaQuery.of(context).size.height,
                      width: double.maxFinite,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
        ),
      bottomNavigationBar: Container(
        // height: 100, //0.1 * MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: List.generate(
            5,
            (index) => CircleAvatar(
              backgroundColor: Colors.grey[700],
              radius: 20,
            ),
          ),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
