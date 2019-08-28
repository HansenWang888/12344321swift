//
//  DYTableView.h
//  ID贷
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface DYTableViewModel : NSObject

- (CGFloat)calculateCellheight;
@end


@interface DYTableViewCell : UITableViewCell
@property (nonatomic,weak) DYTableViewModel *model;

/**自己定义flag 表示点击的是哪个按钮
 最终通过tableView 的点击cell的回调 进行传递*/
@property (nonatomic,copy) void(^OtherClickFlag)(NSInteger flag);


@end

typedef void (^DYTableView_Result)(NSArray<DYTableViewModel *> *sources);
/**如果使用*/
@interface DYTableView : UITableView
@property (nonatomic,assign) NSUInteger pageIndex;
@property (nonatomic,assign) NSUInteger pageSize;
@property (nonatomic,strong) NSMutableArray<DYTableViewModel *> *dy_dataSource;
@property (nonatomic,copy) NSString *noDataText;
@property (nonatomic,copy) NSString *noDataImage;
/**是否显示 无数据的图标  默认显示*/
@property (nonatomic,assign) BOOL isShowNoData;
/**缓存行高*/
@property (nonatomic,strong) NSMutableDictionary *heightCache;
/**获取网络请求，并接收请求的数据*/
@property (nonatomic,copy) void(^loadDataCallback)(NSUInteger pageIndex,DYTableView_Result);
/**cell 的点击回调*/
@property (nonatomic,copy) void(^didSelectedCellCallback)(NSIndexPath *idx, NSNumber * _Nullable otherClickFlag);

- (void)loadData;
- (void)loadMoreData;
@end



NS_ASSUME_NONNULL_END
