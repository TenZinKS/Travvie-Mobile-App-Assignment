// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedTripModelAdapter extends TypeAdapter<SavedTripModel> {
  @override
  final int typeId = 2;

  @override
  SavedTripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedTripModel(
      id: fields[0] as String,
      from: fields[1] as String,
      to: fields[2] as String,
      numberOfPeople: fields[3] as int,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      itinerary: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedTripModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.to)
      ..writeByte(3)
      ..write(obj.numberOfPeople)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.itinerary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedTripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
