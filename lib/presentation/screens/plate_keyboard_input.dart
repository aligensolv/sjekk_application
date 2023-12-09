import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/providers/keyboard_input_provider.dart';
import 'package:sjekk_application/presentation/screens/place_home.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
// import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../providers/create_violation_provider.dart';
import 'plate_result_controller.dart';

class PlateKeyboardInputScreen extends StatefulWidget {
  const PlateKeyboardInputScreen({super.key});

  @override
  State<PlateKeyboardInputScreen> createState() => _PlateKeyboardInputScreenState();
}

class _PlateKeyboardInputScreenState extends State<PlateKeyboardInputScreen> {
    Future<bool> keyboardInputInterceptor(bool stopDefaultButtonEvent, RouteInfo info) async{
      context.read<KeyboardInputProvider>().clearPlate();

      return false;
    }

    @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(keyboardInputInterceptor, zIndex: 3);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(keyboardInputInterceptor);
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              KeyboardVisualInput(),
              SizedBox(height: 12,),
              Consumer<KeyboardInputProvider>(
                builder: (BuildContext context, KeyboardInputProvider keyboardInputProvider, Widget? child) { 
                  if(keyboardInputProvider.mode == KeyboardMode.letters){
                    return KeyboardLetters();
                  }

                  return KeyboardDigits();
                },
              ),
              Spacer(),
              NormalTemplateButton(
                onPressed: () async{
                  final keyboardProvider = context.read<KeyboardInputProvider>();
                  final createViolationProvider = context.read<CreateViolationProvider>();

                  await createViolationProvider.getCarInfo(keyboardProvider.plate); 
                  await createViolationProvider.getSystemCar(keyboardProvider.plate);

                  if(createViolationProvider.plateInfo == null){
                    SnackbarUtils.showSnackbar(
                      context, 
                      'Could not found this plate number'
                    );
                  }else{
                    keyboardProvider.clearPlate();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => PlateResultController()
                      ),
                      (route) => route.settings.name == PlaceHome.route
                    );
                  }
                }, 
                backgroundColor: Colors.green,
                width: double.infinity,
                text: 'COMPLETE',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class KeyboardVisualInput extends StatefulWidget {
  const KeyboardVisualInput({super.key});

  @override
  State<KeyboardVisualInput> createState() => _KeyboardVisualInputState();
}

class _KeyboardVisualInputState extends State<KeyboardVisualInput> {
  final TextEditingController visualController = TextEditingController();

  @override
  void dispose() {
    visualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KeyboardInputProvider>(
      builder: (BuildContext context, KeyboardInputProvider keyboardInputProvider, Widget? child) { 
        visualController.text = keyboardInputProvider.plate;
        return SecondaryTemplateTextField(
          hintText: '',
          disabled: true,
          controller: visualController,
          suffixIcon: Icon(
            Icons.close,
            size: 30,
            color: Colors.red,
          ),
          onPrefixIconTapped: (){
            Provider.of<KeyboardInputProvider>(context, listen: false).rollback();
          },
          onSuffixIconTapped: (){
            Provider.of<KeyboardInputProvider>(context, listen: false).clearPlate();
          },
          prefixIcon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black45,
          ),
        );
      },
    );
  }
}

class KeyboardLetterBox extends StatelessWidget {
  final String letter;
  VoidCallback? customAction;
  KeyboardLetterBox({super.key, required this.letter, this.customAction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: customAction ?? (){
        Provider.of<KeyboardInputProvider>(context, listen: false).updatePlate(letter);
      },
      child: Container(
        width: (size.width - 44) * 0.2,
        height: (size.width - 44) * 0.24,
        alignment: Alignment.center,
        color: primaryColor,
        child: Text(letter,style: TextStyle(
          fontSize: 34,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}

class KeyboardLetters extends StatelessWidget {
  KeyboardLetters({super.key});

  final List<String> letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ -".split('');

  @override
  Widget build(BuildContext context) {
    List<KeyboardLetterBox> boxes = letters.map((letter){
      return KeyboardLetterBox(letter: letter);
    }).toList();

    boxes.add(
      KeyboardLetterBox(
        letter: "123",
        customAction: (){
          context.read<KeyboardInputProvider>().changeMode(
            KeyboardMode.digits
          );
        },
      )
    );
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...boxes
      ],
    );
  }
}

class KeyboardDigitBox extends StatelessWidget {
  final String letter;
  VoidCallback? customAction;
  KeyboardDigitBox({super.key, required this.letter, this.customAction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: customAction ?? (){
        Provider.of<KeyboardInputProvider>(context, listen: false).updatePlate(letter);
      },
      child: Container(
        width: (size.width - 24 -  16) * 0.3333,
        height: (size.width - 44) * 0.3333,
        alignment: Alignment.center,
        color: primaryColor,
        child: Text(letter,style: TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}

class KeyboardDigits extends StatelessWidget {
  KeyboardDigits({super.key});

  final List<String> letters = "1234567890".split('');

  @override
  Widget build(BuildContext context) {
    List<KeyboardDigitBox> boxes = letters.map((letter){
      return KeyboardDigitBox(letter: letter);
    }).toList();

    boxes.add(
      KeyboardDigitBox(
        letter: "ABC",
        customAction: () {
          context.read<KeyboardInputProvider>().changeMode(
            KeyboardMode.letters
          );
        },
      )
    );
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...boxes
      ],
    );
  }
}