// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final int typeId = 3;

  @override
  Quote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      id: fields[0] as String,
      url: fields[1] as String,
      text: fields[2] as String,
      place: fields[3] as String,
      temple: fields[4] as String,
      location: fields[5] as String,
      date: fields[6] as String,
    )..order = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.place)
      ..writeByte(4)
      ..write(obj.temple)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
