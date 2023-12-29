import 'package:flutter/material.dart';
import 'package:mb_demo/app/components/Login/login_class.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final String assetsGoogle = 'assets/images/google.svg';
  final String assetsFacebook = 'assets/images/facebook.svg';

  final ipController = TextEditingController();
  final devportController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();
  bool hintPass = true;

  List<String> listProtocol = <String>['PRIVATE', 'ONVIF'];

  List<String> listTypeDevice = <String>[
    'IPC',
    'IPC FISHEYE',
    'IPC ECONOMIC FISHEYE',
    'NVR',
    'NVR BACKUP',
    'HNVR',
    'DC',
    'DC ADU',
    'EC',
    'VMS',
    'FG'
  ];

  //  ip: "189.111.251.195",
  //     port: 10110,
  //     userName: "admin",
  //     password: "admin123@"

  @override
  Widget build(BuildContext context) {
    //var of library for translation

    var widthScreen = MediaQuery.of(context).size.width;
    var widthAvailable = widthScreen - 135;

    String? deviceSelected;
    String? protocolSelected;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login Uniview",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 80, left: 20, right: 20, bottom: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        key: const Key("ipField"),
                        height: 60,
                        width: widthAvailable,
                        child: TextFormField(
                          controller: ipController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                            hintText: "IP",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required("Number id required"),
                              Validatorless.min(
                                  4, "Ip must be at least 4 characters"),
                              Validatorless.max(
                                  15, "Ip must be most 15 characters")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        height: 60,
                        width: 90,
                        child: TextFormField(
                          controller: devportController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                            hintText: "Port",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required("Number port is required"),
                              Validatorless.min(2,
                                  "number port must be at least 2 characters"),
                              Validatorless.max(
                                  6, "number port must be most 6 characters")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: userController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: "Username",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required("Username is required"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: passController,
                      style: const TextStyle(fontSize: 20),
                      obscureText: hintPass,
                      decoration: InputDecoration(
                        hintText: "Password",
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.only(left: 10),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hintPass = !hintPass;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye),
                        ),
                      ),
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required("Password is required"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonFormField(
                            key: const Key('protocolDropdown'),
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                            ),
                            isExpanded: true,
                            value: protocolSelected,
                            hint: Text("Protocol"),
                            padding: const EdgeInsets.only(left: 10),
                            focusColor: Colors.transparent,
                            items: listProtocol
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              setState(
                                () {
                                  protocolSelected = value!;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonFormField(
                            key: const Key('typeDevicesDropdown'),
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                            ),
                            isExpanded: true,
                            value: deviceSelected,
                            hint: Text("DeviceType"),
                            padding: const EdgeInsets.only(left: 10),
                            items: listTypeDevice
                                .map(
                                  (value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                deviceSelected = value!;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.blue[900],
                      heroTag: 'login',
                      onPressed: () async {
                        await Login.tryLogin(
                            formKey,
                            context,
                            ipController,
                            devportController,
                            userController,
                            passController,
                            protocolSelected,
                            deviceSelected);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () async {
                        // Login.tryLogout(context);
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginError extends Error {
  String message;

  LoginError(this.message);
}
