import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_for_lilac/provider/authentication_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              if(provider.isSignedIn == true){
                await provider.getDataFromSP().whenComplete(() =>Navigator.pushNamed(context, 'homePage') );
              }else{
                Navigator.pushNamed(context, 'login');
              }
            },
            child: const Text('Get Started')),
      ),
    );
  }
}
