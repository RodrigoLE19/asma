import 'package:equatable/equatable.dart';

class Evaluation extends Equatable{
  final double questionIMC;
  final int? questionWheezing;
  final int? questionShortnessOfBreath;
  final int? questionChestTightness;
  final int? questionCoughing;

  Evaluation({
    required this.questionIMC,
    required this.questionWheezing,
    required this.questionShortnessOfBreath,
    required this.questionChestTightness,
    required this.questionCoughing
  });

  Map<String, dynamic> toMap(){
    return {
      'questionIMC':questionIMC,
      'questionWheezing':questionWheezing,
      'questionShortnessOfBreath':questionShortnessOfBreath,
      'questionChestTightness':questionChestTightness,
      'questionCoughing':questionCoughing
    };
  }

  @override
  List<Object?> get props => [
    questionIMC,
    questionWheezing,
    questionShortnessOfBreath,
    questionChestTightness,
    questionCoughing
  ];


}