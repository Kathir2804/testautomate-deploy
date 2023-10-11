import 'package:cez_tower/common_widget/common_widget.dart';
import 'package:cez_tower/pages/pages.dart';
import 'package:cez_tower/provider/sales_provider.dart';
import 'package:cez_tower/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../splash_page/splash_page_components/logo_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isClicked = false;
  bool isChecked = false;
  bool isEmailVerified = false;
  bool buttonEnable = false;
  bool emailValid = true;
  bool passwordValid = true;
  bool emailStyle = false;
  bool passwordStyle = false;
  bool filled = false;
  bool isLogged = false;
  bool rememberMe = false;
  List<String> id = [];
  final Box<dynamic> salesId = Hive.box("salesIdList");

  final storage = const FlutterSecureStorage();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode submitButtonFocus = FocusNode();
  final FocusNode emailFieldFocus = FocusNode();
  final FocusNode passwordVisibilityButtonFocus = FocusNode();

  bool isKeyboardOpen = false;
  void focuseNode() {
    passwordFocus.addListener(() {
      setState(() {
        isKeyboardOpen = passwordFocus.hasFocus;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    focuseNode();
    remember();
  }

  Future<void> remember() async {
    await storage.read(key: 'rememberMe').then((value) {
      if (value != null) {
        rememberMe = value.toLowerCase() == 'true';
      } else {
        rememberMe = false;
      }
    });
    if (rememberMe) {
      storage.read(key: 'email').then((value) {
        if (value != null) {
          email.text = value;
        }
      });
      storage.read(key: 'password').then((value) {
        if (value != null) {
          password.text = value;
        }
      });
    }
  }

  Future<void> invalidMessage() async {
    UpadteMessage().errorMessage(context, true, "Invalid Email or Password");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(237, 245, 255, 1),
        body: Stack(
          children: [
            Positioned(
              top: 300,
              bottom: 0,
              right: 0,
              child: Image.asset('assets/login1.png'),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('assets/login2.png'),
            ),
            const LogoWidget(),
            Positioned(
              top: isKeyboardOpen
                  ? MediaQuery.of(context).size.height / 12
                  : 100,
              right: 300,
              left: 300,
              child: Material(
                elevation: 8,
                shadowColor: const Color.fromARGB(50, 178, 178, 178),
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 35, 20, 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/cargoez_with_trademark.svg"),
                        const SizedBox(height: 15),
                        const Center(
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                          ),
                        ),
                        const SizedBox(height: 15),
                        EmailTextFieldWidget(
                          focusNode: emailFieldFocus,
                          companyIdController: email,
                          form: formKey1,
                          validate: (value) {
                            emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);
                            if (value.isEmpty || emailValid == false) {
                              setState(() {
                                isClicked = false;
                              });
                              return "";
                            }
                            return null;
                          },
                          emailStyle: emailStyle,
                          emailValid: emailValid,
                          userIcon: false,
                          filled: filled,
                          onChanged: (value) {
                            if (password.text.isNotEmpty && value.isNotEmpty) {
                              setState(() {
                                filled = false;
                              });
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              emailStyle = true;
                              passwordStyle = false;
                            });
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                        ),
                        const SizedBox(height: 15),
                        PasswordTextFieldWidget(
                            formKey: formKey2,
                            eyeFocus: passwordVisibilityButtonFocus,
                            focusNode: passwordFocus,
                            passwordValid: passwordValid,
                            passwordController: password,
                            passwordStyle: passwordStyle,
                            filled: filled,
                            validate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                passwordValid = false;
                                return '';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              if (email.text.isNotEmpty && value.isNotEmpty) {
                                setState(() {
                                  filled = false;
                                });
                              }
                            },
                            onFieldSubmitted: (value) {
                              setState(() {
                                emailStyle = false;
                                passwordStyle = true;
                              });
                              submitButtonFocus.nextFocus();
                            },
                            keyIcon: false),
                        const SizedBox(height: 5),
                        Row(children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (newValue) {
                              setState(() {
                                rememberMe = newValue!;
                              });
                            },
                          ),
                          const Text("Remember me"),
                        ]),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: submitButtonFocus.hasFocus
                                      ? Colors.black
                                      : Colors.amber),
                              focusNode: submitButtonFocus,
                              onPressed: () {
                                setState(() {
                                  emailStyle = false;
                                  passwordStyle = false;
                                  passwordValid = true;
                                  onsubmit();
                                });
                              },
                              child: isClicked &&
                                      isLogged == false &&
                                      formKey1.currentState!.validate() &&
                                      formKey1.currentState!.validate()
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ))
                                  : const Text("Login")),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onsubmit() async {
    final provider = Provider.of<SalesProvider>(context, listen: false);
    final auth = FirebaseAuth.instance;

    setState(() {
      isClicked = true;
    });
    if (formKey1.currentState!.validate() & formKey2.currentState!.validate()) {
      try {
        await auth.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        auth.authStateChanges().listen((event) async {
          if (event == null) {
            print('User is currently signed out!');
          } else {
            try {
              String? token = await event.getIdToken();
              isLogged = await GetLoginService().getLoginDetails(token!);
              print(isLogged);
              if (isLogged == true) {
                if (!mounted) return;
                await Provider.of<SalesProvider>(context, listen: false)
                    .userData();
                for (int i = 0; i < provider.userDataList.length; i++) {
                  id.add(provider.userDataList[i].id);
                }
                List<String> savedUser = salesId.get('userId') ?? [];
                List<String> commonIds = savedUser.isNotEmpty
                    ? id.where((id) => savedUser.contains(id)).toList()
                    : id;
                provider.blockUser(commonIds);
                salesId.put("userId", commonIds);
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Dashboard(),
                  ),
                );
                if (rememberMe) {
                  storage.write(key: 'email', value: email.text);
                  storage.write(key: 'password', value: password.text);
                }
                storage.write(key: 'rememberMe', value: rememberMe.toString());
                await UpadteMessage().navigateAndDisplaySelection(
                    context, true, "Login Successfully");
              } else if (isLogged == false) {
                isChecked = true;
                invalidMessage();
                // shakeKey.currentState?.shake();
                setState(() {
                  filled = true;
                });
              }
            } catch (e) {
              isChecked = true;
              invalidMessage();
              // shakeKey.currentState?.shake();
              setState(() {
                isClicked = false;
                filled = true;
              });
              print('$e');
            }
          }
        });
      } catch (e) {
        if (e is FirebaseException) {
          if (e.code == 'network-request-failed') {
            isChecked = true;
            setState(() {
              isClicked = false;
            });
            const snackBar = SnackBar(
                content: Text(
                  'No Network connection',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Color.fromARGB(255, 239, 68, 68));
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (e.code == 'user-not-found') {
            print('No user found for that email.');
            invalidMessage();
            // shakeKey.currentState?.shake();
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
            invalidMessage();
            // shakeKey.currentState?.shake();
          }
        } else if (e is PlatformException) {
          isChecked = true;
          // invalidMessage();
          // shakeKey.currentState?.shake();
          setState(() {
            isClicked = false;
          });
        }
        isChecked = true;
        setState(() {
          isClicked = false;
          filled = true;
        });
        print('$e');
      }
    }
  }
}
