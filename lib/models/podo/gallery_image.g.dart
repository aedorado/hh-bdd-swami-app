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
     date: fields[1] as String,
     description: fields[2] as String,
     displayURL: fields[3] as String,
     downloadURL: fields[4] as String,
     thumbnailURL: fields[5] as String,
     tags: fields[6] as String,
   )
     ..subcategory = fields[7] as String
     ..isRss = fields[8] as bool
     ..order = fields[9] as int;
 }

 @override
 void write(BinaryWriter writer, GalleryImage obj) {
   writer
     ..writeByte(10)
     ..writeByte(0)
     ..write(obj.id)
     ..writeByte(1)
     ..write(obj.date)
     ..writeByte(2)
     ..write(obj.description)
     ..writeByte(3)
     ..write(obj.displayURL)
     ..writeByte(4)
     ..write(obj.downloadURL)
     ..writeByte(5)
     ..write(obj.thumbnailURL)
     ..writeByte(6)
     ..write(obj.tags)
     ..writeByte(7)
     ..write(obj.subcategory)
     ..writeByte(8)
     ..write(obj.isRss)
     ..writeByte(9)
     ..write(obj.order);
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


