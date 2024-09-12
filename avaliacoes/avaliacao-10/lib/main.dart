import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validation Form',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Validation Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MyForm(),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  late String _date;
  late String _email;
  late String _cpf;
  String? _value; // Alterado para permitir valores nulos

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Data (dd-mm-yyyy)'),
              validator: (value) {
                if (!isValidDate(value ?? '')) {
                  return 'Invalid date format or date is not valid';
                }
                return null;
              },
              onSaved: (value) => _date = value ?? '', // Garantir que _date não seja nulo
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (!isValidEmail(value ?? '')) {
                  return 'Invalid email format';
                }
                return null;
              },
              onSaved: (value) => _email = value ?? '', // Garantir que _email não seja nulo
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'CPF'),
              validator: (value) {
                if (!isValidCPF(value ?? '')) {
                  return 'Invalid CPF';
                }
                return null;
              },
              onSaved: (value) => _cpf = value ?? '', // Garantir que _cpf não seja nulo
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor'),
              validator: (value) {
                if (!isValidValue(value ?? '')) {
                  return 'Invalid value';
                }
                return null;
              },
              onSaved: (value) => _value = value, // Pode ser nulo
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  // Form is valid, you can now use the validated values
                  print('Date: $_date, Email: $_email, CPF: $_cpf, Value: ${_value ?? 'Not provided'}');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Validation functions
bool isValidDate(String date) {
  if (date.isEmpty) return false;
  var parts = date.split('-');
  if (parts.length != 3) return false;
  var day = int.tryParse(parts[0]);
  var month = int.tryParse(parts[1]);
  var year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return false;
  if (day < 1 || day > 31) return false;
  if (month < 1 || month > 12) return false;
  if (year < 1900 || year > 2100) return false;
  return true;
}

bool isValidEmail(String email) {
  if (email.isEmpty) return false;
  var emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return emailRegex.hasMatch(email);
}

bool isValidCPF(String cpf) {
  if (cpf.isEmpty) return false;
  var cpfRegex = RegExp(r"^[0-9]{11}$");
  if (!cpfRegex.hasMatch(cpf)) return false;
  var sum = 0;
  var weight = 10;
  for (var i = 0; i < 9; i++) {
    sum = sum + int.parse(cpf[i]) * weight;
    weight = weight - 1;
  }
  var verifyingDigit = 11 - (sum % 11);
  if (verifyingDigit > 9) verifyingDigit = 0;
  if (verifyingDigit != int.parse(cpf[9])) return false;
  sum = 0;
  weight = 11;
  for (var i = 0; i < 10; i++) {
    sum = sum + int.parse(cpf[i]) * weight;
    weight = weight - 1;
  }
  verifyingDigit = 11 - (sum % 11);
  if (verifyingDigit > 9) verifyingDigit = 0;
  if (verifyingDigit != int.parse(cpf[10])) return false;
  return true;
}

bool isValidValue(String value) {
  if (value.isEmpty) return false;
  var valueRegex = RegExp(r"^[0-9]+(\.[0-9]+)?$");
  return valueRegex.hasMatch(value);
}
