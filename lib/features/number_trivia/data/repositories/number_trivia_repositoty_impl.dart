import 'package:clean_architecture_block/core/errors/exceptions.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_block/core/errors/failures.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../datasources/local/number_trivia_local_datasource.dart';
import '../datasources/remote/number_trivia_remote_datasource.dart';
import '../models/number_trivia_model.dart';

typedef Future<NumberTriviaModel> _GetConcreteOrNumberTrivia();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getNumberTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getNumberTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      _GetConcreteOrNumberTrivia getConcreteOrNumberTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrNumberTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
