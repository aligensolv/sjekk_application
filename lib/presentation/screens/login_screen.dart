import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/user_model.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/providers/login_provider.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import '../../data/entities/auth_credentials.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
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
        backgroundColor: ThemeHelper.backgroundColor,
        body: Consumer<LoginProvider>(
          builder: (BuildContext context, LoginProvider loginProvider, Widget? child) {
            if(loginProvider.loadingState){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

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
                      padding: EdgeInsets.all(12.0),
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
                              SizedBox(
                                height: 12,
                              ),
                              SizedBox(height: 12.0), 
                              Text(
                                "Login to your Account",
                                style: TextStyle(
                                  color: ThemeHelper.textColor,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomTextFormField(
                                prefixIcon: Icons.perm_identity,
                                controller: _idController,
                                labelAndHint: 'ID',
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
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                prefixIcon: Icons.security,
                                controller: _passwordController,
                                labelAndHint: 'Password',
                                secure: true,
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
                              SizedBox(
                                height: 20.0,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: BasicButton(
                                  text: 'Login',
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
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => const HomeNavigatorScreen()
                                                )
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