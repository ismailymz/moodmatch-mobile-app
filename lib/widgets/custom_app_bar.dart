import 'package:flutter/material.dart';
import '../constants/app_colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkAppBar
          : AppColors.lightAppBar,
      centerTitle: true,
      title: Image.asset(
        'assets/images/moodmatch_logo.png', // Logo path
        height: 96, // size
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}