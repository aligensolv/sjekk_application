import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/user_model.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/providers/login_provider.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import '../../data/entities/auth_credentials.dart';
import 'home_navigator_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldColor,
        body: Consumer<LoginProvider>(
          builder: (BuildContext context, LoginProvider loginProvider, Widget? child) {
            // if(loginProvider.loadingState){
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            if(loginProvider.errorState){
              if(context.mounted){
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  SnackbarUtils.showSnackbar(
                    context, loginProvider.errorMessage,
                    type: SnackBarType.failure
                  );
                });
              }
            }

            return Center(
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.kontroll,
                                scale: 2,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const SizedBox(height: 12.0), 
                              Text(
                                "Login to your Account",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SecondaryTemplateTextFieldWithIcon(
                                icon: Icons.perm_identity,
                                controller: _idController,
                                hintText: 'ID',
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return "Please enter something";
                                    }

                                    return null;
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SecondaryTemplateTextFieldWithIcon(
                                icon: Icons.security,
                                controller: _passwordController,
                                hintText: 'Password',
                                secured: true,
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return "Please enter something";
                                    }

                                    return null;
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: NormalTemplateButton(
                                  text: 'LOGIN',
                                  onPressed: () async {
                                    if (_formKey.currentState != null) {
                                      if (_formKey.currentState!.validate()) {

                                        AuthCredentials authCredentials =
                                            AuthCredentials(
                                                identifier: _idController.text,
                                                password:
                                                    _passwordController.text);

                                        User? user =
                                            await Provider.of<LoginProvider>(
                                                    context,
                                                    listen: false)
                                                .login(authCredentials);
                                        if (user != null) {
                                          if(context.mounted){
                                            final shiftProvider = Provider.of<ShiftProvider>(context,listen: false);
                                            bool startedNewShift = await shiftProvider.startNewShift(user.token.toString());
                                            if(!startedNewShift){
                                              SnackbarUtils.showSnackbar(context, 'Failed to start new shift',type: SnackBarType.failure);
                                              return;
                                            }
                                            final authProvider = Provider.of<AuthProvider>(context,listen: false);
                                            authProvider.provideAuthenticationState(user.token.toString(), user);
                                            Navigator.of(context).pushReplacementNamed(
                                              HomeNavigatorScreen.route
                                            );
                                          }
                                        } 
                                      } else {
                                        SnackbarUtils.showSnackbar(
                                            context, 'Fill Data First');
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ));
  }
}
