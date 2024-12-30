import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/data/app_colors.dart';
import '../../models/situation.dart';
import '../../viewmodels/home_view_model.dart';
import 'edit_situations_view.dart';
import 'item_list_screen.dart';
import '../../widgets/custom_list_tile.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final viewModel = Provider.of<HomeViewModel>(context);

    if (user == null) {
      return const Center(child: Text('로그인되어 있지 않습니다.'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 상단 배경
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              color: AppColors.lightRed,
              borderRadius: BorderRadius.vertical(
                bottom:
                    Radius.elliptical(MediaQuery.of(context).size.width, 180),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 150), // 상태바 높이 조정
              // 상단 텍스트와 장식
              const Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.lightRed,
                  ),
                  SizedBox(height: 8),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.lightRed,
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: AppColors.lightRed,
                  ),
                  SizedBox(height: 30),
                  Text(
                    '今日はどこへ行く？',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              // 리스트뷰
              Expanded(
                child: StreamBuilder<List<Situation>>(
                  stream: viewModel.fetchSituations(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('リストが空です。'));
                    }

                    final situations = snapshot.data!;

                    return ListView.builder(
                      itemCount: situations.length,
                      itemBuilder: (context, index) {
                        final situation = situations[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: CustomListTile(
                            color: AppColors.scaffoldBackground,
                            title: situation.name,
                            subtitle: '',
                            showSwitch: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemListScreen(
                                    situation: situation,
                                    userId: user.uid,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // 하단 버튼
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // 설정 버튼 동작
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('설정'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditSituationsView()),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('편집'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
