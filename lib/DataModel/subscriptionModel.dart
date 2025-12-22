class SubscriptionModel {
  final int? id;
  final String? userId;
  final int? planId;
  final String? planName;
  final String? status;
  final String? startDate;
  final String? expiryDate;
  final String? renewalDate;
  final String? billingCycle;
  final String? amount;
  final String? currency;
  final bool? autoRenew;
  final String? paymentMethod;
  final String? createdAt;
  final String? updatedAt;

  SubscriptionModel({
    this.id,
    this.userId,
    this.planId,
    this.planName,
    this.status,
    this.startDate,
    this.expiryDate,
    this.renewalDate,
    this.billingCycle,
    this.amount,
    this.currency,
    this.autoRenew,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      userId: json['user_id']?.toString(),
      planId: json['plan_id'],
      planName: json['plan_name'] ?? json['name'],
      status: json['status'],
      startDate: json['start_date'] ?? json['started_at'],
      expiryDate: json['expiry_date'] ?? json['expires_at'] ?? json['end_date'],
      renewalDate: json['renewal_date'] ?? json['next_billing_date'],
      billingCycle: json['billing_cycle'] ?? json['invoice_period'],
      amount: json['amount']?.toString() ?? json['price']?.toString(),
      currency: json['currency'] ?? 'USD',
      autoRenew: json['auto_renew'] ?? json['is_recurring'] ?? true,
      paymentMethod: json['payment_method'] ?? json['gateway'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_id': planId,
      'plan_name': planName,
      'status': status,
      'start_date': startDate,
      'expiry_date': expiryDate,
      'renewal_date': renewalDate,
      'billing_cycle': billingCycle,
      'amount': amount,
      'currency': currency,
      'auto_renew': autoRenew,
      'payment_method': paymentMethod,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper method to check if subscription is active
  bool get isActive {
    if (status == null) return false;
    return status!.toLowerCase() == 'active' ||
        status!.toLowerCase() == 'trial';
  }

  // Helper method to check if subscription is in trial period
  bool get isTrial {
    if (status == null) return false;
    return status!.toLowerCase() == 'trial';
  }

  // Helper method to get days remaining
  int? get daysRemaining {
    if (expiryDate == null) return null;
    try {
      final expiry = DateTime.parse(expiryDate!);
      final now = DateTime.now();
      final difference = expiry.difference(now);
      return difference.inDays;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get formatted expiry date
  String get formattedExpiryDate {
    if (expiryDate == null) return 'N/A';
    try {
      final expiry = DateTime.parse(expiryDate!);
      return '${_monthName(expiry.month)} ${expiry.day}, ${expiry.year}';
    } catch (e) {
      return expiryDate!;
    }
  }

  // Helper method to get formatted start date
  String get formattedStartDate {
    if (startDate == null) return 'N/A';
    try {
      final start = DateTime.parse(startDate!);
      return '${_monthName(start.month)} ${start.day}, ${start.year}';
    } catch (e) {
      return startDate!;
    }
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
