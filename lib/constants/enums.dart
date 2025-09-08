import 'package:flutter/foundation.dart';

/// enums used in model classes.
enum ShippingClass {
  NORMAL,
  ONE_DAY,
}

enum ProductStatus {
  DRAFT, //상품 준비중
  READY, //판매 가능
  HOLD, //판매 대기
  SOLD_OUT, //품절
  DISCONTINUED, //판매 종료
  HIDDEN, //판매 중지
  DELETED, //삭제
  UNDER_ADMISSION, //승인 대기
  REJECTION, //판매 금지
}

enum PaymentType { CREDITCARD }

enum PaymentTransactionType {
  INIT,
  AUTHORIZE,
  CAPTURE,
  AUTHORIZE_CAPTURE,
  REFUND,
  ERROR
}

enum OrderAttributeKey { SHIPPING_MEMO }

enum ProductOrderStatus {
  PAYMENT_WAITING,
  PAID,
  NATIONAL_DELIVERING,
  NATIONAL_DELIVERED,
  INTERNATIONAL_DELIVERING,
  DELIVERED,
  PURCHASE_DECIDED,
  CANCELED,
  RETURNED
}

enum ProductOrderDetailStatus {
  PAYMENT_WAITING,
  PAID,
  PRODUCT_PREPARING,
  PREPARE_CANCELED,
  DELIVERY_PREPARING,
  NATIONAL_DELIVERING,
  INTERNATIONAL_DELIVERY_PREPARING,
  INTERNATIONAL_DELIVERING,
  DELIVERED,
  PURCHASE_DECIDED,
  CANCELED,
  RETURNED
}

enum ClaimStatus {
  CANCEL_REQUEST,
  CANCELING,
  CANCEL_DONE,
  CANCEL_REJECT,
  RETURN_REQUEST,
  RETURN_DONE,
  RETURN_REJECT,
  COLLECTING,
  COLLECT_DONE,
  EXCHANGE_REQUEST,
  EXCHANGE_REDELIVERING,
  EXCHANGE_DONE,
  EXCHANGE_REJECT,
  PURCHASE_DECISION_REQUEST,
  PURCHASE_DECISION_HOLDBACK,
  PURCHASE_DECISION_HOLDBACK_RELEASE,
  ADMIN_CANCELING,
  ADMIN_CANCEL_DONE,
  ADMIN_CANCEL_REJECT
}

enum ShoppingCartItemStatus {AVAILABLE, OUT_OF_STOCK, UNAVAILABLE}

enum PlaceStatus { NOT_YET, OK, CANCEL }

enum PlaceOrderStatus { NOT_YET, OK, CANCEL }

enum DeliveryMethod { DELIVERY, VISIT_RECEIPT, STOCK_CARGO }

enum ShippingType { NATIONAL, INTERNATIONAL }

enum DeliveryStatus {
  COLLECT_REQUESTED,
  COLLECT_WAIT,
  COLLECT_CARGO,
  DELIVERING,
  DELIVERY_COMPLETION,
  DELIVERY_FAIL,
  WRONG_INVOICE,
  NOT_TRACKING
}

enum InternationalDeliveryMethod { AIR }

// 길이 단위
enum SizeUnit { CM, IN }

// 무게 단위
enum WeightUnit { KG, LB }

// 주문 가격 종류
enum OrderTotalType {
  SHIPPING,
  HANDLING,
  TAX,
  ITEM,
  SUBTOTAL,
  DISCOUNT,
  TOTAL,
  STORE_TOTAL,
  CREDIT,
  REFUND
}

// used in order.dart
enum ShippingTypeDummy {
  local,
  global,
  arrived,
  canceled,
  acceptCancellation,
  acceptReturn
}

enum VatType {
  GENERAL,
  FREE,
  ZERO,
}

// 가격정보 페이지별 분류
enum PriceInfo {
  // Mypage 주문 상세 - 결제정보
  ORDER_DETAIL,
  // 장바구니 - 결제정보
  CART,
  // 주문/결제 - 최종 결제금액
  PAYMENT,
  // 결제 완료 - 최종 결제금액
  ORDER_COMPLETE,
}

class EnumUtils {
  static String enumToString(Object enumValue) {
    return describeEnum(enumValue);
  }

  static T enumFromString<T>(String value, List<T> values) {
    final enumVal = values.firstWhere(
      (enumValue) => enumValue.toString().contains(value),
      orElse: () => throw ArgumentError('Invalid enum value: $value'),
    );
    return enumVal;
  }
}
