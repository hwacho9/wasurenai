import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/edit_situations_view_model.dart';
import '../../widgets/custom_list_tile.dart';

class EditSituationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditSituationsViewModel>(context);

    // 화면이 빌드될 때 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.situations.isEmpty && !viewModel.isLoading) {
        viewModel.fetchSituations();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('편집')),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : viewModel.situations.isEmpty
              ? Center(child: Text('리스트가 비어 있습니다.'))
              : ListView.builder(
                  itemCount: viewModel.situations.length,
                  itemBuilder: (context, index) {
                    final situation = viewModel.situations[index];

                    return CustomListTile(
                      title: situation.name,
                      subtitle: '', // 상황에 맞게 설명 추가 가능
                      showSwitch: false, // 스위치 비활성화
                      onTap: () {
                        // 필요한 경우 상황 항목 클릭 동작 추가
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          viewModel.deleteSituation(index);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSituationModal(context, viewModel);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddSituationModal(
      BuildContext context, EditSituationsViewModel viewModel) {
    String situationName = '';
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Situation Name'),
                onChanged: (value) {
                  situationName = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (situationName.isNotEmpty) {
                    viewModel.addSituation(situationName);
                    Navigator.pop(context);
                  }
                },
                child: Text('추가'),
              ),
            ],
          ),
        );
      },
    );
  }
}