import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar의 배경색을 투명하게 하기 위해 필요
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // 그림자 제거
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // 뒤로가기 버튼 눌렀을 때의 동작
            Navigator.of(context).pop();
          },
        ),
        title: Text('Article Example', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white, // 전체 배경색을 흰색으로 설정
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  'https://via.placeholder.com/150',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xff701FFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '금융상식',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '금 투자 좋은 점은 무엇일까?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\n금 투자의 장점 5 가지\n\n1. 기나긴 가치 상승의 역사\n금은 그 존재가 알려진 태초의 시기부터 사람들이 탐내왔으며, 부를 축적하는 데 사용되는 수단이었습니다. 비록 언제부턴가 대부분의 중앙은행들이 금본위제를 실시하지 않고 있지만, 오늘날에도 특히 경제 침체기를 비롯한 여러 시기에 금은 여전히 상당한 가치를 지닙니다. 동전이나 지폐와 달리 금은 수 세기가 지나는 동안 안정성을 유지해 왔습니다. 투자자들은 후손에게 부를 물려주는 수단으로 금을 선택할 수도 있겠습니다.\n\n2. 위기상황 때 믿을 수 있는 헤지 수단\n역사적으로 금은 인플레이션을 비롯한 여러 위기 상황에서 믿을 수 있는 헤지 수단으로 활용되어 왔습니다. 심지어 생계비용이 지속 상승하는 2022년도에도 금값은 상승했습니다. 세계 주요 선진국들이 고인플레이션으로부터 고통받으면서 통화 가치는 하락했고, 국채금리 또한 불리한 상황으로 흘러갔습니다. 이같은 상황 속에서 투자자들은 금으로 눈을 돌렸는데, 이유인즉 예금금리와 국채금리의 안전자산적 성격이 약화되었기 때문입니다. 지난 50년이 넘는 기간 동안 금값은 꾸준히 상승했으며, 반면 고인플레이션 현상이 발생할 때마다 주식시장은 폭락했습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}