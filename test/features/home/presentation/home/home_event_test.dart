import 'package:expense_manager/features/home/presentation/home/bloc/home_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HomeLoadData events are equal', () {
    expect(const HomeLoadData(), const HomeLoadData());
  });
}
