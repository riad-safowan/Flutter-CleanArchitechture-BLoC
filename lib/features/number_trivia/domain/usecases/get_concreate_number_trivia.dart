import 'package:clean_architecture_block/core/errors/failures.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';

class GetConcreteNumberTrivia extends Usecase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
  
}


