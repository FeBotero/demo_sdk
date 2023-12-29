import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mb_demo/models/user_model.dart';
import 'package:mb_demo/providers/user_info_provider.dart';
import 'package:sdk_camera/sdk_camera.dart';

class LoginError extends Error {
  String message;

  LoginError(this.message);
}

class Login {
  static tryLogin(formKey, context, ipController, devportController,
      userController, passController, protocolSelected, deviceSelected) {
    if (formKey.currentState!.validate()) {
      goToLogin(
        context,
        ipController.text,
        int.tryParse(devportController.text) != null
            ? int.parse(devportController.text)
            : 0,
        userController.text,
        passController.text,
        protocolSelected,
        deviceSelected,
      );
    } else {
      print('Invalid');
    }
  }

  static tryLogout(context) async {
    try {
      String? response = "";
      //  await CHAMAR METODO;s
      // print("Aqui $ret");
      if (response == "success" || response == "succeed") {
        Fluttertoast.showToast(
            msg: "Sucesso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Future.delayed(
          const Duration(seconds: 1),
        );
      } else {
        throw LoginError(
          response.toString(),
        );
      }
    } catch (e) {
      dialogError(context, e);
    }
  }
}

goToLogin(
  context,
  ip,
  devPort,
  username,
  password,
  protocol,
  device,
) async {
  try {
    SdkCamera().getPlatformVersion();
    Response? response = await SdkCamera().login(
      LoginSettings(
          ip: ip, port: devPort, userName: username, password: password),
    );
    print("AQUI ${response.status}");
    if (response == "succeed") {
      UserInfoProvider.instance()
          .addUser(UserModel(userId: response.value as int, channelId: 0));
      Fluttertoast.showToast(
          msg: "Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Future.delayed(
        const Duration(seconds: 1),
      );
    } else {
      print("AQUI OH $response");
      throw LoginError(
        response.toString(),
      );
    }
  } catch (e) {
    dialogError(context, e);
  }
}

dialogError(context, e) {
  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  " Erro Message:  ${e is LoginError ? e.message : "unknownError"}.",
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
