import 'package:flutter/material.dart';
import 'package:inkscribe/theme/palette.dart';

class AccountSettingsCard extends StatefulWidget {
  const AccountSettingsCard({
    super.key,
    required this.size,
    required this.color,
    required this.iconData,
    required this.isSwitchVisible,
    required this.text,
    required this.onTap,
    required this.value,
    required this.toggleDarkTheme,
  });

  final Size size;
  final Color color;
  final IconData iconData;
  final String text;
  final bool isSwitchVisible;
  final Function() onTap;
  final bool value;
  final Function(bool) toggleDarkTheme;

  @override
  State<AccountSettingsCard> createState() => _AccountSettingsCardState();
}

class _AccountSettingsCardState extends State<AccountSettingsCard> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: 62.0,
            width: widget.size.width,
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 62.0,
                  margin: const EdgeInsets.only(left: 12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.25),
                  ),
                  child: Center(
                    child: Icon(widget.iconData, color: widget.color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 110.0),
                  child: Text(widget.text),
                ),
                Visibility(
                  visible: widget.isSwitchVisible,
                  child: Switch(
                    value: widget.value,
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Palette.primePurple,
                    thumbColor: const MaterialStatePropertyAll(Colors.white),
                    onChanged: widget.toggleDarkTheme,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Switch(
//           value: Theme.of(context).brightness == Brightness.dark,
//           onChanged: (value) {
//             Theme.of(context).brightness = value ? Brightness.dark : Brightness.light;
//           },
//         ),
//       ),