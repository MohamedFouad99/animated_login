// ignore_for_file: prefer_const_constructors

import 'package:animated_login/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtBoaed;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = "fouad@gmail.com";
  String testPassword = "1234567";
  final passwordFocusNode = FocusNode();
  bool isLookingRight = false;
  bool isLookingLeft = false;
  void removeAllControllers() {
    riveArtBoaed?.artboard.removeController(controllerIdle);
    riveArtBoaed?.artboard.removeController(controllerHandsUp);
    riveArtBoaed?.artboard.removeController(controllerHandsDown);
    riveArtBoaed?.artboard.removeController(controllerLookLeft);
    riveArtBoaed?.artboard.removeController(controllerLookRight);
    riveArtBoaed?.artboard.removeController(controllerSuccess);
    riveArtBoaed?.artboard.removeController(controllerFail);
    isLookingRight = false;
    isLookingLeft = false;
  }

  void addIdelController() {
    removeAllControllers();
    riveArtBoaed?.artboard.addController(controllerIdle);
    debugPrint("idle");
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtBoaed?.artboard.addController(controllerHandsUp);
    debugPrint("handUp");
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtBoaed?.artboard.addController(controllerHandsDown);
    debugPrint("handsDown");
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtBoaed?.artboard.addController(controllerLookLeft);
    debugPrint("lookLeft");
  }

  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtBoaed?.artboard.addController(controllerLookRight);
    debugPrint("lookRight");
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtBoaed?.artboard.addController(controllerSuccess);
    debugPrint("success");
  }

  void addFaillController() {
    removeAllControllers();
    riveArtBoaed?.artboard.addController(controllerFail);
    debugPrint("fail");
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  void validateEmailAndPassword() {
    Future.delayed(Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFaillController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    rootBundle.load('assets/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final artBoard = file.mainArtboard;
      artBoard.addController(controllerIdle);
      setState(() {
        riveArtBoaed = artBoard;
      });
    });
    checkForPasswordFocusNodeToChangeAnimationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Animation Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20),
          child: Column(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtBoaed == null
                    ? SizedBox.shrink()
                    : Rive(artboard: riveArtBoaed!)),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) =>
                          value != testEmail ? "Wrong Email" : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 16 &&
                            !isLookingLeft) {
                          addLookLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 16 &&
                            !isLookingRight) {
                          addLookRightController();
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) =>
                          value != testPassword ? "Wrong Password" : null,
                      focusNode: passwordFocusNode,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          validateEmailAndPassword();
                          passwordFocusNode.unfocus();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
