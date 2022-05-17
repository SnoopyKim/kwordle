// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 1;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History(
      isClear: fields[0] as bool,
      word: fields[1] as String,
      letters: fields[2] as String,
      definition: fields[3] as String,
      history: (fields[4] as List)
          .map((dynamic e) => (e as List)
              .map((dynamic e) => (e as Map).cast<String, dynamic>())
              .toList())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isClear)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.letters)
      ..writeByte(3)
      ..write(obj.definition)
      ..writeByte(4)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
