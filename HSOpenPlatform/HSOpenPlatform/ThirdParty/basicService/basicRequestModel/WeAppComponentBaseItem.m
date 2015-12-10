//
//  WeAppComponentBaseItem.m
//  TBWeApp
//
//  Created by zhuge.zzy on 6/26/14.
//  Copyright (c) 2014 rocky. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "TBJSONModelKeyMapper.h"
#import "TBJSONModelProperty.h"
#import "NSArray+TBJSONModel.h"
#import "NSDictionary+TBJSONModel.h"
#import <objc/runtime.h>

NSString * const TBJSONModelBoolStringTrue = @"true";
NSString * const TBJSONModelBoolStringFalse = @"false";
//下面两个静态无需初始化，因为用于关联对象的key的时候只会用到其地址
static const char * kAssociatedMapperKey;
static const char * kAssociatedPropertiesKey;

@implementation WeAppComponentBaseItem

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary* dict = [self toDictionary];
    if (dict) {
        [aCoder encodeObject:dict forKey:@"dict"];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    NSDictionary* dict = [aDecoder decodeObjectForKey:@"dict"];
    self = [self initWithDictionary:dict];
    return self;
}

#pragma mark -
#pragma mark Private

- (void)_setupKeyMapper{
    if (objc_getAssociatedObject(self.class, &kAssociatedMapperKey) == nil) {
        TBJSONModelKeyMapper *keyMapper = [self.class modelKeyMapper];
        if (keyMapper != nil) {
            objc_setAssociatedObject(self.class, &kAssociatedMapperKey, keyMapper, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)_setupPropertyMap{
    if (objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey) == nil) {
        
        NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
        
        Class class = [self class];
        
        while (class != [WeAppComponentBaseItem class]) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++) {
                
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                //属性的相关属性都在propertyAttrs中，包括其类型，protocol，存取修饰符等信息
                const char *propertyAttrs = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:propertyAttrs];
                TBJSONModelProperty *modelProperty = [[TBJSONModelProperty alloc] initWithName:name typeString:typeString];
                if (!modelProperty.isReadonly) {
                    [propertyMap setValue:modelProperty forKey:modelProperty.name];
                }
            }
            free(properties);
            
            class = [class superclass];
        }
        objc_setAssociatedObject(self.class, &kAssociatedPropertiesKey, propertyMap, OBJC_ASSOCIATION_RETAIN);
    }
}


//根据对应的属性类型，将value进行转换成合适的值
- (id)valueForProperty:(TBJSONModelProperty *)property withJSONValue:(id)value{
    id resultValue = value;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        resultValue = nil;
    }else{
        if (property.valueType != TBClassPropertyTypeObject) {
            /*当属性为原始数据类型而对应的json dict中的value的类型为字符串对象的时候
             则对字符串进行相应的转换*/
            if ([value isKindOfClass:[NSString class]]) {
                if (property.valueType == TBClassPropertyTypeInt ||
                    property.valueType == TBClassPropertyTypeUnsignedInt||
                    property.valueType == TBClassPropertyTypeShort||
                    property.valueType == TBClassPropertyTypeUnsignedShort) {
                    resultValue = [NSNumber numberWithInt:[(NSString *)value intValue]];
                }
                if (property.valueType == TBClassPropertyTypeLong ||
                    property.valueType == TBClassPropertyTypeUnsignedLong ||
                    property.valueType == TBClassPropertyTypeLongLong ||
                    property.valueType == TBClassPropertyTypeUnsignedLongLong){
                    resultValue = [NSNumber numberWithLongLong:[(NSString *)value longLongValue]];
                }
                if (property.valueType == TBClassPropertyTypeFloat) {
                    resultValue = [NSNumber numberWithFloat:[(NSString *)value floatValue]];
                }
                if (property.valueType == TBClassPropertyTypeDouble) {
                    resultValue = [NSNumber numberWithDouble:[(NSString *)value doubleValue]];
                }
                if (property.valueType == TBClassPropertyTypeChar) {
                    //对于BOOL而言，@encode(BOOL) 为 c 也就是signed char
                    resultValue = [NSNumber numberWithBool:[(NSString *)value boolValue]];
                }
            }
        }else{
            Class valueClass = property.objectClass;
            //当当前属性为TBJSONModel类型
            if ([valueClass isSubclassOfClass:[WeAppComponentBaseItem class]] &&
                [value isKindOfClass:[NSDictionary class]]) {
                resultValue = [[valueClass alloc] initWithDictionary:value];
            }
            
            //当当前属性为NSString类型，而对应的json的value为非NSString对象，自动进行转换
            if ([valueClass isSubclassOfClass:[NSString class]] &&
                ![value isKindOfClass:[NSString class]]) {
                resultValue = [NSString stringWithFormat:@"%@",value];
            }
            
            //当当前属性为NSNumber类型，而对应的json的value为NSString的时候
            if ([valueClass isSubclassOfClass:[NSNumber class]] &&
                [value isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                resultValue = [numberFormatter numberFromString:value];
            }
            
            NSString *valueProtocol = [property.objectProtocols lastObject];
            if ([valueProtocol isKindOfClass:[NSString class]]) {
                Class valueProtocolClass = NSClassFromString(valueProtocol);
                if (valueProtocolClass != nil) {
                    if ([valueProtocolClass isSubclassOfClass:[WeAppComponentBaseItem class]]) {
                        //array of models
                        if ([value isKindOfClass:[NSArray class]]) {
                            resultValue = [(NSArray *)value modelArrayWithClass:valueProtocolClass];
                        }
                        //dictionary of models
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            resultValue = [(NSDictionary *)value modelDictionaryWithClass:valueProtocolClass];
                        }
                    }
                }
            }
        }
    }
    return resultValue;
}

#pragma mark -
#pragma mark Class methods

+(id)change:(id)temp intoClass:(Class)targetClass{
    return nil;
}

+ (id)model {
    return [self modelWithJSON:nil];
}

+ (id)modelWithJSON:(NSDictionary*)json {
    return [[[self class] alloc] initWithDictionary:json];
}


+ (id)modelArrayWithJSON:(NSArray *)jsonArray {
    Class cls = [self class];
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
    
    for (NSDictionary *dict in jsonArray) {
        [ret addObject:[cls modelWithJSON:dict]];
    }
    
    return ret;
}

+ (TBJSONModelKeyMapper *)modelKeyMapper{
    return nil;
}

+(NSMutableDictionary *)getImmutableDictionaryFromMutableDictionary:(NSDictionary *)object{
    
    if (object == nil
        || ![object isKindOfClass:[NSDictionary class]]
        || [object count] <= 0) {
        return nil;
    }
    
    NSDictionary *dic = (NSDictionary *)object;
    if (dic == nil || [dic count] <= 0) {
        return nil;
    }
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithCapacity:[dic count]];
    
    NSArray *allkeys = [dic allKeys];
    
    for (NSString *key in allkeys) {
        if (key == nil
            || ![key isKindOfClass:[NSString class]]
            || key.length == 0) {
            continue;
        }
        
        id value = [dic objectForKey:key];
        
        if (value == nil
            || [value isKindOfClass:[NSNull class]]
            || [value isEqual:[NSNull null]]) {
            continue;
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *newDic = [self getImmutableDictionaryFromMutableDictionary:(NSDictionary*)value];
            if (newDic && [newDic count] > 0) {
                [mutableDic setObject:newDic forKey:key];
            }
        }else if([value isKindOfClass:[NSArray class]]){
            NSMutableArray *newArray = [self getImmutableArrayFromMutableArray:(NSArray*)value];
            if (newArray && [newArray count] > 0) {
                [mutableDic setObject:newArray forKey:key];
            }
        }else{
            [mutableDic setObject:value forKey:key];
        }
        
    }
    
    if (mutableDic) {
        return mutableDic;
    }
    
    return mutableDic;
}

+(NSMutableArray*)getImmutableArrayFromMutableArray:(NSArray*)array{
    if (array == nil
        || ![array isKindOfClass:[NSArray class]]
        || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (id value in array) {
        
        if (value == nil
            || [value isKindOfClass:[NSNull class]]
            || [value isEqual:[NSNull null]]) {
            continue;
        }
        
        if([value isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary* newParam = [self getImmutableDictionaryFromMutableDictionary:(NSDictionary*)value];
            
            if (newParam && [newParam count] > 0) {
                [newArray addObject:newParam];
            }
            
        }else if([value isKindOfClass:[NSArray class]]){
            NSMutableArray* newArrayObj = [self getImmutableArrayFromMutableArray:(NSArray*)value];
            
            if (newArrayObj && [newArrayObj count] > 0) {
                [newArray addObject:newArrayObj];
            }
            
        }else{
            [newArray addObject:value];
        }
    }
    
    if (newArray) {
        return newArray;
    }
    
    return nil;
}


#pragma mark -
#pragma mark Initialize

- (id)init {
    return [self initWithDictionary:nil];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if(![dict isKindOfClass:[NSNull class]]){
            [self _setupKeyMapper];
            [self _setupPropertyMap];
            self.componentDict = [self parseModule:dict];
            [self setup];
            [self setFromDictionary:self.componentDict];
        }
    }
    return self;
}

-(void)setup {
    
}

- (NSDictionary*)parseModule:(NSDictionary*) dict {
    return [WeAppComponentBaseItem getImmutableDictionaryFromMutableDictionary:dict];
}

- (void)setFromDictionary:(NSDictionary *)dict{
    if (!dict) {
        return;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *propertyMap = objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey);
    TBJSONModelKeyMapper *keyMapper = objc_getAssociatedObject(self.class, &kAssociatedMapperKey);
    
    //对所有属性进行遍历，到dict中找到对应的值，分别进行设置
    for (TBJSONModelProperty *modelProperty in [propertyMap allValues]) {
        NSString *jsonKey = modelProperty.name;
        if (keyMapper != nil) {
            jsonKey = [keyMapper jsonKeyMappedFromModelKey:jsonKey];
        }
        
        id jsonValue = [dict objectForKey:jsonKey];
        id propertyValue = [self valueForProperty:modelProperty withJSONValue:jsonValue];
        if (propertyValue != nil) {
            [self setValue:propertyValue forKey:modelProperty.name];
        }
    }
}

/*
- (void)setFromDictionary:(NSDictionary *)dict {
    NSDictionary    *keyMap = [self keyMapDictionary];
    for (NSString __strong *key in [dict keyEnumerator]) {
        
        id val = [dict objectForKey:key];
        
        if ([keyMap objectForKey:key]) {
            key = [keyMap objectForKey:key];
        }
        
        if ([val isKindOfClass:[NSArray class]]) {
            Class type = [self classForKey:key];
            
            if (type) {
                [self setValue:[type modelArrayWithJSON:val] forKey:key];
            } else {
                [self setValue:val forKey:key];
            }
            
        } else if (![val isKindOfClass:[NSDictionary class]] && ![val isKindOfClass:[NSNull class]]) {
            
            [self setValue:val forKey:key];
            
        } else {
            
            id origVal = [self valueForKey:key];
			
            if ([origVal isKindOfClass:[NSArray class]]) {
                NSLog(@"key: %@", key);
                
                NSArray *allKeys = [val allKeys];
                
                if ([allKeys count] > 0) {
                    NSArray *arr = [val objectForKey:[allKeys objectAtIndex:0]];
                    
                    Class type = [self classForKey:key];
                    
                    if (type && [arr isKindOfClass:[NSArray class]]) {
                        [self setValue:[type modelArrayWithJSON:arr] forKey:key];
                    }
                }
                
            } else {
                Class cls = [self classForKey:key];
                if (cls) {
                    [self setValue:[cls modelWithJSON:val] forKey:key];
                } else {
                    [self setValue:val forKey:key];
                }
            }
            
        }
    }
}
 */

#pragma mark -
#pragma mark Key-Value Coding

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"WARNING: [%@] Set value:%@ for undefiend key: %@",NSStringFromClass(self.class) ,value, key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"WARNING: [%@] Get value for undefiend key %@", self, key);
    return nil;
}

- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"WARNING: set nil value for key %@", key);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@",[self toDictionary]];
}


#pragma mark -

- (NSDictionary *)toDictionary{
    NSDictionary *propertyMap = objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey);
    if (propertyMap!= nil && [propertyMap count] > 0) {
        NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:[propertyMap count]];
        TBJSONModelKeyMapper *keyMapper = objc_getAssociatedObject(self.class, &kAssociatedMapperKey);
        
        for (TBJSONModelProperty *property in [propertyMap allValues]) {
            NSString *dictKey = property.name;
            id val = [self valueForKeyPath:dictKey];
            
            if ([val isKindOfClass:[WeAppComponentBaseItem class]]) {
                val = [(WeAppComponentBaseItem *)val toDictionary];
            }else if([val isKindOfClass:[NSArray class]]){
                val = [(NSArray *)val toArray];
            }else if([val isKindOfClass:[NSDictionary class]]){
                val = [(NSDictionary *)val toDictionary];
            }
            
            if (keyMapper != nil) {
                NSString *mappedKey = [keyMapper jsonKeyMappedFromModelKey:dictKey];
                if (mappedKey != nil) {
                    dictKey = mappedKey;
                }
            }
            
            if (val != nil && dictKey != nil) {
                if (property.valueType == TBClassPropertyTypeChar) {
                    if (_treatBoolAsStringWhenModelToJSON &&
                        [val isKindOfClass:[NSNumber class]]) {
                        NSString *booleanString = nil;
                        if ([val boolValue]) {
                            booleanString = TBJSONModelBoolStringTrue;
                        }else{
                            booleanString = TBJSONModelBoolStringFalse;
                        }
                        [jsonDictionary setObject:booleanString forKey:dictKey];
                    }else{
                        [jsonDictionary setObject:val forKey:dictKey];
                    }
                }else{
                    [jsonDictionary setObject:val forKey:dictKey];
                }
            }
        }
        return jsonDictionary;
    }
    return nil;
}

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON{
    _treatBoolAsStringWhenModelToJSON = treatBoolAsStringWhenModelToJSON;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithDictionary:[self toDictionary]];
}

/*
- (NSDictionary *)toDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:[[self keys] count]];
    NSArray *keys = [self keys];
    for (NSString *key in keys) {
        id val = [self valueForKey:key];
        if (val && ![val isKindOfClass:[NSNull class]]) {
            [ret setObject:val forKey:key];
        }
    }
    return ret;
}
 */

@end

@implementation NSObject (NSObject_JsonWriting)

@end
