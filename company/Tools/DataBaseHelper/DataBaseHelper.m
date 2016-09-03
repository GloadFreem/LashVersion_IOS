//
//  DataBaseHelper.m
//  test
//
//  Created by 米 on 16/5/11.
//  Copyright © 2016年 米. All rights reserved.
//

#import "DataBaseHelper.h"
#import "FMDB.h"

#define SQLITE_NAME @"BGSqlite.sqlite"

@interface DataBaseHelper()
@property(nonatomic,strong)FMDatabaseQueue * dbQueue;
@end
@implementation DataBaseHelper

static id _instace;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace; 
}

-(id)init
{
    if (self = [super init]) {
        // 0.获得沙盒中的数据库文件名
        if (!_dbQueue) {
            NSString * dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:SQLITE_NAME];
            NSLog(@"DB path is %@",dbPath);
            _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        }
    }
    return self;
}

/**
 默认建立主键id
 创建表(如果存在久不创建) keys 数据存放要求@[字段名称1,字段名称2]
 */
-(BOOL)createTableWithTableName:(NSString*)name keys:(NSArray*)keys{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }else if (keys == nil){
        NSLog(@"字段数组不能为空!");
        return NO;
    }else;
    __block BOOL result;
    //创表
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString* header = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",name];//,name text,age integer);
        NSMutableString* sql = [[NSMutableString alloc] init];
        [sql appendString:header];
        for(int i=0;i<keys.count;i++){
            [sql appendFormat:@",%@ text",keys[i]];
            if (i == (keys.count-1)) {
                [sql appendString:@");"];
            }
        }
        result = [db executeUpdate:sql];
    }];
    return result;
}

/**
 数据库中是否存在表
 */
- (BOOL)isExistWithTableName:(NSString*)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return NO;
    }
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:name];
    }];
    return result;
}

/**
 插入值
 */
-(BOOL)insertIntoTableName:(NSString*)name Dict:(NSDictionary*)dict{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }else if (dict == nil){
        NSLog(@"插入值字典不能为空!");
        return NO;
    }else;
    
    __block BOOL result;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSArray* keys = dict.allKeys;
        NSArray* values = dict.allValues;
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendFormat:@"insert into %@(",name];
        for(int i=0;i<keys.count;i++){
            [SQL appendFormat:@"%@",keys[i]];
            if(i == (keys.count-1)){
                [SQL appendString:@") "];
            }else{
                [SQL appendString:@","];
            }
        }
        [SQL appendString:@"values("];
        for(int i=0;i<values.count;i++){
            [SQL appendString:@"?"];
            if(i == (keys.count-1)){
                [SQL appendString:@");"];
            }else{
                [SQL appendString:@","];
            }
        }
        result = [db executeUpdate:SQL withArgumentsInArray:values];
        //NSLog(@"插入 -- %d",result);
    }];
    return result;
}


/**
 全部查询
 */
-(NSArray*)queryWithTableName:(NSString*)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return nil;
    }
    
    __block NSMutableArray* arrM = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"select * from %@",name];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:SQL];
        // 2.遍历结果集
        while (rs.next) {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for (int i=0;i<[[[rs columnNameToIndexMap] allKeys] count];i++) {
                dictM[[rs columnNameForIndex:i]] = [rs stringForColumnIndex:i];
            }
            [arrM addObject:dictM];
        }
    }];
    //NSLog(@"查询 -- %@",arrM);
    return arrM;
    
}


#pragma mark 修改更新
-(BOOL)updateInTable:(NSString *)table WithKey:(NSDictionary *)keyValues
{
    __block BOOL ret = YES;
    for (NSString *key in keyValues) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = ?", table, key];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:sql,[keyValues valueForKey:key]]) {
                ret = NO;
            }
        }];
    }
    return ret;
}
#pragma mark --条件更新
-(BOOL)updateInTable:(NSString *)table WithKey:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition
{
    __block BOOL ret = YES;
    for (NSString *key in keyValues) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ?", table, key, [condition allKeys][0]]];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:sql,[keyValues valueForKey:key],[keyValues valueForKey:[condition allKeys][0]]]) {
                ret = NO;
            }
        }];
    }
    return ret;
}

#pragma mark 查询
-(NSMutableArray *)selectInTable:(NSString *)table WithKey:(NSDictionary *)keyTypes
{
    __block NSMutableArray * arr = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select * from %@ limit 10",table]];
        arr = [wSelf getArrWithFMResultSet:set keyTypes:keyTypes];
    }];
    return arr;
}
#pragma mark --条件查询数据库中的数据
-(NSMutableArray *)selectInTable:(NSString *)table WithKey:(NSDictionary *)keyTypes whereCondition:(NSDictionary *)condition
{
    __block NSMutableArray * arr = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ? limit 10",table, [condition allKeys][0]], [condition valueForKey:[condition allKeys][0]]];
        arr = [wSelf getArrWithFMResultSet:set keyTypes:keyTypes];
    }];
    return arr;
}
#pragma mark --模糊查询 某字段以指定字符串开头的数据
-(NSMutableArray *)selectInTable:(NSString *)table WithKey:(NSDictionary *)keyTypes whereKey:(NSString *)key beginWithStr:(NSString *)str
{
    __block NSMutableArray * arr = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ like %@%% limit 10",table, key, str]];
        arr = [wSelf getArrWithFMResultSet:set keyTypes:keyTypes];
    }];
    return arr;
}
#pragma mark --模糊查询 某字段包含指定字符串的数据
-(NSMutableArray *)selectInTable:(NSString *)table WithKey:(NSDictionary *)keyTypes whereKey:(NSString *)key containStr:(NSString *)str
{
    __block NSMutableArray * arr = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ like %%%@%% limit 10",table, key, str]];
        arr = [wSelf getArrWithFMResultSet:set keyTypes:keyTypes];
    }];
    return arr;
}
#pragma mark --模糊查询 某字段以指定字符串结尾的数据
-(NSMutableArray *)selectInTable:(NSString *)table WithKey:(NSDictionary *)keyTypes whereKey:(NSString *)key endWithStr:(NSString *)str
{
    __block NSMutableArray * arr = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ like %%%@ limit 10",table, key, str]];
        arr = [wSelf getArrWithFMResultSet:set keyTypes:keyTypes];
    }];
    return arr;
}
#pragma mark --CommonMethod
-(NSMutableArray *)getArrWithFMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes
{
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyTypes.count; i++) {
            NSString *key = [keyTypes allKeys][i];
            switch ([[keyTypes valueForKey:key] integerValue]) {
                case DBdatatypeNSString:
                    //                字符串
                    [tempDic setValue:[result stringForColumn:key] forKey:key];
                    break;
                case DBdatatypeInteger:
                    //                带符号整数类型
                    [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]]forKey:key];
                    break;
                case DBdatatypeNSdata:
                    //                二进制data
                    [tempDic setValue:[result dataForColumn:key] forKey:key];
                    break;
                case DBdatatypeNSdate:
                    //                date
                    [tempDic setValue:[result dateForColumn:key] forKey:key];
                    break;
                case DBdatatypeBoolean:
                    //                BOOL型
                    [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
                    break;
                case DBdatatypeDouble:
                    //                Double型
                    [tempDic setValue:[NSNumber numberWithDouble:[result doubleForColumn:key]] forKey:key];
                    break;
                default:
                    break;
            }
        }
        [tempArr addObject:tempDic];
    }
    return tempArr;

}
#pragma mark 清理/删除数据
-(BOOL)deleteInTable:(NSString *)table WithKey:(NSDictionary *)keyValues
{
    __block BOOL ret = YES;
    for (NSString *key in keyValues) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@=?", table, key];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:sql,[keyValues valueForKey:key]]) {
                ret = NO;
            }
        }];
    }
    return ret;
}

-(BOOL)cleanTable:(NSString *)table
{
    __block BOOL ret = YES;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:[NSString stringWithFormat:@"delete from %@",table]]) {
            ret = NO;
        }
    }];
    return ret;
}

/**
 删除表
 */
-(BOOL)dropTable:(NSString*)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return NO;
    }
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"drop table %@;",name];
        result = [db executeUpdate:SQL];
    }];
    return result;
}


@end
