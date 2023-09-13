import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/pages/auth/login.dart';
import 'package:inkscribe/providers/theme_provier.dart';
import '../components/account_deletion_confirmation.dart';
import '../theme/palette.dart';
import '../utils/auth_service.dart';
import '../components/account_settings_card.dart';
import '../components/main_profile_card.dart';

class Account extends ConsumerWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeState = ref.watch(themesProvider);
    final List<Map<Object, dynamic>> accountSettings = [
      {
        "color": Palette.primePurple,
        "iconData": Icons.nightlight_outlined,
        "text": "Toggle dark mode",
        "isSwitchVisible": true,
        "onTap": () => AuthServices().logout(),
      },
      {
        "color": Palette.noteColor5,
        "iconData": Icons.logout_outlined,
        "text": "Sign out",
        "isSwitchVisible": false,
        "onTap": () => AuthServices().logout().then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              ),
            ),
      },
      {
        "color": Colors.red,
        "iconData": Icons.delete_forever_outlined,
        "text": "Delete account",
        "isSwitchVisible": false,
        "onTap": () => showDialog(
              context: context,
              builder: (context) => const AccountDeletionConfirmationWidget(),
            ),
      },
    ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'InkScribe',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainProfileCard(size: size),
            ...accountSettings.map((e) {
              return Consumer(builder: (context, ref, child) {
                return AccountSettingsCard(
                  size: size,
                  color: e['color'],
                  iconData: e['iconData'],
                  isSwitchVisible: e['isSwitchVisible'],
                  text: e['text'],
                  onTap: e['onTap'],
                  value: themeModeState == ThemeMode.dark,
                  toggleDarkTheme: (value) {
                    ref.read(themesProvider.notifier).changeTheme(value);
                  },
                );
              });
            }),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'InkScribe',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      ' by Saint Anthony',
                      style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
