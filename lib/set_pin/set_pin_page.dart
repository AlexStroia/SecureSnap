import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_snap/app.dart';
import 'package:secure_snap/set_pin/controller/set_pin_controller.dart';
import 'package:secure_snap/utils/controller_registrar.dart';

import '../l10n/l10n.dart';

class SetPinPage extends StatelessWidget {
  final SetPinArgs args;

  const SetPinPage({required this.args, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return ControllerRegistrar(
      create: (context, dependencyContext) {
        return SetPinController(
          secureStorageRepository: dependencyContext(),
          biometricService: dependencyContext(),
        );
      },

      builder: (context, controller, child) {
        return _PageContent(controller: controller);
      },
      listener: (controller) {
        final event = controller.removeEvent();

        switch (event) {
          case PinSaveSuccess _:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.pin_saved)));
            context.pop();
            break;
          case PinSaveException _:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.general_error)));
            break;
        }
        if (event is PinSaveException) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.general_error)));
        }
      },
    );
  }
}

class _PageContent extends StatefulWidget {
  const _PageContent({required this.controller});

  final SetPinController controller;

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  late final _controller = widget.controller;
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _errorText;

  Future<void> _savePin() async {
    if (_formKey.currentState?.validate() != true) return;

    _controller.savePin(_pinController.text);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.set_pin)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.create_pin,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: l10n.enter_pin,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return l10n.pin_6_digits;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: l10n.confirm_pin,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _pinController.text) {
                      return l10n.pin_not_match;
                    }
                    return null;
                  },
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(_errorText!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _controller.isLoading ? null : _savePin,
                  child:
                      _controller.isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.save_pin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
