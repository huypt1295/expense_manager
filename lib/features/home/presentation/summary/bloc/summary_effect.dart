import 'package:flutter_core/flutter_core.dart';

sealed class SummaryEffect extends Effect {
  const SummaryEffect();
}

class SummaryShowErrorEffect extends SummaryEffect {
  const SummaryShowErrorEffect(this.message);

  final String message;
}
