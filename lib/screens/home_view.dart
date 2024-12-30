import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wasurenai/screens/edit_situations_view.dart';
import 'package:wasurenai/screens/item_list_screen.dart';
import '../../models/situation.dart';
import '../../widgets/custom_list_tile.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('로그인되어 있지 않습니다.'));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('상황별 체크리스트'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/splash');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('situations')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('리스트가 비어 있습니다.'));
          }

          final situations = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Situation(
              name: data['name'],
              items: (data['items'] as List<dynamic>)
                  .map((item) => Item(
                        name: item['name'],
                        location: item['location'],
                      ))
                  .toList(),
            );
          }).toList();

          return ListView.builder(
            itemCount: situations.length,
            itemBuilder: (context, index) {
              final situation = situations[index];
              return CustomListTile(
                title: situation.name,
                subtitle: '',
                showSwitch: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ItemListScreen(situation: situation),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditSituationsView()),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
