import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> registrarDesempenho(String modulo, bool acertou) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance.collection('desempenho').doc(uid);

  final campo = acertou ? 'acertos' : 'erros';

  await docRef.set({
    modulo: {campo: FieldValue.increment(1)}
  }, SetOptions(merge: true));
}