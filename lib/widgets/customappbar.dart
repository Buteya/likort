import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cartbadge.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.appTitle,
    required this.appThemeMode,
    required this.toggleThemeMode,
  });

  final String appTitle;
  final ThemeMode appThemeMode;
  final Function() toggleThemeMode;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 74,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.dehaze_rounded,
            size: 40,
          ),
          onPressed: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
              items: [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.notifications),
                      Text('Notifications')
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.favorite_rounded), Text('Favorites')],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.chat_bubble_rounded),
                      Text('Chat Artist')
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.admin_panel_settings_rounded),
                      Text('Admin Panel')
                    ],
                  ),
                ),
              ],
              elevation: 8.0,
            ).then((value) {
              if (value != null) {
                // Handle menu selection here
                if (value == 1) {
                  Navigator.of(context)
                      .pushReplacementNamed('/likortfavoritesscreen');
                }
                if (value == 3) {
                  Navigator.of(context)
                      .pushReplacementNamed('/likortadminhome');
                }

                print("Selected: $value");
              }
            });
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/likorthomescreen');
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Transform.rotate(
              angle: -6 * 3.1415926535897932 / 180,
              child: Transform.scale(
                scaleX: 1.36,
                scaleY: 1.0,
                child: Text(
                  widget.appTitle,
                  style: GoogleFonts.dancingScript(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(widget.appThemeMode == ThemeMode.light
              ? Icons.wb_sunny
              : (widget.appThemeMode == ThemeMode.dark
                  ? Icons.nights_stay
                  : Icons.brightness_auto)),
          onPressed: widget.toggleThemeMode,
        ),
        IconButton(
          onPressed: () {},
          icon: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                '/likortcart',
                arguments: [
                  widget.appThemeMode,
                  widget.toggleThemeMode,
                ],
              );
            },
            child: const CartBadge(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/likortuserprofile');
            },
            child: const CircleAvatar(
              child: Icon(
                Icons.person,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
