import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigator {
  static Future<T?> navigateWithProvider<T, P extends ChangeNotifier>({
    required BuildContext context,
    required P provider,
    required Widget Function(BuildContext) builder,
  }) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (context) => Provider<P>(
          create: (_) => provider,
          dispose: (_, provider) => provider.dispose(), // Clean up if needed
          child: Builder(builder: (context) => builder(context)),
        ),
      ),
    );
  }
}
