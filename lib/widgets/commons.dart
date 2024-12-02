import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  const BottomSheetHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class StyledSearchBar extends StatefulWidget {
  final void Function(String query) onSearchTextChanged;
  final String hintText;
  const StyledSearchBar({
    super.key,
    required this.onSearchTextChanged,
    required this.hintText,
  });

  @override
  State<StyledSearchBar> createState() => _StyledSearchBarState();
}

class _StyledSearchBarState extends State<StyledSearchBar> {
  late StreamSubscription<bool> keyboardSubscription;
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      contentPadding: const EdgeInsets.only(top: 5),
      hintText: widget.hintText,
      prefixIcon: const Icon(Icons.search),
      filled: true,
      fillColor: Theme.of(context).primaryColor.withAlpha(50),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
        child: SizedBox(
          height: 40,
          child: TextField(
            style: const TextStyle(fontSize: 14),
            decoration: decoration,
            onChanged: (text) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () {
                widget.onSearchTextChanged(text);
              });
            },
          ),
        ),
      ),
    );
  }
}
