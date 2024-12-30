import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/data/app_colors.dart';
import 'package:wasurenai/screens/setting_view.dart';
import 'package:wasurenai/welcome_view.dart';
import 'package:wasurenai/widgets/Buttons/reusable_buttons.dart';
import '../../models/situation.dart';
import '../../viewmodels/home_view_model.dart';
import 'edit_situations_view.dart';
import 'item_list_screen.dart';
import '../../widgets/custom_list_tile.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final viewModel = Provider.of<HomeViewModel>(context);

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeView()),
      );
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
              const SizedBox(height: 150),
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
              Flexible(
                flex: 2,
                child: StreamBuilder<List<Situation>>(
                  stream: viewModel.fetchSituations(uid!),
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
                                    userId: uid,
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
              // 재사용 가능한 하단 버튼 사용
              ReusableButtons(
                settingsLabel: '設定',
                settingsIcon: Icons.settings,
                onPressed: () {
                  // 설정 버튼 클릭 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingView(),
                    ),
                  );
                },
                editLabel: '編集',
                editIcon: Icons.edit,
                onEditPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditSituationsView(),
                    ),
                  );
                  // 편집 버튼 클릭 동작
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
