import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List propersies;
  Failure([this.propersies = const <dynamic>[]]);

  @override
  List<Object> get props => [propersies];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure{}
