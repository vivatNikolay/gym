import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatefulWidget {
  final Widget child;
  final ButtonStyle? style;
  final Future<void> Function() onPressed;

  const LoadingElevatedButton(
      {required this.child, required this.onPressed, this.style, Key? key})
      : super(key: key);

  @override
  State<LoadingElevatedButton> createState() => _LoadingElevatedButtonState();
}

class _LoadingElevatedButtonState extends State<LoadingElevatedButton> {
  bool _isLoading = false;

  _action() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    await widget.onPressed();
    setState(() {
      _isLoading = false;
    });
  }

  _emptyAction() {
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? _emptyAction : () => _action(),
      child: widget.child,
      style: widget.style,
    );
  }
}
