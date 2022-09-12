import 'dart:convert';
import 'package:clean_architecture_block/features/number_trivia/data/datasources/remote/http_service.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final client = HttpService();

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('$number/trivia?json');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('random/trivia?json');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.getRequest(url);

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}