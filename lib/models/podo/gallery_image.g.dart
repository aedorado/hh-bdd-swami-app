// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GalleryImageAdapter extends TypeAdapter<GalleryImage> {
  @override
  final int typeId = 2;

  @override
  GalleryImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GalleryImage(
      id: fields[0] as String,
      albumID: fields[1] as String,
      color: fields[2] as String,
      date: fields[3] as String,
      description: fields[4] as String,
      displayURL: fields[5] as String,
      downloadURL: fields[6] as String,
      thumbnailURL: fields[7] as String,
      location: fields[8] as String,
      tags: fields[9] as String,
      type: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GalleryImage obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.albumID)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.displayURL)
      ..writeByte(6)
      ..write(obj.downloadURL)
      ..writeByte(7)
      ..write(obj.thumbnailURL)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
