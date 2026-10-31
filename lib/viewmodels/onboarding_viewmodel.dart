import 'dart:async';

class OnboardingViewModel {
  Timer? _timer;


  void iniciarTemporizador(void Function() onFinished) {
    _timer = Timer(const Duration(seconds: 15), onFinished);
  }


  void cancelarTemporizador() {
    _timer?.cancel();
  }

  void dispose() {
    cancelarTemporizador();
  }
}