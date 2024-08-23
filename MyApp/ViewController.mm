//
//  ViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 8/21/24.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

UIKIT_EXTERN NSString * UIKeyboardGetCurrentInputMode();

namespace ma_UIRemoteKeyboardWindow {
    namespace isInternalWindow {
        BOOL (*original)(id, SEL);
        BOOL custom(id, SEL) {
            return NO;
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("UIRemoteKeyboardWindow"), sel_registerName("isInternalWindow"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@interface ViewController ()
@end

@implementation ViewController

+ (void)load {
    ma_UIRemoteKeyboardWindow::isInternalWindow::swizzle();
}

- (void)loadView {
//    id sharedPreferencesController = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardPreferencesController"), sel_registerName("sharedPreferencesController"));
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sharedPreferencesController, sel_registerName("setEnableProKeyboard:"), NO);
    
    UITextView *textView = [UITextView new];
    textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    textView.backgroundColor = UIColor.systemBackgroundColor;
//    textView.writingToolsBehavior = UIWritingToolsBehaviorComplete;
//    textView.allowedWritingToolsResultOptions = 1;
    textView.returnKeyType = UIReturnKeyJoin;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    
    self.view = textView;
    [textView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view becomeFirstResponder];
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerRightBarButtonItem:)];
    
    navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeInputModeNotification:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeKeyboardLayoutNotification:) name:@"UIKeyboardLayoutDidChangedNotification" object:nil];
}

- (void)didChangeInputModeNotification:(NSNotification *)notification {
    NSLog(@"%@", UIKeyboardGetCurrentInputMode());
}

- (void)didChangeKeyboardLayoutNotification:(NSNotification *)notification {
    BOOL isFloating = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("isFloating"));
    self.navigationItem.rightBarButtonItem.title = isFloating ? @"Exit Floating" : @"Enter Floating";
}

- (void)didTriggerRightBarButtonItem:(UIBarButtonItem *)sender {
//    BOOL isFloating = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("isFloating"));
//    reinterpret_cast<void (*)(Class, SEL, BOOL, id)>(objc_msgSend)(objc_lookUpClass("UIPeripheralHost"), sel_registerName("setFloating:onCompletion:"), !isFloating, ^(BOOL) {});
    
    id sharedInstance = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("sharedInstance"));
    reinterpret_cast<void (*)(id, SEL, BOOL, BOOL)>(objc_msgSend)(sharedInstance, sel_registerName("setSplit:animated:"), YES, NO);
    // -[UIKeyboardImpl setSplit:animated:]
}

@end
