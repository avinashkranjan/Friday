import 'package:flutter/material.dart';
import 'package:friday/screens/home_screen.dart';
import 'package:friday/screens/login_page.dart';
import 'package:friday/screens/onboarding_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: IntroductionScreen(
      skip: Text('SKIP', style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 18),),
      next: Text('NEXT', style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 18),),
      globalBackgroundColor: Colors.black,
      isProgressTap: true,
      isProgress: true,
      pages: [
        PageViewModel(
          title: 'Make Your Assignments and Quizzes Unforgettable',
              body: 'Keep track of all of your tests/submissions in a single go.',
          image: Center(child:Image.asset("assets/images/slider1.png",width: 350,),),
          decoration: getDecoration()

        ),
        PageViewModel(
          title: 'Outperform your competition!',
          body: 'Track your work progress, get timely alerts about your submissions, and much more.',
          image: Center(child:Image.asset("assets/images/slider2.png",width: 350,),),
            decoration: getDecoration()
        ),
        PageViewModel(
            title: 'Be Ahead of Time',
            body: 'Be organized in class or workspace, and never miss an important deadline.',
            image: Center(child:Image.asset("assets/images/slider3.png",width: 350,),),
            decoration: getDecoration()
        ),
        PageViewModel(
            title: 'Your Personal Class Assistant',
            body: 'Start Using Friday Now!',
            footer: SizedBox(width: MediaQuery.of(context).size.width ,child:Center(child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 10, backgroundColor: Colors.deepPurple)
            ,onPressed: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showslider', false);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnboardingPage())); },
            child: Text('PPROCEED TO SIGNUP/LOGIN', style: TextStyle(fontWeight: FontWeight.bold),),

            ),),),
            image: Center(child:Image.asset("assets/icons/icon.png",width: 350,),),
            decoration: getDecoration(),

        ),

      ],
      showNextButton: true,
      showSkipButton: true,
      showDoneButton: false,
      freeze: false,
      onDone: () => gotoHome(),
      dotsDecorator: DotsDecorator(

        size: const Size.square(10.0),

        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.deepPurple,
        color: Colors.deepPurple,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
        ),
      ),


    ));
  }

  getDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white ),
    bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
    bodyPadding: EdgeInsets.all(10),
    imagePadding: EdgeInsets.all(20),

    titlePadding: EdgeInsets.all(10),
    pageColor: Colors.black
  );

  gotoHome() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
}

    
    