import 'dart:async';

import 'package:flutter/material.dart';

class Clockview extends StatefulWidget {
  const Clockview({super.key, this.size});

  final double? size;

  @override
  State<Clockview> createState() => _ClockviewState();
}

class _ClockviewState extends State<Clockview> {
  late Timer timer;
  
  

  @override
  Widget build(BuildContext context) {    
    return const Placeholder();
  }
}