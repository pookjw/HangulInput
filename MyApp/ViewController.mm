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
}

- (void)didChangeInputModeNotification:(NSNotification *)notification {
    NSLog(@"%@", UIKeyboardGetCurrentInputMode());
}

- (void)didTriggerRightBarButtonItem:(UIBarButtonItem *)sender {
//    reinterpret_cast<void (*)(Class, SEL)>(objc_msgSend)(UIInputViewController.class, sel_registerName("presentDialogForAddingKeyboard"));
    
//    reinterpret_cast<void (*)(Class, SEL, NSInteger, void (^)(NSInteger))>(objc_msgSend)(objc_lookUpClass("TIAssistantSettings"), sel_registerName("presentDialogForType:withCompletionHandler:"), 0x1, ^(NSInteger result) {
//        
//        NSLog(@"%ld", result);
//    });
    
    id instance = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("_EXRunningExtension"), sel_registerName("sharedInstance"));
    
    id sessions = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(instance, sel_registerName("sessions"));
    
    NSLog(@"%@", sessions);
}

@end
