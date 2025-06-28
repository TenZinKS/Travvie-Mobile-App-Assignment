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
      title: fields[1] as String,
      destination: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      itinerary: fields[5] as String,
      isCompleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SavedTripModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.itinerary)
      ..writeByte(6)
      ..write(obj.isCompleted);
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
