// Dart 비동기 작업을 위한 Timer 클래스 사용
import 'dart:async';
// 수학 연산(삼각함수, 파이값 등)을 위한 dart:math 라이브러리
import 'dart:math';

// Flutter의 기본 위젯들을 사용하기 위한 Material 패키지
import 'package:flutter/material.dart';
// 로깅을 위한 Talker 패키지 - 개발 중 디버깅 정보 출력
import 'package:talker/talker.dart';

// 앱 전체에서 사용하는 커스텀 색상 테마 데이터
import '../data/theme_data.dart';

// 전역 로거 인스턴스 - 앱 전체에서 로그를 출력할 때 사용
final talker = Talker();

/**
 * ClockView - 실시간으로 업데이트되는 아날로그 시계 위젯
 * 
 * 이 위젯은 현재 시간을 아날로그 시계 형태로 표시하며,
 * 매초마다 자동으로 업데이트됩니다.
 * 
 * 주요 기능:
 * - 실시간 시계 표시 (시침, 분침 포함)
 * - 커스텀 디자인과 색상 적용
 * - 크기 조절 가능
 * - 메모리 누수 방지를 위한 타이머 정리
 */
class ClockView extends StatefulWidget {
  const ClockView({super.key, this.size});

  // 시계의 크기를 지정하는 선택적 매개변수
  // null이면 부모 위젯의 크기에 맞춰집니다
  final double? size;

  @override
  State<ClockView> createState() => _ClockViewState();
}

/**
 * _ClockViewState - ClockView 위젯의 상태 관리 클래스
 * 
 * 이 클래스는 시계의 실시간 업데이트를 담당합니다.
 * Timer를 사용하여 매초마다 setState()를 호출하여 화면을 다시 그립니다.
 */
class _ClockViewState extends State<ClockView> {
  // 매초마다 위젯을 업데이트하는 타이머
  // late 키워드: 초기화는 나중에 하지만 사용 전에는 반드시 초기화됨을 보장
  late Timer timer;

  @override
  void initState() {
    // 위젯이 생성될 때 타이머를 시작합니다
    // Duration(seconds: 1): 1초마다 실행
    // setState(() {}): 화면을 다시 그리도록 Flutter에게 알림
    this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // 빈 setState - 시간이 변경되었으므로 CustomPainter가 다시 그려집니다
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 타이머를 정리하여 메모리 누수를 방지합니다
    // 이는 매우 중요한 부분으로, 이를 생략하면 앱이 종료되어도 타이머가 계속 실행될 수 있습니다
    this.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      // 상단 중앙에 시계를 정렬합니다
      alignment: Alignment.topCenter,
      child: Container(
        // widget.size가 지정되면 해당 크기로, 아니면 부모 크기에 맞춤
        width: widget.size,
        height: widget.size,
        child: Transform.rotate(
          // 시계를 -90도 회전시켜 12시 방향이 위쪽을 향하도록 합니다
          // -pi/2 라디안 = -90도
          angle: -pi / 2,
          // CustomPaint 위젯을 사용하여 직접 Canvas에 시계를 그립니다
          child: CustomPaint(painter: ClockPainter()),
        ),
      ),
    );
  }
}

/**
 * ClockPainter - 시계의 실제 그리기를 담당하는 CustomPainter 클래스
 * 
 * 이 클래스는 Canvas API를 사용하여 시계의 모든 구성 요소를 그립니다:
 * - 시계 배경 원
 * - 시계 테두리
 * - 시침 (hour hand)
 * - 분침 (minute hand)
 * - 초침 (second hand) - 현재 미구현
 * - 중앙 점 - 현재 미구현
 * - 시간 눈금 - 현재 미구현
 */
class ClockPainter extends CustomPainter {
  // 현재 시간을 가져옵니다 - paint 메서드가 호출될 때마다 최신 시간으로 업데이트
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    // 캔버스의 중심점 계산
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    
    // 디버깅을 위한 로그 출력 - 시계의 중심 좌표 확인
    talker.info('ClockPainter: centerX: $centerX, centerY: $centerY');

    // 중심점을 Offset 객체로 생성
    var center = Offset(centerX, centerY);
    // 시계의 반지름 계산 - 가로와 세로 중 작은 값의 절반
    var radius = min(centerX, centerY);

    // ========== Paint 객체들 정의 - 각 구성 요소의 스타일 설정 ==========
    
    // 시계 배경을 채울 Paint 객체
    var fillBrush = Paint()..color = CustomColors.clockBG;
    
    // 시계 테두리를 그릴 Paint 객체
    var outlineBrush = Paint()
      ..color = CustomColors.clockOutline // 테두리 색상
      ..style = PaintingStyle.stroke // 채우기가 아닌 선으로 그리기
      ..strokeWidth = size.width / 20; // 선의 굵기를 화면 크기에 비례하여 설정

    // 중앙 점을 그릴 Paint 객체 (현재 미사용 - 추후 구현 예정)
    // var centerDotBrush = Paint()..color = CustomColors.clockOutline;

    // 초침을 그릴 Paint 객체 (현재 미사용 - 추후 구현 예정)
    // var secHandBrush = Paint()
    //   ..color = CustomColors.secHandColor!
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = size.width / 20;

    // 분침을 그릴 Paint 객체 (현재 미사용 - 추후 구현 예정)
    // 그라데이션 효과가 적용된 분침
    // var minHandBrush = Paint()
    //   ..shader = RadialGradient(
    //     colors: [CustomColors.minHandStatColor, CustomColors.minHandEndColor],
    //   ).createShader(Rect.fromCircle(center: center, radius: radius))
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = size.width / 30;

    // 시침을 그릴 Paint 객체
    // 그라데이션 효과가 적용되어 시각적으로 더 아름다운 시침
    var hourHandBrush = Paint()
      ..shader = RadialGradient(
        colors: [CustomColors.hourHandStatColor, CustomColors.hourHandEndColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke // 선으로 그리기
      ..strokeCap = StrokeCap.round // 선의 끝을 둥글게
      ..strokeWidth = 1; // 시침의 굵기

    // 시간 눈금을 그릴 Paint 객체 (현재 미사용 - 추후 구현 예정)
    // var dashBrush = Paint()
    //   ..color = CustomColors.clockOutline
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1;

    // ========== 시계 구성 요소 그리기 ==========
    
    // 1. 시계 배경 원 그리기
    // radius * 0.75: 전체 크기의 75% 크기로 원을 그립니다
    canvas.drawCircle(center, radius * 0.75, fillBrush);
    
    // 2. 시계 테두리 원 그리기
    // 배경 원과 같은 크기로 테두리만 그립니다
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    // ========== 시침 계산 및 그리기 ==========
    
    // 시침의 각도 계산
    // - dateTime.hour * 30: 시간당 30도 (360도 ÷ 12시간 = 30도)
    // - dateTime.minute * 0.5: 분당 0.5도 (30도 ÷ 60분 = 0.5도)
    // - 분을 고려하여 시침이 부드럽게 움직이도록 함
    // - * pi / 180: 도(degree)를 라디안(radian)으로 변환
    
    // 시침의 끝점 X 좌표 계산
    // centerX + radius * 0.4: 중심에서 반지름의 40% 길이만큼 떨어진 점
    // cos(): X축 방향의 좌표 계산
    var hourHandX = centerX + radius * 0.4 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    
    // 시침의 끝점 Y 좌표 계산
    // sin(): Y축 방향의 좌표 계산
    var hourHandY = centerY + radius * 0.4 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    
    // 시침 그리기: 중심점에서 계산된 끝점까지 선을 그립니다
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 항상 true를 반환하여 매번 다시 그리도록 합니다
    // 이는 시간이 변경될 때마다 시계가 업데이트되도록 하기 위함입니다
    // false를 반환하면 성능은 좋아지지만 시계가 업데이트되지 않습니다
    return true;
  }
}
