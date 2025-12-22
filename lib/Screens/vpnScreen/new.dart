// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class CircularPowerButton extends StatefulWidget {
//   final bool isActive;
//   final VoidCallback? onTap;
//   final double size;

//   const CircularPowerButton({
//     Key? key,
//     this.isActive = false,
//     this.onTap,
//     this.size = 140,
//   }) : super(key: key);

//   @override
//   State<CircularPowerButton> createState() => _CircularPowerButtonState();
// }

// class _CircularPowerButtonState extends State<CircularPowerButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: GestureDetector(
//           onTap: widget.onTap,
//           child: Container(
//             width: 74,
//             height: 74,
//             decoration: BoxDecoration(
//               gradient: RadialGradient(
//                 colors: [
//                   Color(0xFF2A669A), // Lighter blue outer
//                   Color(0xFF1B4D7E), // Medium blue
//                   Color(0xFF0D3D6B), // Darker blue inner
//                 ],
//                 stops: [0.0, 0.5, 1.0],
//                 center: Alignment.center,
//               ),
//               border: Border.all(color: Colors.white, width: 0.6),
//               shape: BoxShape.circle,
//             ),
//             child: Stack(
//               children: [
//                 // Outer ring decoration
//                 Center(
//                   child: Container(
//                     width: widget.size * 0.85,
//                     height: widget.size * 0.85,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: widget.isActive
//                             ? Colors.white.withOpacity(0.15)
//                             : Colors.white.withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Inner circle (darker)
//                 Center(
//                   child: Container(
//                     width: 55,
//                     height: 55,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF0A2847),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.2),
//                         width: 1.5,
//                       ),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         CupertinoIcons.power,
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
