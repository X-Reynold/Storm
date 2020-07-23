//
//  ViewController.m
//  BlueAdSDKDemo
//
//  Created by 谢镭 on 2020/3/20.
//  Copyright © 2020 Rey. All rights reserved.
//


#import "ViewController.h"
#import "SVProgressHUD.h"

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"



static lua_State * luaState;

@interface xlView : UIView

@end

@implementation xlView

-(void)dealloc{
    NSLog(@"dealloc");
}
-(void)setTag:(NSInteger)tag{
    lua_Number a = lua_tonumber(luaState, -1);
    NSLog(@"%f",a);
}
@end

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray * tempObjcetArray;

@end

static ViewController * instance = nil;
@implementation ViewController


-(NSMutableArray *)tempObjcetArray{
    if (!_tempObjcetArray) {
        _tempObjcetArray = [NSMutableArray array];
    }
    return _tempObjcetArray;
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    instance = self;
    luaState = luaL_newstate();    //创建新的lua_State结构体
    luaL_openlibs(luaState);
    self.view.backgroundColor = [UIColor redColor];
//    [self requestSource];
    
    [self pageSettingWithHotFix:false str:nil];
}

- (void)pageSettingWithHotFix:(BOOL)hotfix str:(NSString *)hotfixStr{
    NSString * lua = nil;
    if (!hotfixStr.length) {
       lua = [[NSBundle mainBundle] pathForResource:@"hotfix" ofType:@"lua"];
    }else{
       lua = hotfixStr;
    }
//    NSString * str0 = [[NSBundle mainBundle] pathForResource:@"hotfix" ofType:@"lua"];
//    NSString * str1 = hotfixStr;
    luaL_dofile(luaState, [lua UTF8String]);
       
//    lua_getglobal(luaState, "version");
//    const char * value = lua_tostring(luaState, -1);
//    NSLog(@"%s",value);
//
//    UILabel * label = [[UILabel alloc] init];
//    label.text = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
//    label.frame = CGRectMake(100, 100, 200, 200);
//    [self.view addSubview:label];
//    self.view.backgroundColor = [UIColor redColor];
       
       //call lua func
       
    lua_pushcfunction(luaState, normalView);
    lua_setglobal(luaState, "normalView");
       
    lua_pushcfunction(luaState, addSubView);
    lua_setglobal(luaState, "addSubView");
       
    lua_pushcfunction(luaState, freeObjects);
    lua_setglobal(luaState, "freeObjects");
       
    lua_getglobal(luaState, "mainViewDidLoad");
    lua_pcall(luaState, 0, 0, 0);
    
    for (UIView * view in self.view.subviews) {
        NSLog(@"--------------%ld",(long)view.tag);
    }
}

int normalView(lua_State *state){
    
    UIColor *bgColor;
    if (lua_gettop(state) > 0){
        const char *name = lua_tostring(state, 1);
        NSLog(@"%s!", name);
        if (strcmp(name, "bg:blue") == 0) {
            bgColor = [UIColor blueColor];
        }
        if (strcmp(name, "bg:yellow") == 0) {
            bgColor = [UIColor yellowColor];
        }
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = bgColor;
    
//    instance.view.backgroundColor = [UIColor redColor];
//    return (__bridge void *)(view);
    
    [instance.tempObjcetArray addObject:view];
    lua_pushlightuserdata(luaState, (__bridge void *)(view));
//    lua_setglobal(instance->luaState, "aview");
//    [instance.view addSubview:view];
    return 1;
    
}

static int addSubView(lua_State *state){
    if (lua_gettop(state) > 0){
           UIView *view = (__bridge UIView *)(lua_topointer(state, 1));
           [instance.view addSubview:view];
           NSLog(@"%ld",(long)view.tag);
    }
    return 0;
}

static int freeObjects(){
    NSLog(@"释放内存压力");
    [instance.tempObjcetArray removeAllObjects];
    return 0;
}

-(void)requestSource{//请求热更资源
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"热更中...."];
    

    
    
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
//    // 从提供URL中下载数据
    NSData *data = [NSData dataWithContentsOfURL:
    [NSURL URLWithString: @"https://f.aidalan.com/yy.reward.icon/d6e0ba294e4154229586abd84cba4ae9.txt"]];
    
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 数据转换成图片
    
    
    [SVProgressHUD dismiss];
    doc = [NSString stringWithFormat:@"%@/%d.lua",doc,(int)[[NSDate date] timeIntervalSince1970]];
    [str writeToFile:doc atomically:true encoding:NSUTF8StringEncoding error:nil];
    [self pageSettingWithHotFix:true str:doc];
}

-(void)function1{
    
}

-(void)function2{
    
}



//int addSubview()
//int printHelloWorld (lua_State *state){
//    NSLog(@"Hello World!");
//    return 0;
//}

@end
