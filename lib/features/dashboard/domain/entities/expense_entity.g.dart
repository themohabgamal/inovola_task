// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseEntityAdapter extends TypeAdapter<ExpenseEntity> {
  @override
  final int typeId = 0;

  @override
  ExpenseEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseEntity(
      title: fields[0] as String,
      category: fields[1] as String,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      iconName: fields[4] as String?,
      time: fields[6] as String?,
      currency: fields[7] as String?,
      convertedAmount: fields[8] as double?,
      exchangeRate: fields[9] as double?,
      receiptPath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.iconName)
      ..writeByte(5)
      ..write(obj.backgroundColorHex)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.convertedAmount)
      ..writeByte(9)
      ..write(obj.exchangeRate)
      ..writeByte(10)
      ..write(obj.receiptPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
