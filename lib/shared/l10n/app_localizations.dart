import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('th')];

  Map<String, String> get _strings =>
      locale.languageCode == 'th' ? _th : _en;

  String t(String key) => _strings[key] ?? _en[key] ?? key;

  // ── App ──────────────────────────────────────────────────────────────────
  String get appName => t('app_name');
  String get home => t('home');
  String get calculators => t('calculators');
  String get saved => t('saved');
  String get settings => t('settings');
  String get history => t('history');
  String get search => t('search');
  String get searchCalculators => t('search_calculators');
  String get recentCalculations => t('recent_calculations');
  String get favorites => t('favorites');
  String get noRecentCalculations => t('no_recent');
  String get noFavorites => t('no_favorites');
  String get noSavedPlans => t('no_saved');
  String get calculate => t('calculate');
  String get save => t('save');
  String get delete => t('delete');
  String get edit => t('edit');
  String get cancel => t('cancel');
  String get confirm => t('confirm');
  String get clearAll => t('clear_all');
  String get clearHistory => t('clear_history');
  String get results => t('results');
  String get inputs => t('inputs');

  // ── Calculators ──────────────────────────────────────────────────────────
  String get dcaCalculator => t('dca_calc');
  String get carLoanCalculator => t('car_loan_calc');
  String get homeLoanCalculator => t('home_loan_calc');
  String get savingGoalCalculator => t('saving_goal_calc');
  String get compoundInterestCalculator => t('compound_calc');

  String get dcaDescription => t('dca_desc');
  String get carLoanDescription => t('car_loan_desc');
  String get homeLoanDescription => t('home_loan_desc');
  String get savingGoalDescription => t('saving_goal_desc');
  String get compoundDescription => t('compound_desc');

  // ── DCA ──────────────────────────────────────────────────────────────────
  String get monthlyInvestment => t('monthly_investment');
  String get initialInvestment => t('initial_investment');
  String get expectedAnnualReturn => t('expected_annual_return');
  String get investmentPeriod => t('investment_period');
  String get annualContributionIncrease => t('annual_contribution_increase');
  String get totalPrincipal => t('total_principal');
  String get totalProfit => t('total_profit');
  String get futureValue => t('future_value');
  String get returnOnInvestment => t('return_on_investment');
  String get growthChart => t('growth_chart');
  String get years => t('years');
  String get months => t('months');
  String get optional => t('optional');

  // ── Loan ─────────────────────────────────────────────────────────────────
  String get carPrice => t('car_price');
  String get housePrice => t('house_price');
  String get downPayment => t('down_payment');
  String get interestRate => t('interest_rate');
  String get installmentMonths => t('installment_months');
  String get loanYears => t('loan_years');
  String get monthlyPayment => t('monthly_payment');
  String get totalPayment => t('total_payment');
  String get totalInterest => t('total_interest');
  String get loanAmount => t('loan_amount');
  String get paymentSchedule => t('payment_schedule');
  String get month => t('month');
  String get principal => t('principal');
  String get interest => t('interest');
  String get balance => t('balance');
  String get payment => t('payment');

  // ── Saving Goal ───────────────────────────────────────────────────────────
  String get targetAmount => t('target_amount');
  String get timeDuration => t('time_duration');
  String get monthlySaving => t('monthly_saving');
  String get weeklySaving => t('weekly_saving');
  String get dailySaving => t('daily_saving');
  String get timeToReach => t('time_to_reach');

  // ── Compound ─────────────────────────────────────────────────────────────
  String get initialAmount => t('initial_amount');
  String get compoundingFrequency => t('compounding_frequency');
  String get annually => t('annually');
  String get semiAnnually => t('semi_annually');
  String get quarterly => t('quarterly');
  String get monthly => t('monthly');
  String get totalGrowth => t('total_growth');

  // ── Settings ─────────────────────────────────────────────────────────────
  String get appearance => t('appearance');
  String get darkMode => t('dark_mode');
  String get lightMode => t('light_mode');
  String get systemDefault => t('system_default');
  String get language => t('language');
  String get currency => t('currency');
  String get about => t('about');
  String get privacyPolicy => t('privacy_policy');
  String get version => t('version');
  String get general => t('general');

  // ── Dialogs ───────────────────────────────────────────────────────────────
  String get saveCalculation => t('save_calculation');
  String get planName => t('plan_name');
  String get enterPlanName => t('enter_plan_name');
  String get savedSuccessfully => t('saved_successfully');
  String get deletedSuccessfully => t('deleted_successfully');
  String get confirmDelete => t('confirm_delete');
  String get confirmDeleteMsg => t('confirm_delete_msg');
  String get confirmClearHistory => t('confirm_clear_history');
  String get confirmClearHistoryMsg => t('confirm_clear_history_msg');

  // ── Errors ────────────────────────────────────────────────────────────────
  String get fieldRequired => t('field_required');
  String get invalidNumber => t('invalid_number');
  String get valueMustBePositive => t('value_must_be_positive');
  String get valueTooLarge => t('value_too_large');

  // ─────────────────────────────────────────────────────────────────────────
  static const Map<String, String> _en = {
    'app_name': 'Easy Finance',
    'home': 'Home',
    'calculators': 'Calculators',
    'saved': 'Saved',
    'settings': 'Settings',
    'history': 'History',
    'search': 'Search',
    'search_calculators': 'Search calculators...',
    'recent_calculations': 'Recent',
    'favorites': 'Favorites',
    'no_recent': 'No recent calculations',
    'no_favorites': 'No favorites yet',
    'no_saved': 'No saved plans yet',
    'calculate': 'Calculate',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'clear_all': 'Clear All',
    'clear_history': 'Clear History',
    'results': 'Results',
    'inputs': 'Inputs',

    'dca_calc': 'DCA Calculator',
    'car_loan_calc': 'Car Loan',
    'home_loan_calc': 'Home Loan',
    'saving_goal_calc': 'Saving Goal',
    'compound_calc': 'Compound Interest',
    'dca_desc': 'Dollar-cost average your investments',
    'car_loan_desc': 'Calculate car installment payments',
    'home_loan_desc': 'Plan your mortgage payments',
    'saving_goal_desc': 'Save towards a target amount',
    'compound_desc': 'Grow wealth with compound interest',

    'monthly_investment': 'Monthly Investment',
    'initial_investment': 'Initial Investment',
    'expected_annual_return': 'Expected Annual Return (%)',
    'investment_period': 'Investment Period',
    'annual_contribution_increase': 'Annual Contribution Increase (%)',
    'total_principal': 'Total Principal',
    'total_profit': 'Total Profit',
    'future_value': 'Future Value',
    'return_on_investment': 'Return on Investment',
    'growth_chart': 'Growth Chart',
    'years': 'years',
    'months': 'months',
    'optional': 'Optional',

    'car_price': 'Car Price',
    'house_price': 'House Price',
    'down_payment': 'Down Payment',
    'interest_rate': 'Interest Rate (% per year)',
    'installment_months': 'Installment (months)',
    'loan_years': 'Loan Period (years)',
    'monthly_payment': 'Monthly Payment',
    'total_payment': 'Total Payment',
    'total_interest': 'Total Interest',
    'loan_amount': 'Loan Amount',
    'payment_schedule': 'Payment Schedule',
    'month': 'Month',
    'principal': 'Principal',
    'interest': 'Interest',
    'balance': 'Balance',
    'payment': 'Payment',

    'target_amount': 'Target Amount',
    'time_duration': 'Time Duration',
    'monthly_saving': 'Monthly Saving',
    'weekly_saving': 'Weekly Saving',
    'daily_saving': 'Daily Saving',
    'time_to_reach': 'Time to Reach',

    'initial_amount': 'Initial Amount',
    'compounding_frequency': 'Compounding Frequency',
    'annually': 'Annually',
    'semi_annually': 'Semi-annually',
    'quarterly': 'Quarterly',
    'monthly': 'Monthly',
    'total_growth': 'Total Growth',

    'appearance': 'Appearance',
    'dark_mode': 'Dark Mode',
    'light_mode': 'Light Mode',
    'system_default': 'System Default',
    'language': 'Language',
    'currency': 'Currency',
    'about': 'About',
    'privacy_policy': 'Privacy Policy',
    'version': 'Version',
    'general': 'General',

    'save_calculation': 'Save Calculation',
    'plan_name': 'Plan Name',
    'enter_plan_name': 'Enter a name for this plan',
    'saved_successfully': 'Saved successfully!',
    'deleted_successfully': 'Deleted successfully!',
    'confirm_delete': 'Delete Plan',
    'confirm_delete_msg': 'Are you sure you want to delete this plan?',
    'confirm_clear_history': 'Clear History',
    'confirm_clear_history_msg': 'This will remove all calculation history. Continue?',

    'field_required': 'This field is required',
    'invalid_number': 'Please enter a valid number',
    'value_must_be_positive': 'Value must be greater than 0',
    'value_too_large': 'Value is too large',
  };

  static const Map<String, String> _th = {
    'app_name': 'คำนวณการเงิน',
    'home': 'หน้าหลัก',
    'calculators': 'เครื่องคิดเลข',
    'saved': 'บันทึก',
    'settings': 'ตั้งค่า',
    'history': 'ประวัติ',
    'search': 'ค้นหา',
    'search_calculators': 'ค้นหาเครื่องคิดเลข...',
    'recent_calculations': 'ล่าสุด',
    'favorites': 'รายการโปรด',
    'no_recent': 'ยังไม่มีการคำนวณล่าสุด',
    'no_favorites': 'ยังไม่มีรายการโปรด',
    'no_saved': 'ยังไม่มีแผนที่บันทึก',
    'calculate': 'คำนวณ',
    'save': 'บันทึก',
    'delete': 'ลบ',
    'edit': 'แก้ไข',
    'cancel': 'ยกเลิก',
    'confirm': 'ยืนยัน',
    'clear_all': 'ล้างทั้งหมด',
    'clear_history': 'ล้างประวัติ',
    'results': 'ผลลัพธ์',
    'inputs': 'ข้อมูลที่ป้อน',

    'dca_calc': 'คำนวณ DCA',
    'car_loan_calc': 'สินเชื่อรถยนต์',
    'home_loan_calc': 'สินเชื่อบ้าน',
    'saving_goal_calc': 'เป้าหมายการออม',
    'compound_calc': 'ดอกเบี้ยทบต้น',
    'dca_desc': 'ลงทุนสม่ำเสมอด้วย DCA',
    'car_loan_desc': 'คำนวณค่างวดรถยนต์',
    'home_loan_desc': 'วางแผนผ่อนบ้าน',
    'saving_goal_desc': 'ออมเงินเพื่อเป้าหมาย',
    'compound_desc': 'เพิ่มความมั่งคั่งด้วยดอกเบี้ยทบต้น',

    'monthly_investment': 'ลงทุนรายเดือน',
    'initial_investment': 'เงินลงทุนเริ่มต้น',
    'expected_annual_return': 'ผลตอบแทนต่อปี (%)',
    'investment_period': 'ระยะเวลาลงทุน',
    'annual_contribution_increase': 'เพิ่มการลงทุนต่อปี (%)',
    'total_principal': 'เงินต้นรวม',
    'total_profit': 'กำไรรวม',
    'future_value': 'มูลค่าอนาคต',
    'return_on_investment': 'ผลตอบแทนการลงทุน',
    'growth_chart': 'กราฟการเติบโต',
    'years': 'ปี',
    'months': 'เดือน',
    'optional': 'ไม่บังคับ',

    'car_price': 'ราคารถ',
    'house_price': 'ราคาบ้าน',
    'down_payment': 'เงินดาวน์',
    'interest_rate': 'อัตราดอกเบี้ย (% ต่อปี)',
    'installment_months': 'จำนวนงวด (เดือน)',
    'loan_years': 'ระยะเวลากู้ (ปี)',
    'monthly_payment': 'ค่างวดต่อเดือน',
    'total_payment': 'ยอดชำระรวม',
    'total_interest': 'ดอกเบี้ยรวม',
    'loan_amount': 'วงเงินกู้',
    'payment_schedule': 'ตารางผ่อนชำระ',
    'month': 'เดือน',
    'principal': 'เงินต้น',
    'interest': 'ดอกเบี้ย',
    'balance': 'คงเหลือ',
    'payment': 'ชำระ',

    'target_amount': 'จำนวนเงินเป้าหมาย',
    'time_duration': 'ระยะเวลา',
    'monthly_saving': 'ออมต่อเดือน',
    'weekly_saving': 'ออมต่อสัปดาห์',
    'daily_saving': 'ออมต่อวัน',
    'time_to_reach': 'เวลาที่ใช้',

    'initial_amount': 'เงินต้น',
    'compounding_frequency': 'ความถี่ทบต้น',
    'annually': 'รายปี',
    'semi_annually': 'ทุก 6 เดือน',
    'quarterly': 'รายไตรมาส',
    'monthly': 'รายเดือน',
    'total_growth': 'การเติบโตรวม',

    'appearance': 'การแสดงผล',
    'dark_mode': 'โหมดมืด',
    'light_mode': 'โหมดสว่าง',
    'system_default': 'ตามระบบ',
    'language': 'ภาษา',
    'currency': 'สกุลเงิน',
    'about': 'เกี่ยวกับ',
    'privacy_policy': 'นโยบายความเป็นส่วนตัว',
    'version': 'เวอร์ชัน',
    'general': 'ทั่วไป',

    'save_calculation': 'บันทึกการคำนวณ',
    'plan_name': 'ชื่อแผน',
    'enter_plan_name': 'ใส่ชื่อสำหรับแผนนี้',
    'saved_successfully': 'บันทึกสำเร็จ!',
    'deleted_successfully': 'ลบสำเร็จ!',
    'confirm_delete': 'ลบแผน',
    'confirm_delete_msg': 'แน่ใจหรือไม่ว่าต้องการลบแผนนี้?',
    'confirm_clear_history': 'ล้างประวัติ',
    'confirm_clear_history_msg': 'การดำเนินการนี้จะลบประวัติการคำนวณทั้งหมด ต้องการดำเนินการต่อหรือไม่?',

    'field_required': 'กรุณากรอกข้อมูล',
    'invalid_number': 'กรุณากรอกตัวเลขที่ถูกต้อง',
    'value_must_be_positive': 'ค่าต้องมากกว่า 0',
    'value_too_large': 'ค่ามากเกินไป',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'th'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
