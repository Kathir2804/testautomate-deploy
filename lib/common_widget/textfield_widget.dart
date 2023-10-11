import 'package:cez_tower/styles/styles.dart';
import 'package:flutter/material.dart';

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget(
      {Key? key,
      required this.companyIdController,
      required this.form,
      required this.validate,
      this.onChanged,
      this.onTap,
      required this.emailStyle,
      required this.emailValid,
      required this.userIcon,
      required this.filled,
      required this.focusNode,
      required this.onFieldSubmitted})
      : super(key: key);

  final TextEditingController companyIdController;
  final Key form;
  final void Function(String)? onChanged;
  final FormFieldValidator<String> validate;
  final Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final bool emailStyle;
  final bool emailValid;
  final bool filled;
  final bool userIcon;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: TextFormField(
        focusNode: focusNode,
        autofillHints: const [AutofillHints.email],
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: emailValid ? 'Email Address' : 'Enter valid email id',
          labelStyle: const TextStyle(color: Neutral.n60),
          floatingLabelStyle: emailValid == false
              ? const TextStyle(color: Colors.red)
              : emailStyle
                  ? const TextStyle(color: Neutral.n60)
                  : const TextStyle(color: Primary.primary400),
          errorStyle: const TextStyle(height: 0),
          fillColor: const Color.fromARGB(255, 255, 251, 213),
          filled: filled,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Error.error500),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Error.error500),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Neutral.n60),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Primary.primary400),
          ),
          prefixIcon: const Icon(Icons.person),
        ),
        onTap: onTap,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validate,
        controller: companyIdController..text,
        cursorColor: Colors.black,
      ),
    );
  }
}

class PasswordTextFieldWidget extends StatefulWidget {
  const PasswordTextFieldWidget(
      {Key? key,
      required this.formKey,
      required this.passwordController,
      this.onChanged,
      this.onTap,
      required this.passwordStyle,
      required this.filled,
      required this.onFieldSubmitted,
      required this.focusNode,
      required this.passwordValid,
      required this.validate,
      required this.eyeFocus,
      required this.keyIcon})
      : super(key: key);
  final Function(String)? onFieldSubmitted;
  final TextEditingController passwordController;
  final void Function(String)? onChanged;
  final bool passwordStyle;
  final void Function()? onTap;
  final FormFieldValidator<String> validate;
  final bool filled;
  final bool passwordValid;
  final bool keyIcon;
  final FocusNode focusNode;
  final FocusNode eyeFocus;
  final Key formKey;

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        focusNode: widget.focusNode,
        autofillHints: const [AutofillHints.password],
        obscureText: _isObscure,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Neutral.n60),
          // ignore: unnecessary_null_comparison
          floatingLabelStyle: widget.passwordValid == false
              ? const TextStyle(color: Colors.red)
              : widget.passwordStyle
                  ? const TextStyle(color: Neutral.n60)
                  : const TextStyle(color: Primary.primary400),
          errorStyle: const TextStyle(height: 0),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Error.error500),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Error.error500),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Neutral.n60),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Primary.primary400),
          ),
          prefixIcon: const Icon(Icons.key),
          filled: widget.filled,
          fillColor: const Color.fromARGB(255, 255, 251, 213),
          suffixIcon: IconButton(
            focusNode: widget.eyeFocus,
            icon: _isObscure
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility_outlined),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          suffixIconColor: Neutral.n60,
        ),
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        validator: widget.validate,
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.passwordController..text,
        cursorColor: Colors.black,
      ),
    );
    // );
  }
}
