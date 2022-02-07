import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:frest/const/secrets.dart';
import 'package:frest/core/api/auth.dart';
import 'package:frest/models/token_model.dart';
import 'package:frest/views/home.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

// class LoginViewModel extends ChangeNotifier {
//   bool isLoading = false;

//   Secret? secretKeys;

//   void intercept(
//     BuildContext context,
//     String url, {
//     bool mounted = true,
//     FlutterWebviewPlugin? wv,
//     bool isTest = false,
//   }) async {
//     try {
//       if (mounted) {
//         if (url.toLowerCase().contains('?cancelled=true')) {
//         } else if (url.toLowerCase().contains('callback?code')) {
//           isLoading = true;
//           secretKeys?.code =
//               url.replaceAll('https://flutterapp.com/callback?code=', '');
//           if (!isTest) wv?.close();
//           handleRequest(context);
//         }
//         isLoading = false;
//       }
//     } catch (e) {
//       isLoading = false;
//       print(e.toString());
//     }
//   }

//   void handleRequest(context) async {
//     TokenModel? authorizeREQ = await Auth.authorize(
//       context,
//       secret: secretKeys!,
//     );

//     if (authorizeREQ != null) {
//       isLoading = false;
//       print('authorized');
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(authorizeREQ),
//           fullscreenDialog: true,
//         ),
//       );
//     } else {
//       throw "Authorization Failed";
//     }
//   }

//   void loadKeys() async {
//     secretKeys = await SecretLoader(secretPath: 'assets/secrets.json').load();
//     notifyListeners();
//     print(secretKeys?.toJson());
//   }
// }

// class SecretKeyso {
//   SecretKeyso();
//   static bool isLoading = false;
//   static Secret? secretKeys;
// }

class LoadKeys extends StateNotifier {
  LoadKeys({LoadKeys? state}) : super(state);

  bool isLoading = false;
  Secret? secretKeys;

  void intercept(
    BuildContext context,
    String url, {
    bool mounted = true,
    FlutterWebviewPlugin? wv,
    bool isTest = false,
  }) async {
    try {
      if (mounted) {
        if (url.toLowerCase().contains('?cancelled=true')) {
        } else if (url.toLowerCase().contains('callback?code')) {
          isLoading = true;
          secretKeys?.code =
              url.replaceAll('https://flutterapp.com/callback?code=', '');
          if (!isTest) wv?.close();
          handleRequest(context);
        }
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void handleRequest(context) async {
    TokenModel? authorizeREQ = await Auth.authorize(
      context,
      secret: secretKeys!,
    );

    if (authorizeREQ != null) {
      isLoading = false;
      if (kDebugMode) {
        print('authorized');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(tokenModel: authorizeREQ),
          fullscreenDialog: true,
        ),
      );
    } else {
      throw "Authorization Failed";
    }
  }

  void loadKeys() async {
    secretKeys = await SecretLoader(secretPath: 'assets/secrets.json').load();
    // notifyListeners();
    if (kDebugMode) {
      print(secretKeys?.toJson());
    }
  }
}
