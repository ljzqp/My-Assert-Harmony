/**
 * Internationalization Service
 * 国际化服务
 */

/**
 * 支持的语言类型
 */
export type Language = 'zh_CN' | 'en_US';

/**
 * 翻译文本接口
 */
interface Translations {
  // 通用
  app_name: string;

  // 页面标题
  page_title_my_assets: string;
  page_subtitle: string;
  page_title_new_asset: string;

  // 按钮
  btn_add_new_asset: string;
  btn_save_asset: string;
  btn_cancel: string;
  btn_select_photo: string;
  btn_select_icon: string;

  // 标签
  label_total_value: string;
  label_daily_cost: string;
  label_asset_count: string;
  label_name: string;
  label_status: string;
  label_purchase_price: string;
  label_purchase_date: string;
  label_target_usage: string;
  label_days_remaining: string;
  label_per_day: string;

  // 状态
  status_in_use: string;
  status_retired: string;
  status_sold: string;

  // 占位符
  placeholder_asset_name: string;
  placeholder_price: string;
  placeholder_date: string;
  placeholder_days: string;

  // 错误信息
  error_name_required: string;
  error_price_invalid: string;
  error_date_required: string;
  error_days_invalid: string;
  error_icon_required: string;

  // 空状态
  empty_no_assets: string;
  empty_add_first: string;

  // 图标选择器
  icon_picker_title: string;
}

/**
 * 中文翻译
 */
const zh_CN: Translations = {
  // 通用
  app_name: '资产追踪',

  // 页面标题
  page_title_my_assets: '我的资产',
  page_subtitle: '用长期视角看待价值',
  page_title_new_asset: '添加资产',

  // 按钮
  btn_add_new_asset: '添加新资产',
  btn_save_asset: '保存资产',
  btn_cancel: '取消',
  btn_select_photo: '选择照片',
  btn_select_icon: '选择图标',

  // 标签
  label_total_value: '总价值',
  label_daily_cost: '每日花费',
  label_asset_count: '资产数量',
  label_name: '名称',
  label_status: '状态',
  label_purchase_price: '购买价格 (¥)',
  label_purchase_date: '购买日期',
  label_target_usage: '目标使用天数',
  label_days_remaining: '还剩 {0} 天',
  label_per_day: '/天',

  // 状态
  status_in_use: '使用中',
  status_retired: '已退役',
  status_sold: '已出售',

  // 占位符
  placeholder_asset_name: '例如：iPhone 15 Pro',
  placeholder_price: '9999',
  placeholder_date: 'YYYY-MM-DD',
  placeholder_days: '例如：1095（3年）',

  // 错误信息
  error_name_required: '请输入名称',
  error_price_invalid: '价格必须大于0',
  error_date_required: '请输入购买日期',
  error_days_invalid: '目标天数必须大于0',
  error_icon_required: '请选择图标或上传图片',

  // 空状态
  empty_no_assets: '暂无资产',
  empty_add_first: '点击下方按钮添加您的第一个资产',

  // 图标选择器
  icon_picker_title: '选择资产图标'
};

/**
 * 英文翻译
 */
const en_US: Translations = {
  // 通用
  app_name: 'Asset Tracker',

  // 页面标题
  page_title_my_assets: 'My Assets',
  page_subtitle: 'A long-term perspective on value.',
  page_title_new_asset: 'New Asset',

  // 按钮
  btn_add_new_asset: 'Add New Asset',
  btn_save_asset: 'Save Asset',
  btn_cancel: 'Cancel',
  btn_select_photo: 'Select Photo',
  btn_select_icon: 'or Select Icon',

  // 标签
  label_total_value: 'Total Value',
  label_daily_cost: 'Daily Cost',
  label_asset_count: 'Total Assets',
  label_name: 'Name',
  label_status: 'Status',
  label_purchase_price: 'Purchase Price (¥)',
  label_purchase_date: 'Purchase Date',
  label_target_usage: 'Target Usage (days)',
  label_days_remaining: '{0} days remaining',
  label_per_day: '/day',

  // 状态
  status_in_use: 'In Use',
  status_retired: 'Retired',
  status_sold: 'Sold',

  // 占位符
  placeholder_asset_name: 'e.g., iPhone 15 Pro',
  placeholder_price: '9999',
  placeholder_date: 'YYYY-MM-DD',
  placeholder_days: 'e.g., 1095 for 3 years',

  // 错误信息
  error_name_required: 'Name is required',
  error_price_invalid: 'Price must be > 0',
  error_date_required: 'Purchase date is required',
  error_days_invalid: 'Target days must be > 0',
  error_icon_required: 'Please select an icon or upload an image',

  // 空状态
  empty_no_assets: 'No assets yet',
  empty_add_first: 'Tap the button below to add your first asset',

  // 图标选择器
  icon_picker_title: 'Select Asset Icon'
};

/**
 * 当前语言（默认中文）
 * 可以通过修改这个值来切换语言
 */
let currentLanguage: Language = 'zh_CN';

/**
 * 获取当前翻译对象
 */
function getCurrentTranslations(): Translations {
  if (currentLanguage === 'en_US') {
    return en_US;
  }
  return zh_CN;
}

/**
 * 国际化服务类
 */
export class I18n {
  /**
   * 获取当前语言
   */
  static getLanguage(): Language {
    return currentLanguage;
  }

  /**
   * 设置语言
   */
  static setLanguage(lang: Language): void {
    currentLanguage = lang;
  }

  /**
   * 获取翻译文本
   * @param key 翻译键
   * @param args 替换参数（用于 {0}, {1} 等占位符）
   */
  static t(key: string, ...args: string[]): string {
    const trans = getCurrentTranslations();
    let text = '';

    switch (key) {
      case 'app_name': text = trans.app_name; break;
      case 'page_title_my_assets': text = trans.page_title_my_assets; break;
      case 'page_subtitle': text = trans.page_subtitle; break;
      case 'page_title_new_asset': text = trans.page_title_new_asset; break;
      case 'btn_add_new_asset': text = trans.btn_add_new_asset; break;
      case 'btn_save_asset': text = trans.btn_save_asset; break;
      case 'btn_cancel': text = trans.btn_cancel; break;
      case 'btn_select_photo': text = trans.btn_select_photo; break;
      case 'btn_select_icon': text = trans.btn_select_icon; break;
      case 'label_total_value': text = trans.label_total_value; break;
      case 'label_daily_cost': text = trans.label_daily_cost; break;
      case 'label_asset_count': text = trans.label_asset_count; break;
      case 'label_name': text = trans.label_name; break;
      case 'label_status': text = trans.label_status; break;
      case 'label_purchase_price': text = trans.label_purchase_price; break;
      case 'label_purchase_date': text = trans.label_purchase_date; break;
      case 'label_target_usage': text = trans.label_target_usage; break;
      case 'label_days_remaining': text = trans.label_days_remaining; break;
      case 'label_per_day': text = trans.label_per_day; break;
      case 'status_in_use': text = trans.status_in_use; break;
      case 'status_retired': text = trans.status_retired; break;
      case 'status_sold': text = trans.status_sold; break;
      case 'placeholder_asset_name': text = trans.placeholder_asset_name; break;
      case 'placeholder_price': text = trans.placeholder_price; break;
      case 'placeholder_date': text = trans.placeholder_date; break;
      case 'placeholder_days': text = trans.placeholder_days; break;
      case 'error_name_required': text = trans.error_name_required; break;
      case 'error_price_invalid': text = trans.error_price_invalid; break;
      case 'error_date_required': text = trans.error_date_required; break;
      case 'error_days_invalid': text = trans.error_days_invalid; break;
      case 'error_icon_required': text = trans.error_icon_required; break;
      case 'empty_no_assets': text = trans.empty_no_assets; break;
      case 'empty_add_first': text = trans.empty_add_first; break;
      case 'icon_picker_title': text = trans.icon_picker_title; break;
      default: text = key;
    }

    // 替换占位符
    for (let i = 0; i < args.length; i++) {
      text = text.replace(`{${i}}`, args[i]);
    }

    return text;
  }

  /**
   * 获取状态的翻译文本
   */
  static getStatusText(status: string): string {
    if (status === 'In Use') {
      return I18n.t('status_in_use');
    } else if (status === 'Retired') {
      return I18n.t('status_retired');
    } else if (status === 'Sold') {
      return I18n.t('status_sold');
    }
    return status;
  }

  /**
   * 获取所有状态选项
   */
  static getStatusOptions(): string[] {
    return ['In Use', 'Retired', 'Sold'];
  }
}
