import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var email = TextEditingController();
  var pass = TextEditingController();

  var animationLink = 'assets/animated_login_character.riv';
  late SMITrigger trigFail, trigSuccess; //State machine input
  late SMIBool isChecking, isHandsUp;
  Artboard? artboard;
  bool checkBox = false;
  late StateMachineController? stateMachineController;
  late SMINumber lookNum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initArtboard(); //start animation process
  }

  initArtboard() {
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController = StateMachineController.fromArtboard(art, "Login Machine")!;
      if(stateMachineController!=null){
        art.addController(stateMachineController!);
        for(var element in stateMachineController!.inputs){
          if(element.name == "isChecking"){
            isChecking = element as SMIBool;
          }
          else if(element.name == "isHandsUp"){
            isHandsUp= element as SMIBool;
          }
          else if(element.name == "trigSuccess"){
            trigSuccess = element as SMITrigger;
          }
          else if(element.name == "trigFail"){
            trigFail = element as SMITrigger;
          }
          else if(element.name == "lookNum"){
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() {
        artboard=art;
      });
    });
  }

  checking(){
    isHandsUp.change(false);
    isChecking.change(true);
    lookNum.change(0);
  }

  moveEyes(value){
    lookNum.change(value.length.toDouble());
  }

  login(){
    isHandsUp.change(false);
    isChecking.change(true);
    if(email.text=='admin' && pass.text=='admin'){
      trigSuccess.fire();

    }else{
      trigFail.fire();
    }
  }

  handsUp(){
    isHandsUp.change(true);
    isChecking.change(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffd6e2ea),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (artboard != null)
                  SizedBox(
                    width: 400,
                    height: 350,
                    child: Rive(
                      artboard: artboard!,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 400,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.black.withOpacity(0.4))),
                        child: TextFormField(
                          onTap: checking,
                          onChanged: (value) => moveEyes(value),
                          controller: email,
                          decoration: InputDecoration(
                              label: Text(
                                'Email/Username',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.black.withOpacity(0.4))),
                        child: TextFormField(
                          controller: pass,
                          onTap: handsUp,
                          decoration: InputDecoration(
                              label: Text(
                                'Password',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: checkBox,
                            onChanged: (value) {
                              setState(() {
                                checkBox = !checkBox;
                              });
                            },
                          ),
                          const Text('Remember me'),
                          const SizedBox(
                            width: 80,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                backgroundColor: Colors.deepOrange,
                              ),
                              onPressed: login,
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
