# iOS- 防崩溃
iOS 项目防崩溃方案
    利用method swizzing进行Array, Dictionary的数据容错是比较常见的做法， 但是像NSArray等类型会有很多派生类， 想要拦截要对各个派生类都加上防护。 并且不同类型的数据，数据操作方法也较多。  
    本方案主要针对NSArray， NSMutableArray， NSDictionary， NSMutableDictionary，NSString，  NSMutableString， NSAttributedString， NSMutableAttributedString 以及 unrecognized sector 进行防护操作。 所有方法均写在+load方法中，直接拖拽到工程中即可使用。
