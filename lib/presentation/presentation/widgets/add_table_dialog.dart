import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_texts.dart';
import '../cubit/table/table_cubit.dart';

class AddTableDialog extends StatefulWidget {
  const AddTableDialog({Key? key}) : super(key: key);

  @override
  State<AddTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<AddTableDialog> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppTexts.addTable),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _numberController,
          decoration: const InputDecoration(
            labelText: AppTexts.tableNumber,
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppTexts.required;
            }
            if (int.tryParse(value) == null) {
              return AppTexts.invalidInput;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppTexts.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<TableCubit>().addNewTable(_numberController.text);
              Navigator.pop(context);
            }
          },
          child: const Text(AppTexts.save),
        ),
      ],
    );
  }
}