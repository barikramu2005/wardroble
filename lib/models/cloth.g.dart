// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothAdapter extends TypeAdapter<Cloth> {
  @override
  final int typeId = 1;

  @override
  Cloth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cloth(
      type: fields[0] as String,
      category: fields[1] as String,
      color: fields[2] as String,
      imagePath: fields[3] as String,
      maxUses: fields[5] as int,
      usedCount: fields[4] as int,
      state: fields[6] as ClothState,
      preferenceScore: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Cloth obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.usedCount)
      ..writeByte(5)
      ..write(obj.maxUses)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.preferenceScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClothStateAdapter extends TypeAdapter<ClothState> {
  @override
  final int typeId = 0;

  @override
  ClothState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ClothState.ready;
      case 1:
        return ClothState.needWash;
      case 2:
        return ClothState.needIron;
      default:
        return ClothState.ready;
    }
  }

  @override
  void write(BinaryWriter writer, ClothState obj) {
    switch (obj) {
      case ClothState.ready:
        writer.writeByte(0);
        break;
      case ClothState.needWash:
        writer.writeByte(1);
        break;
      case ClothState.needIron:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
