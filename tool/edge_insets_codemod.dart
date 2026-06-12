// import 'package:codemod/codemod.dart';
// import 'dart:async';
//
//
// void main(List<String> args) {
//   runInteractiveCodemod(
//     args,
//     [
//       EdgeInsetsSymmetricTransformer(),
//     ] as Suggestor,
//   );
// }
//
// class EdgeInsetsSymmetricTransformer extends GeneralizingAstVisitor
//     with AstVisitingSuggestor {
//   @override
//   void visitInstanceCreationExpression(node) {
//     final source = node.toSource();
//
//     // Match: EdgeInsets.symmetric(...)
//     if (source.startsWith('EdgeInsets.symmetric')) {
//       final newCode = source.replaceFirst(
//         'EdgeInsets.symmetric',
//         'symmetric',
//       );
//
//       yieldPatch(
//         newCode,
//         node.offset,
//         node.end,
//       );
//     }
//   }
// }