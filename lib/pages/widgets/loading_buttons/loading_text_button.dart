import 'package:flutter/material.dart';

class LoadingTextButton extends StatefulWidget {
  final Widget child;
  final ButtonStyle? style;
  final Future<void> Function() onPressed;

  const LoadingTextButton(
      {required this.child, required this.onPressed, this.style, Key? key})
      : super(key: key);

  @override
  State<LoadingTextButton> createState() => _LoadingTextButtonState();
}

class _LoadingTextButtonState extends State<LoadingTextButton> {
  bool _isLoading = false;

  _action() async {
    setState(() {
      _isLoading = true;
    });
    await widget.onPressed();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _isLoading ? null : () => _action(),
      child: _isLoading ? const CircularProgressIndicator() : widget.child,
      style: widget.style,
    );
  }
}
