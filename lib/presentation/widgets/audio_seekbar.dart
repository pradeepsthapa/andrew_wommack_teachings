import 'dart:math';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Stack(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 1,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: value,
            inactiveColor: Colors.grey[500],
            onChanged: (value) {
              if (!_dragging) {
                _dragging = true;
              }
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragging = false;
            },
          ),
        ),
        Positioned(
          bottom: 0,left: 24,
          child: Text(fromDuration(_passed),
              style: TextStyle(fontSize: 12,color:isDark?Colors.white54:Colors.grey[600])),
        ),
        Positioned(
          bottom: 0,right: 24,
          child: Text('- '+fromDuration(_remaining),
              style: TextStyle(fontSize: 12,color:isDark?Colors.white54:Colors.grey[600])),
        ),
      ],
    );
  }
  String fromDuration(Duration duration){
    return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$duration")?.group(1) ?? '$duration';
  }
  Duration get _remaining => widget.duration - widget.position;
  Duration get _passed => widget.position;
}