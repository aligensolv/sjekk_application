import 'package:audioplayers/audioplayers.dart';

Future playCorrectSound() async{
  AudioPlayer audioPlayer = AudioPlayer();
  await audioPlayer.setVolume(1);                    
  await audioPlayer.play(AssetSource('sounds/correct.wav'));
}

Future playWrongSound() async{
  AudioPlayer audioPlayer = AudioPlayer();
  await audioPlayer.setVolume(1);                    
  await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
}