import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_snap/enter_pin/controller/enter_pin_controller.dart';
import 'package:secure_snap/utils/frame_binding_mixin.dart';

import '../app.dart';
import '../l10n/l10n.dart';
import '../utils/controller_registrar.dart';

class EnterPinPage extends StatelessWidget {
  final EnterPinArgs args;

  const EnterPinPage({required this.args, super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerRegistrar(
      create: (context, dependencyContext) {
        return EnterPinController(
          secureStorageRepository: dependencyContext(),
          database: dependencyContext(),
        );
      },

      builder: (context, controller, child) {
        return _PageContent(controller: controller);
      },
      listener: (controller) {
        final event = controller.removeEvent();
        switch (event) {
          case PinCorrect _:
            context.pop();
            break;
          case PinIncorrect _:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  L10n.of(context).pin_incorrect(controller.pinAttempts),
                ),
              ),
            );
            break;
          case PinNotAvailable _:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(L10n.of(context).pin_not_available)),
            );
            context.push('/home/set-pin');
            break;
          case PinBlocked _:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(L10n.of(context).pin_blocked)),
            );
            context.go('/home');
            break;
        }
      },
    );
  }
}

class _PageContent extends StatefulWidget {
  const _PageContent({required this.controller});

  final EnterPinController controller;

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> with FrameBinding {
  late final _controller = widget.controller;
  final TextEditingController _pinController = TextEditingController();

  @override
  void didRenderFrame() {
    super.didRenderFrame();
    _controller.checkPinAvailability();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 72, color: Colors.black54),
              const SizedBox(height: 16),
              Text(
                l10n.enter_pin,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: '••••••',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _controller.isLoading ? null : _checkPin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _controller.isLoading
                        ? const CircularProgressIndicator()
                        : Text(l10n.unlock, style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkPin() => _controller.checkPin(_pinController.text);
}
