import Flutter
import UIKit

public class SdkCameraIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sdk_camera_ios", binaryMessenger: registrar.messenger())
    let instance = SdkCameraIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "login":
        executeLogin(call, result:result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

private func executeLogin(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let initRet  = NETDEV_Init()
        
    if (initRet != true){
        result("Login Failure")
    }
    
        print("Recebido do Dart: \(call.arguments ?? "")")
        guard let myArgs = call.arguments as? [String: Any],
              let userName = myArgs["userName"] as? String,
              let password = myArgs["password"] as? String,
              let port = myArgs["port"] as? String,
              let ip = myArgs["ip"] as? String else {
            result(NSDictionary(dictionary: ["status": 1, "value": "Invalid arguments for login"]))
            return
        }
    var stDevLoginInfo = NETDEV_DEVICE_LOGIN_INFO_S()
            strncpy(&stDevLoginInfo.szIPAddr, ip, MemoryLayout.size(ofValue: stDevLoginInfo.szIPAddr))
            stDevLoginInfo.dwPort = INT32(port)!
            strncpy(&stDevLoginInfo.szUserName, userName, MemoryLayout.size(ofValue: stDevLoginInfo.szUserName))
            strncpy(&stDevLoginInfo.szPassword, password, MemoryLayout.size(ofValue: stDevLoginInfo.szPassword))
    
    var stSELogInfo = NETDEV_SELOG_INFO_S()
    
    let lpUserID = NETDEV_Login_V30(&stDevLoginInfo, &stSELogInfo)
    
    
    if lpUserID == nil {
                result( "NETDEV_Login_V30 failure:error:\(NETDEV_GetLastError())")
            }
        print("success")
        result("success")
    }














