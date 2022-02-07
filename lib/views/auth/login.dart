import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:frest/utils/margin.dart';
import 'package:frest/utils/theme.dart';
import 'package:frest/view_models/login_vm.dart';
import 'package:frest/widgets/dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';

class Login extends StatefulHookConsumerWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final providerMain = StateNotifierProvider((ref) => LoadKeys());

  final wv = FlutterWebviewPlugin();

  StreamSubscription<String>? _onUrlChanged;

  @override
  void dispose() {
    //  _onDestroy.cancel();
    _onUrlChanged?.cancel();
    // _onStateChanged.cancel();
    wv.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.read(providerMain.notifier).loadKeys();
    wv.close();
    // Add a listener to on url changed
    _onUrlChanged = wv.onUrlChanged.listen((String url) async {
      if (kDebugMode) {
        print(url);
      }

      ref.watch(providerMain.notifier).intercept(
            context,
            url,
            mounted: mounted,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(providerMain.notifier);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
        ),
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              LineIcons.alternateGithub,
              color: white,
              size: 44,
            ),
            const YMargin(y: 10),
            Text('Sign in with Github',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: white,
                    height: 1.5,
                    fontSize: 23,
                  ),
                )),
            const YMargin(y: 10),
            Text(
                'A demo project to show a simle implementation of Github OAuth',
                style: GoogleFonts.sourceCodePro(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: white.withOpacity(.4),
                    height: 1.5,
                    fontSize: 12,
                  ),
                )),
            const Spacer(),
            Center(
                child: Image.asset(
              'assets/images/login.png',
              height: 200,
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton.icon(
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white;
                  }
                  return primary;
                })),
                // color: primary,
                icon: const Icon(
                  LineIcons.github,
                  color: white,
                ),
                label: const Text('Sign in with Github'),
                onPressed: () async {
                  if (provider.secretKeys?.clientId != null) {
                    await customDialog(context,
                        clientId: provider.secretKeys!.clientId!);
                  }
                },
              ),
            ),
            YMargin(y: context.screenHeight(0.02))
          ],
        ),
      ),
    );
  }
}
