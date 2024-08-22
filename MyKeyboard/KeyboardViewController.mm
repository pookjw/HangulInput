//
//  KeyboardViewController.mm
//  MyKeyboard
//
//  Created by Jinwoo Kim on 8/21/24.
//

#import "KeyboardViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <HangulAutomata/HAHangulAutomata.h>

@interface InputModeListView : UILabel
@end
@implementation InputModeListView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    auto inputViewController = reinterpret_cast<UIInputViewController * (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_viewControllerForAncestor"));
    [inputViewController handleInputModeListFromView:self withEvent:event];
}
@end

@interface KeyboardViewController ()
@property (retain, nonatomic) UIButton *debugButton;
@property (retain, nonatomic) UIButton *advanceToNextInputModeButton;
@property (retain, nonatomic) UIButton *deleteBackwardButton;
@property (retain, nonatomic) InputModeListView *inputModeListView;
@end

@implementation KeyboardViewController
@synthesize debugButton = _debugButton;
@synthesize advanceToNextInputModeButton = _advanceToNextInputModeButton;
@synthesize deleteBackwardButton = _deleteBackwardButton;
@synthesize inputModeListView = _inputModeListView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)dealloc {
    [_debugButton release];
    [_advanceToNextInputModeButton release];
    [_deleteBackwardButton release];
    [_inputModeListView release];
    [super dealloc];
}

- (void)loadView {
    UIStackView *firstRowStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.debugButton,
        self.advanceToNextInputModeButton,
        self.deleteBackwardButton,
        self.inputModeListView
    ]];
    firstRowStackView.axis = UILayoutConstraintAxisHorizontal;
    firstRowStackView.alignment = UIStackViewAlignmentFill;
    firstRowStackView.distribution = UIStackViewDistributionFillEqually;
    
    //
    
    NSMutableArray<UIButton *> *secondRowKeyButtons = [[NSMutableArray alloc] initWithCapacity:10];
    [@[@"ㅂ", @"ㅈ", @"ㄷ", @"ㄱ", @"ㅅ", @"ㅛ", @"ㅕ", @"ㅑ", @"ㅐ", @"ㅔ"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [secondRowKeyButtons addObject:[self buttonForKey:obj]];
    }];
    UIStackView *secondRowStackView = [[UIStackView alloc] initWithArrangedSubviews:secondRowKeyButtons];
    [secondRowKeyButtons release];
    secondRowStackView.axis = UILayoutConstraintAxisHorizontal;
    secondRowStackView.alignment = UIStackViewAlignmentFill;
    secondRowStackView.distribution = UIStackViewDistributionFillEqually;
    
    //
    
    NSMutableArray<UIButton *> *thirdRowKeyButtons = [[NSMutableArray alloc] initWithCapacity:9];
    [@[@"ㅁ", @"ㄴ", @"ㅇ", @"ㄹ", @"ㅎ", @"ㅗ", @"ㅓ", @"ㅏ", @"ㅣ"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [thirdRowKeyButtons addObject:[self buttonForKey:obj]];
    }];
    UIStackView *thridRowStackView = [[UIStackView alloc] initWithArrangedSubviews:thirdRowKeyButtons];
    [thirdRowKeyButtons release];
    thridRowStackView.axis = UILayoutConstraintAxisHorizontal;
    thridRowStackView.alignment = UIStackViewAlignmentFill;
    thridRowStackView.distribution = UIStackViewDistributionFillEqually;
    
    //
    
    NSMutableArray<UIButton *> *fourthRowKeyButtons = [[NSMutableArray alloc] initWithCapacity:9];
    [@[@"ㅋ", @"ㅌ", @"ㅊ", @"ㅍ", @"ㅠ", @"ㅜ", @"ㅡ"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fourthRowKeyButtons addObject:[self buttonForKey:obj]];
    }];
    UIStackView *fourthRowStackView = [[UIStackView alloc] initWithArrangedSubviews:fourthRowKeyButtons];
    [fourthRowKeyButtons release];
    fourthRowStackView.axis = UILayoutConstraintAxisHorizontal;
    fourthRowStackView.alignment = UIStackViewAlignmentFill;
    fourthRowStackView.distribution = UIStackViewDistributionFillEqually;
    
    //
    
    UIStackView *verticalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        firstRowStackView,
        secondRowStackView,
        thridRowStackView,
        fourthRowStackView
    ]];
    [firstRowStackView release];
    [secondRowStackView release];
    [thridRowStackView release];
    [fourthRowStackView release];
    
    verticalStackView.axis = UILayoutConstraintAxisVertical;
    verticalStackView.alignment = UIStackViewAlignmentFill;
    verticalStackView.distribution = UIStackViewDistributionFill;
    
    self.view = verticalStackView;
    [verticalStackView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)needsInputModeSwitchKey {
    return YES;
}

- (UIButton *)buttonForKey:(NSString *)key {
    __weak auto weakSelf = self;
    
    UIAction *primaryAction = [UIAction actionWithTitle:key image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        id<UITextDocumentProxy> textDocumentProxy = weakSelf.textDocumentProxy;
        
        NSString *documentContextBeforeInput = textDocumentProxy.documentContextBeforeInput;
        
        if (documentContextBeforeInput.length == 0) {
            [textDocumentProxy insertText:key];
        } else {
            NSString *lastString = [documentContextBeforeInput substringWithRange:NSMakeRange(documentContextBeforeInput.length - 1, 1)];
            [textDocumentProxy deleteBackward];
            [textDocumentProxy insertText:[HAHangulAutomata string:lastString byInsertingElement:key]];
        }
        
//        NSString *markedText = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textDocumentProxy, sel_registerName("markedText"));
//        
//        if (markedText.length > 0) {
//            [textDocumentProxy setMarkedText:@"가" selectedRange:NSMakeRange(0, 0)];
//            [textDocumentProxy unmarkText];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [textDocumentProxy adjustTextPositionByCharacterOffset:1];
//                
//            });
//        } else {
//            [textDocumentProxy setMarkedText:key selectedRange:NSMakeRange(0, 0)];
//        }
        
        
    }];
    
    return [UIButton buttonWithType:UIButtonTypeSystem primaryAction:primaryAction];
}

- (UIButton *)debugButton {
    if (auto debugButton = _debugButton) return debugButton;
    
    __weak auto weakSelf = self;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"" image:[UIImage systemImageNamed:@"ant"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        [weakSelf insertText:@"가" byDeletingBackwardCount:1];
        [weakSelf.textDocumentProxy deleteBackward];
        [weakSelf.textDocumentProxy insertText:@"가"];
        NSLog(@"%@", weakSelf.textDocumentProxy.documentIdentifier);
    }];
    
    UIButton *debugButton = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:primaryAction];
    
    _debugButton = [debugButton retain];
    return debugButton;
}

- (UIButton *)advanceToNextInputModeButton {
    if (auto advanceToNextInputModeButton = _advanceToNextInputModeButton) return advanceToNextInputModeButton;
    
    __weak auto weakSelf = self;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"" image:[UIImage systemImageNamed:@"globe"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf advanceToNextInputMode];
    }];
    
    UIButton *advanceToNextInputModeButton = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:primaryAction];
    
    _advanceToNextInputModeButton = [advanceToNextInputModeButton retain];
    return advanceToNextInputModeButton;
}

- (UIButton *)deleteBackwardButton {
    if (auto deleteBackwardButton = _deleteBackwardButton) return deleteBackwardButton;
    
    __weak auto weakSelf = self;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"" image:[UIImage systemImageNamed:@"delete.left"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.textDocumentProxy deleteBackward];
    }];
    
    UIButton *deleteBackwardButton = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:primaryAction];
    
    _deleteBackwardButton = [deleteBackwardButton retain];
    return deleteBackwardButton;
}

- (InputModeListView *)inputModeListView {
    if (auto inputModeListView = _inputModeListView) return inputModeListView;
    
    InputModeListView *inputModeListView = [InputModeListView new];
    inputModeListView.backgroundColor = UIColor.systemOrangeColor;
    inputModeListView.textColor = UIColor.systemPurpleColor;
    inputModeListView.text = @"Mode";
    inputModeListView.textAlignment = NSTextAlignmentCenter;
    inputModeListView.userInteractionEnabled = YES;
    
    _inputModeListView = [inputModeListView retain];
    return [inputModeListView autorelease];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    [super textWillChange:textInput];
    
    NSLog(@"%@%@", self.textDocumentProxy.documentContextBeforeInput, self.textDocumentProxy.documentContextAfterInput);
}

- (void)textDidChange:(id<UITextInput>)textInput {
    [super textDidChange:textInput];
}

- (void)selectionWillChange:(id<UITextInput>)textInput {
    [super selectionWillChange:textInput];
}

- (void)selectionDidChange:(id<UITextInput>)textInput {
    [super selectionDidChange:textInput];
    
//    [textInput repla]
    
    NSLog(@"%@", textInput);
}

- (void)insertText:(NSString *)string byDeletingBackwardCount:(NSUInteger)deletingBackwardCount {
    id _proxyInterface = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_proxyInterface"));
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_proxyInterface, sel_registerName("_willPerformOutputOperation"));
    
    //
    
    id documentState = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_proxyInterface, sel_registerName("_documentState"));
    
    for (NSUInteger c = 0; c < deletingBackwardCount; c++) {
        documentState = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(documentState, sel_registerName("documentStateAfterDeletingBackward"));
    }
    
    documentState = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(documentState, sel_registerName("documentStateAfterInsertingText:"), string);
    
    id _controllerState = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_proxyInterface, sel_registerName("_controllerState"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_controllerState, sel_registerName("setDocumentState:"), documentState);
    
    //
    
    for (NSUInteger c = 0; c < deletingBackwardCount; c++) {
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_proxyInterface, sel_registerName("deleteBackward"));
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_proxyInterface, sel_registerName("insertText:"), string);
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_proxyInterface, sel_registerName("_didPerformOutputOperation"));
}

@end
