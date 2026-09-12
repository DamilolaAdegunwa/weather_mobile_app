import 'package:flutter_test/flutter_test.dart';
import 'package:weather_mobile_app/app.dart';
import 'package:weather_mobile_app/data/repositories/weather_repository_impl.dart';

void main() {
  testWidgets('Aether Weather App smoke test & shell load', (WidgetTester tester) async {
    final repo = WeatherRepositoryImpl();
    await tester.pumpWidget(AetherWeatherApp(weatherRepository: repo));
    // Pump frames to allow initial state to render without hanging on infinite animations
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Brand title is visible
    expect(find.text('Aether'), findsOneWidget);
    // Verify navigation tabs are present
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Radar'), findsOneWidget);
    expect(find.text('7-Day'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
  });
}
