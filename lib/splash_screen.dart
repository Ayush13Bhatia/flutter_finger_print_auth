import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'finger_print_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  String fingerPrintFlag = 'fingerPrint';
  bool didAuthenticate = false;
  final LocalAuthentication auth = LocalAuthentication();

  /// Function for Authentication
  /// Will appear during initialing the screen
  void flashFxn() async {
    didAuthenticate = await auth.authenticate(
      localizedReason: 'Authenticate with fingerprint',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (context.mounted && didAuthenticate) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const FingerPrintWidget(),
        ),
      );

      return;
    }

    /// App Life during resume phase
    AppLifecycleState.resumed;
    await SystemNavigator.pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    flashFxn();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Flutter app life cycle that resume that app when minimize for finger print verification
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    /// Resume the authenticate funcation
    if (state == AppLifecycleState.resumed) {
      flashFxn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint,
            ),
            Text(
              "Finger print",
            )
          ],
        ),
      ),
    );
  }
}
