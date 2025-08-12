// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:benevolent_crm_app/app/themes/app_color.dart';

// /// A reusable, modern, theme-aware draggable sheet.
// /// Use with Get.bottomSheet(ModernDraggableSheet(...))
// class ModernDraggableSheet extends StatelessWidget {
//   final String title;
//   final Widget Function(ScrollController scrollController) bodyBuilder;
//   final Color? headerColor;
//   final VoidCallback? onClose;

//   const ModernDraggableSheet({
//     super.key,
//     required this.title,
//     required this.bodyBuilder,
//     this.headerColor,
//     this.onClose,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final scheme = theme.colorScheme;
//     final surface =
//         theme.bottomSheetTheme.backgroundColor ??
//         scheme.surface.withOpacity(
//           theme.brightness == Brightness.dark ? 0.98 : 1,
//         );

//     return DraggableScrollableSheet(
//       initialChildSize: 0.62,
//       minChildSize: 0.25,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (_, scrollController) {
//         return Material(
//           color: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//               color: surface,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(22),
//               ),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0x1A000000),
//                   blurRadius: 18,
//                   offset: Offset(0, -6),
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               top: false,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 8),
//                   // grabber
//                   Container(
//                     width: 44,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: scheme.outlineVariant,
//                       borderRadius: BorderRadius.circular(999),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // header
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 14),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: (headerColor ?? AppColors.primaryColor)
//                             .withOpacity(.08),
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color: (headerColor ?? AppColors.primaryColor)
//                               .withOpacity(.20),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 36,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               color: (headerColor ?? AppColors.primaryColor)
//                                   .withOpacity(.15),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.tune_rounded,
//                               size: 20,
//                               color: headerColor ?? AppColors.primaryColor,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               title,
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.w700,
//                                 color: scheme.onSurface,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           IconButton.filledTonal(
//                             onPressed: onClose ?? Get.back,
//                             icon: const Icon(Icons.close_rounded),
//                             style: IconButton.styleFrom(
//                               backgroundColor: scheme.surfaceVariant,
//                               foregroundColor: scheme.onSurfaceVariant,
//                               padding: const EdgeInsets.all(8),
//                               minimumSize: const Size(36, 36),
//                               shape: const CircleBorder(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),
//                   const Divider(height: 1),

//                   // body (scrolls with the sheet)
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(14),
//                         ),
//                         child: bodyBuilder(scrollController),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
