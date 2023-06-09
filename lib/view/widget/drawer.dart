import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/home_page_provider.dart';
import '../../util/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context, listen: false);
    return SafeArea(
        child: Theme(
      data: AppTheme.reverseThemeData(context.theme).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return 5;
            }
            return 5;
          }),
          trackVisibility: MaterialStateProperty.resolveWith((states) {
            return true;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
          trackBorderColor: MaterialStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
          radius: const Radius.circular(borderRadius),
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return context.theme.colorScheme.onPrimary;
            }
            return context.theme.colorScheme.onPrimary;
          }),
        ),
      ),
      child: Consumer<HomePageProvider>(builder: (context,data,_) {
        return Drawer(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(

                      backgroundImage: NetworkImage(provider.userModel?.profilePic ?? ''),
                      backgroundColor: context.theme.colorScheme.onPrimary,
                      radius: 70,
                    ),
                  ],
                ),
                Text(
                  provider.userModel?.name ?? "",
                  style: context.textTheme.titleLarge,
                ),
                Text(
                  provider.userModel?.email ?? "",
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  provider.userModel?.dob ?? "",
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  title: Text(
                    'Settings',
                    style: TextStyle(
                        color: context.theme.colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    data.showMode == false ? Icons.arrow_drop_down_sharp : Icons.arrow_drop_up_outlined,
                    color: context.theme.colorScheme.primary,
                  ),
                  onTap: () {
                    print(data.userModel?.profilePic??'');
                    provider.onSettings();
                  },
                ),
                provider.showMode == false
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text(
                                MyApp.themeNotifier.value == ThemeMode.light ? 'Light Mode' : 'Dark Mode',
                                style: context.textTheme.bodyLarge,
                              ),
                              onPressed: () {
                                MyApp.themeNotifier.value =
                                MyApp.themeNotifier.value == ThemeMode.light
                                    ? ThemeMode.dark
                                    : ThemeMode.light;
                              },
                            ),
                          ],
                        )),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        color: context.theme.colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    provider.userSignOut();
                  },
                )
              ],
            ),
          ),
        );
      }),
    ));
  }
}
