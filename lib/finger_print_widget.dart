import 'package:finger_print_app/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintWidget extends StatefulWidget {
  const FingerPrintWidget({Key? key}) : super(key: key);

  @override
  State<FingerPrintWidget> createState() => _FingerPrintWidgetState();
}

class _FingerPrintWidgetState extends State<FingerPrintWidget> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> listOfBioMetrics = [];

  bool isAuthenticate = false;

  String fingerPrintFlag = 'fingerPrint';
  bool didAuthenticate = false;
  late bool _authenticated;

  /// Check whether hardware support is available,
  /// Not whether the device has any biometrics enrolled.
  void canBioMetric() async {
    isAuthenticate = await auth.canCheckBiometrics; /*|| await auth.isDeviceSupported();*/
    print('object11 ====> $isAuthenticate');
  }

  /// List of bioMetric in your devices
  Future<List<BiometricType>> listOfBioMetricsFxn() async {
    listOfBioMetrics = await auth.getAvailableBiometrics();
    return listOfBioMetrics;
  }

  /// Authenticate the your biometrics
  /// if your device support
  void authenticateFxn() async {
    didAuthenticate = await auth.authenticate(
      localizedReason: _authenticated ? 'Authenticate' : "Not authenticated",
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (didAuthenticate) {
      setState(() {
        _authenticated = !_authenticated;
      });

      /// Storing the flag (True or False)
      /// Help use to make of authentication
      await SharedPrefUtils.setValue(fingerPrintFlag, _authenticated, isBool: true);
    }
  }

  @override
  void initState() {
    super.initState();

    /// Getting the flag value
    _authenticated = SharedPrefUtils.getValue(fingerPrintFlag, isBool: true);
    canBioMetric();
    listOfBioMetricsFxn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isAuthenticate ? "Your device Support the biometrics" : "Your device doesn't support biometric",
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => authenticateFxn(),
              child: !_authenticated
                  ? const Icon(
                      Icons.toggle_off,
                      size: 80,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.toggle_on,
                      size: 80,
                      color: Colors.green,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
