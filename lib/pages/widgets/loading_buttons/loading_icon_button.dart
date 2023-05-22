import 'package:flutter/material.dart';

class LoadingIconButton extends StatefulWidget {
  final Widget icon;
  final ButtonStyle? style;
  final Future<void> Function() onPressed;

  const LoadingIconButton(
      {required this.icon, required this.onPressed, this.style, Key? key})
      : super(key: key);

  @override
  State<LoadingIconButton> createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton> {
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
    return IconButton(
      onPressed: _isLoading ? null : () => _action(),
      icon: widget.icon,
      style: widget.style,
    );
  }
}
