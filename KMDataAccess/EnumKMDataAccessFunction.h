//
//  EnumKMDataAccessFunction.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/5.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

typedef NS_ENUM(NSUInteger, KMDataAccessFunction) {
    KMDataAccessFunctionPList,
    KMDataAccessFunctionPreference,
    KMDataAccessFunctionNSKeyedArchiver,
    KMDataAccessFunctionKeychain,
    KMDataAccessFunctionSQLite,
    KMDataAccessFunctionCoreData,
    KMDataAccessFunctionFMDB
};

