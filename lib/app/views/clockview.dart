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
import '../utils/app_logger.dart';

// 전역 로거 인스턴스 - 앱 전체에서 로그를 출력할 때 사용
final talker = Talker();

/// ClockView - 실시간으로 업데이트되는 아날로그 시계 위젯
///
/// 이 위젯은 현재 시간을 아날로그 시계 형태로 표시하며,
/// 매초마다 자동으로 업데이트됩니다.
///
/// 주요 기능:
/// - 실시간 시계 표시 (시침, 분침 포함)
/// - 커스텀 디자인과 색상 적용
/// - 크기 조절 가능
/// - 메모리 누수 방지를 위한 타이머 정리
class ClockView extends StatefulWidget {
  const ClockView({super.key, this.size});

  // 시계의 크기를 지정하는 선택적 매개변수
  // null이면 부모 위젯의 크기에 맞춰집니다
  final double? size;

  @override
  State<ClockView> createState() => _ClockViewState();
}

/// _ClockViewState - ClockView 위젯의 상태 관리 클래스
///
/// 이 클래스는 시계의 실시간 업데이트를 담당합니다.
/// Timer를 사용하여 매초마다 setState()를 호출하여 화면을 다시 그립니다.
class _ClockViewState extends State<ClockView> {
  // 매초마다 위젯을 업데이트하는 타이머
  // late 키워드: 초기화는 나중에 하지만 사용 전에는 반드시 초기화됨을 보장
  late Timer timer;

  @override
  void initState() {
    AppLogger.debug('ClockView initializing with size: ${widget.size}', 'CLOCK_VIEW');

    // 위젯이 생성될 때 타이머를 시작합니다
    // Duration(seconds: 1): 1초마다 실행
    // setState(() {}): 화면을 다시 그리도록 Flutter에게 알림
    this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // 빈 setState - 시간이 변경되었으므로 CustomPainter가 다시 그려집니다
      });
    });

    AppLogger.info('ClockView timer started', 'CLOCK_VIEW');
    super.initState();
  }

  @override
  void dispose() {
    AppLogger.debug('ClockView disposing', 'CLOCK_VIEW');
    // 위젯이 제거될 때 타이머를 정리하여 메모리 누수를 방지합니다
    // 이는 매우 중요한 부분으로, 이를 생략하면 앱이 종료되어도 타이머가 계속 실행될 수 있습니다
    this.timer.cancel();
    AppLogger.info('ClockView timer cancelled', 'CLOCK_VIEW');
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

/// ClockPainter - 시계의 실제 그리기를 담당하는 CustomPainter 클래스
///
/// 이 클래스는 Canvas API를 사용하여 시계의 모든 구성 요소를 그립니다:
/// - 시계 배경 원
/// - 시계 테두리
/// - 시침 (hour hand)
/// - 분침 (minute hand)
/// - 초침 (second hand) - 현재 미구현
/// - 중앙 점 - 현재 미구현
/// - 시간 눈금 - 현재 미구현
class ClockPainter extends CustomPainter {
  // 현재 시간을 가져옵니다 - paint 메서드가 호출될 때마다 최신 시간으로 업데이트
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    AppLogger.debug(
      'ClockPainter painting at ${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
      'CLOCK_PAINTER',
    );

    // === 1. 기본 좌표 및 크기 계산 ===
    // 캔버스의 중심점을 계산합니다
    var centerX = size.width / 2; // 가로 중심점
    var centerY = size.height / 2; // 세로 중심점
    var center = Offset(centerX, centerY); // 중심점을 Offset 객체로 생성
    // 시계의 반지름: 가로/세로 중 작은 값을 사용하여 정원 형태 보장
    var radius = min(centerX, centerY);

    // === 2. 페인트 브러시 설정 ===
    // 시계 배경을 칠하는 브러시 (채우기 스타일)
    var fillBrush = Paint()..color = CustomColors.clockBG;

    // 시계 외곽선을 그리는 브러시 (테두리 스타일)
    var outlineBrush = Paint()
      ..color = CustomColors.clockOutline
      ..style = PaintingStyle
          .stroke // 채우기가 아닌 선 그리기
      ..strokeWidth = size.width / 20; // 테두리 두께: 전체 너비의 1/20

    // 시계 중앙 점을 그리는 브러시
    var centerDotBrush = Paint()..color = CustomColors.clockOutline;

    // 초침을 그리는 브러시 (가장 얇고 빨간색)
    var secHandBrush = Paint()
      ..color = CustomColors.secHandColor!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap
          .round // 선 끝을 둥글게
      ..strokeWidth = size.width / 60; // 가장 얇은 두께

    // 분침을 그리는 브러시 (그라디언트 효과 적용)
    var minHandBrush = Paint()
      ..shader = RadialGradient(
        // 중심에서 바깥쪽으로 색상이 변하는 방사형 그라디언트
        colors: [CustomColors.minHandStatColor, CustomColors.minHandEndColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 30; // 중간 두께

    // 시침을 그리는 브러시 (가장 굵고 그라디언트 효과)
    var hourHandBrush = Paint()
      ..shader = RadialGradient(
        colors: [CustomColors.hourHandStatColor, CustomColors.hourHandEndColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 24; // 가장 굵은 두께

    // 시간 눈금(12개 선)을 그리는 브러시
    var dashBrush = Paint()
      ..color = CustomColors.clockOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // 가장 얇은 선

    // === 3. 시계 배경 및 테두리 그리기 ===
    // 시계 배경원: 전체 반지름의 75% 크기로 그리기
    canvas.drawCircle(center, radius * 0.75, fillBrush);
    // 시계 테두리원: 배경과 같은 크기로 외곽선만 그리기
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    // === 4. 시침 그리기 ===
    // 시침 각도 계산: (시간 * 30도) + (분 * 0.5도)
    // - 시간: 12시간 = 360도이므로 1시간 = 30도
    // - 분: 60분 = 30도(시침이 한 시간 동안 움직이는 각도)이므로 1분 = 0.5도
    var hourHandX =
        centerX +
        radius *
            0.4 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY =
        centerY +
        radius *
            0.4 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    // 중심점에서 계산된 끝점까지 선을 그어 시침 완성
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // === 5. 분침 그리기 ===
    // 분침 각도 계산: 분 * 6도 (60분 = 360도이므로 1분 = 6도)
    var minHandX = centerX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + radius * 0.6 * sin(dateTime.minute * 6 * pi / 180);
    // 시침보다 긴 길이(반지름의 60%)로 분침 그리기
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    // === 6. 초침 그리기 ===
    // 초침 각도 계산: 초 * 6도 (60초 = 360도이므로 1초 = 6도)
    var secHandX = centerX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.6 * sin(dateTime.second * 6 * pi / 180);
    // 분침과 같은 길이로 초침 그리기
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    // === 7. 중앙 점 그리기 ===
    // 모든 바늘이 만나는 중심점을 작은 원으로 표시
    canvas.drawCircle(center, radius * 0.12, centerDotBrush);

    // === 8. 시간 눈금 그리기 ===
    // 12개의 시간 눈금을 그리기 위한 준비
    var outerRadius = radius; // 바깥쪽 반지름 (시계 테두리까지)
    var innerRadius = radius * 0.9; // 안쪽 반지름 (눈금 길이 결정)

    // 0도부터 360도까지 12도씩 증가하며 총 30개의 눈금 그리기
    // (12도 간격 = 360도 ÷ 30 = 12도, 즉 30개 눈금)
    for (var i = 0; i < 360; i += 12) {
      // 바깥쪽 점 좌표 계산 (시계 테두리)
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerY + outerRadius * sin(i * pi / 180);

      // 안쪽 점 좌표 계산 (눈금의 안쪽 끝)
      var x2 = centerX + innerRadius * cos(i * pi / 180);
      var y2 = centerY + innerRadius * sin(i * pi / 180);

      // 바깥쪽 점에서 안쪽 점까지 선을 그어 눈금 완성
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 항상 true를 반환하여 매번 다시 그리도록 합니다
    // 이는 시간이 변경될 때마다 시계가 업데이트되도록 하기 위함입니다
    // false를 반환하면 성능은 좋아지지만 시계가 업데이트되지 않습니다
    return true;
  }
}
