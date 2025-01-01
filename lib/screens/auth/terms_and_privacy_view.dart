import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 링크 열기 위한 패키지

class TermsAndPrivacyView extends StatelessWidget {
  const TermsAndPrivacyView({super.key});

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "利用規約 (Terms of Use)",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "1. サービス概要\n"
              "MOTTA (“本サービス”) は、ユーザーが外出前に必要な物やリストを確認し、忘れ物を防ぐためのアプリケーションです。\n\n"
              "2. 利用規約への同意\n"
              "本サービスを利用することで、ユーザーは本規約に同意したものとみなされます。同意いただけない場合、本サービスの利用はできません。\n\n"
              "3. ユーザーの義務\n"
              "  - ユーザーは、本サービスを許可された目的のみに利用しなければなりません。\n"
              "  - 他人の権利を侵害する行為または違法な目的での利用は禁止されています。\n\n"
              "4. サービス提供および制限\n"
              "  - MOTTAは、事前通知なしにサービスを一時停止または終了することがあります。\n"
              "  - ユーザーが本規約に違反した場合、アカウントが制限される場合があります。\n\n"
              "5. 責任の制限\n"
              "  - 本サービスは、ユーザーの忘れ物を100%防ぐことを保証するものではありません。\n"
              "  - MOTTAは、サービス利用中に発生したデータ損失や不便に対して責任を負いません。\n\n"
              "6. 準拠法および紛争解決\n"
              "本規約は日本の法律に従って解釈されます。紛争が生じた場合、管轄裁判所は兵庫県神戸地方裁判所とします。",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            const Text(
              "プライバシーポリシー (Privacy Policy)",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "1. 収集する情報\n"
              "  - 必須情報:\n"
              "    - メールアドレス\n"
              "    - 状況およびアイテムデータ\n"
              "  - 任意情報:\n"
              "    - ユーザーが追加で入力するメモ\n\n"
              "2. 情報の利用目的\n"
              "  - ユーザーに合わせたサービスの提供\n"
              "  - サービス改善および統計分析\n"
              "  - 広告の提供および関連データの活用\n\n"
              "3. 情報の共有\n"
              "  - 本サービスはGoogle AdMobプラットフォームを利用して広告を提供します。\n"
              "  - ユーザーのデータは匿名化された形で、広告目的でGoogle AdMobと共有される場合があります。\n\n"
              "4. データの保存\n"
              "  - ユーザーのアカウントが削除された場合、データは最大1年間保存された後、完全に削除されます。\n"
              "  - 保存期間中、データは非活性状態で維持されます。\n\n"
              "5. ユーザーの権利\n"
              "  - ユーザーは、自身の情報を閲覧、修正、削除を求める権利があります。\n"
              "  - データの削除および修正のリクエストは、アプリ内の設定メニューを通じて行えます。\n\n"
              "6. データのセキュリティ\n"
              "  - MOTTAは、ユーザーのデータを保護するために適切な技術的および管理的措置を講じています。\n"
              "  - しかし、インターネットを介したデータ送信過程で生じるすべてのリスクを完全に保証するものではありません。\n\n"
              "7. 問い合わせ情報",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "データ保護に関するお問い合わせは、以下の連絡先までご連絡ください:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "  - メール: csh77776@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl("https://forms.gle/7jmP9jrPfcXZQi676"),
              child: const Text(
                "  - フォーム: こちらをクリックしてください",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "8. ポリシーの変更\n"
              "本プライバシーポリシーは変更される場合があります。重要な変更がある場合、事前にユーザーに通知します。",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
