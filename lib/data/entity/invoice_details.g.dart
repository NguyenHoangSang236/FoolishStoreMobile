// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDetails _$InvoiceDetailsFromJson(Map<String, dynamic> json) =>
    InvoiceDetails(
      Invoice.fromJson(json['invoice'] as Map<String, dynamic>),
      (json['invoiceProducts'] as List<dynamic>)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceDetailsToJson(InvoiceDetails instance) =>
    <String, dynamic>{
      'invoice': instance.invoice,
      'invoiceProducts': instance.invoiceProducts,
    };
