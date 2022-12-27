part of 'mim_generator_cubit.dart';

abstract class MimGeneratorState extends Equatable {
  const MimGeneratorState();

  @override
  List<Object> get props => [];
}

class MimGeneratorInitial extends MimGeneratorState {}

class MimGeneratorLoading extends MimGeneratorState {}

class MimGeneratorLoaded extends MimGeneratorState {
  final MimModel mimModel;
  const MimGeneratorLoaded(this.mimModel);
  @override
  List<Object> get props => [mimModel];
}

class MimGeneratorFailed extends MimGeneratorState {
  final String message;
  const MimGeneratorFailed(this.message);
  @override
  List<Object> get props => [message];
}
