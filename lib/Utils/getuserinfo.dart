import 'package:cloud_firestore/cloud_firestore.dart';

class UserRole {
  static Future<String?> getUserRole(String email) async {
    try {
      // Check "builder" collection (corrected label in the comment)
      var builderSnapshot = await FirebaseFirestore.instance
          .collection('builders')
          .doc(email)
          .collection('userinformation')
          .doc('userinfo')
          .get();
      if (builderSnapshot.exists) {
        return 'Builder';
      }

      // Check "machinery" collection
      var machinerySnapshot = await FirebaseFirestore.instance
          .collection('machinery')
          .doc(email)
          .collection('userinformation')
          .doc('userinfo')
          .get();

      if (machinerySnapshot.exists) {
        return 'Machinery';
      }

      // Check "materials" collection (corrected label in the comment)
      var materialsSnapshot = await FirebaseFirestore.instance
          .collection('materials')
          .doc(email)
          .collection('userinformation')
          .doc('userinfo')
          .get();
      if (materialsSnapshot.exists) {
        return 'Material';
      }

      // User not found in any collection
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
