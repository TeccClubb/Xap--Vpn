// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';

// class CustomButton extends StatefulWidget {
//   final String status;
//   final VoidCallback onToggle;
//   final double width;
//   final double height;

//   const CustomButton({
//     Key? key,
//     required this.status,
//     required this.onToggle,
//     this.width = 90,
//     this.height = 200,
//   }) : super(key: key);

//   @override
//   State<CustomButton> createState() => _CustomButtonState();
// }

// class _CustomButtonState extends State<CustomButton> {
//   double _dragPosition = 0;
//   late double _buttonHeight;
//   final double _circleSize = 74;

//   @override
//   void initState() {
//     super.initState();
//     _buttonHeight = widget.height;
//   }

//   void _onVerticalDragUpdate(DragUpdateDetails details) {
//     setState(() {
//       _dragPosition += details.delta.dy;

//       if (widget.status == "connected") {
//         // When connected, drag from top to bottom
//         _dragPosition = _dragPosition.clamp(
//           0.0,
//           _buttonHeight - _circleSize - 16,
//         );
//       } else {
//         // When disconnected, drag from bottom to top
//         _dragPosition = _dragPosition.clamp(
//           -(_buttonHeight - _circleSize - 16),
//           0.0,
//         );
//       }
//     });
//   }

//   void _onVerticalDragEnd(DragEndDetails details) {
//     double threshold = (_buttonHeight - _circleSize - 16) * 0.5;

//     if (widget.status == "connected") {
//       // Swiping down to disconnect
//       if (_dragPosition > threshold) {
//         widget.onToggle();
//         setState(() {
//           _dragPosition = 0;
//         });
//       } else {
//         // Snap back
//         setState(() {
//           _dragPosition = 0;
//         });
//       }
//     } else if (widget.status == "disconnected") {
//       // Swiping up to connect
//       if (_dragPosition < -threshold) {
//         widget.onToggle();
//         setState(() {
//           _dragPosition = 0;
//         });
//       } else {
//         // Snap back
//         setState(() {
//           _dragPosition = 0;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double maxDrag = _buttonHeight - _circleSize - 8;
//     double circleTop = widget.status == "connected"
//         ? 8 + _dragPosition
//         : maxDrag + _dragPosition;

//     return GestureDetector(
//       onVerticalDragUpdate: _onVerticalDragUpdate,
//       onVerticalDragEnd: _onVerticalDragEnd,
//       child: Container(
//         width: widget.width,
//         height: widget.height,
//         decoration: BoxDecoration(
//           gradient: widget.status == "connected"
//               ? LinearGradient(
//                   colors: [Color(0xFF1F1D30), Color(0xFF00417B)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 )
//               : null,
//           color: widget.status == "connected" ? null : Color(0xFFE0E0E0),
//           borderRadius: BorderRadius.circular(widget.width / 2),
//           boxShadow: [
//             BoxShadow(
//               color:
//                   (widget.status == "connected"
//                           ? Color(0xFF00417B)
//                           : Colors.grey)
//                       .withOpacity(0.3),
//               blurRadius: 12,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Chevron icons (bottom when connected)
//             if (widget.status == "connected")
//               Positioned(
//                 bottom: 16,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.white.withOpacity(0.7),
//                         size: 22,
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.white.withOpacity(0.5),
//                         size: 22,
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.white.withOpacity(0.3),
//                         size: 22,
//                       ),
//                       Text(
//                         "Stop",
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.5),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             // Chevron icons (top when disconnected)
//             if (widget.status == "disconnected")
//               Positioned(
//                 top: 16,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         "Start",
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.black.withOpacity(0.5),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_up,
//                         color: Colors.black.withOpacity(0.3),
//                         size: 22,
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_up,
//                         color: Colors.black.withOpacity(0.4),
//                         size: 22,
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_up,
//                         color: Colors.black.withOpacity(0.6),
//                         size: 22,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             // Draggable Circle
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 200),
//               curve: Curves.easeOut,
//               top: circleTop,
//               left: 8,
//               right: 8,
//               child: widget.status == "connected"
//                   ? _buildConnectedCircle()
//                   : _buildDisconnectedCircle(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConnectedCircle() {
//     return Container(
//       width: _circleSize,
//       height: _circleSize,
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [
//             Color(0xFF2A669A), // Lighter blue outer
//             Color(0xFF1B4D7E), // Medium blue
//             Color(0xFF0D3D6B), // Darker blue inner
//           ],
//           stops: [0.0, 0.5, 1.0],
//           center: Alignment.center,
//         ),
//         border: Border.all(color: Colors.white, width: 0.6),
//         shape: BoxShape.circle,
//       ),
//       child: Stack(
//         children: [
//           // Inner circle (darker)
//           Center(
//             child: Container(
//               width: 55,
//               height: 55,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF1F1D30), Color(0xFF00417B)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 shape: BoxShape.circle,
//                 border: const GradientBoxBorder(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Color(0xFF0A2847), Colors.white],
//                   ),
//                   width: 0.6,
//                 ),
//               ),
//               child: Center(
//                 child: Icon(
//                   CupertinoIcons.power,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDisconnectedCircle() {
//     return Container(
//       width: _circleSize,
//       height: _circleSize,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Center(
//         child: widget.status == "connecting" || widget.status == "disconnecting"
//             ? CircularProgressIndicator(
//                 color: widget.status == "disconnecting"
//                     ? Colors.redAccent
//                     : Colors.orangeAccent,
//                 strokeWidth: 3,
//               )
//             : Icon(
//                 Icons.power_settings_new,
//                 color: Color(0xFF666B7A),
//                 size: 32,
//               ),
//       ),
//     );
//   }
// }
