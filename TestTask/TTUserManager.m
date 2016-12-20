//
//  TTUserManager.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUserManager.h"
#import "TTUser.h"
#import <BlocksKit/BlocksKit.h>
#import <AddressBook/AddressBook.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface TTUserManager ()

@property ABAddressBookRef addressBook;

@end

@implementation TTUserManager
- (instancetype)init {
    if (self = [super init]) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    if (!(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)) {
        [self askPermissions]; 
    }
    
    return self;
}

- (void)fetchUsers {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"user_storage" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    
    NSMutableArray *userStorage = [NSMutableArray new];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //REFACTOR IMPLEMENT MAP
    
    [[jsonData objectForKey:@"users"] bk_each:^(id obj) {
        NSString *username = [obj objectForKey:@"username"];
        NSString *displayName = [obj objectForKey:@"display_name"];
        TTUserStatus status = [[obj objectForKey:@"status"] integerValue];
        NSArray *phoneNumbers = [obj objectForKey:@"phone_numbers"];
        
        TTUser *user = [[TTUser alloc] initWithUsername:username];
        user.displayName = displayName;
        user.status = status;
        user.phoneNumbers = phoneNumbers; 
        
        [userStorage addObject:user];
    }];
    
    
    self.users = userStorage;
    [self changeStatus]; 
    [self fetchAddressBookUsers]; 
}

- (void)changeStatus {
    NSMutableArray<TTUser *> *usersLocal = [NSMutableArray arrayWithArray:self.users];
    
    [usersLocal bk_each:^(TTUser *obj) {
        NSInteger newStatus = arc4random_uniform(3);
        obj.status = newStatus;
    }];
    
    self.users = usersLocal;
    
    NSLog(@"Updated statuses");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeStatus];
    });
}


//Check permission authorisation process
- (void)askPermissions {
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted){
            NSLog(@"Just denied");
            return;
        }
        [self fetchAddressBookUsers]; 
    });
}

- (void)fetchAddressBookUsers {
    if (!(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)) {
        return;
    }
    ABRecordRef source = ABAddressBookCopyDefaultSource(self.addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBook, source, kABPersonSortByFirstName));
    
    CFIndex nPeople = CFArrayGetCount(allPeople);
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
           
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            NSString *fName= [(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            NSString *lName = [(__bridge NSString*)lastName copy];
            
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            if (!fName)
                fName = @"";
            
            if(!lastName)
                lName = @"";
            
            if (!lastName && !firstName) {
                continue;
            }
            
            NSString *username = [NSString stringWithFormat:@"%@ %@", fName, lName];
            
            TTUser *user = [[TTUser alloc] initWithUsername:username];
            user.displayName = username;
            
            CFDataRef imgData = ABPersonCopyImageData(person);
            NSData *imageData = (__bridge NSData *)imgData;
            user.image = [UIImage imageWithData:imageData];
            
            if (imgData != NULL) {
                CFRelease(imgData);
            }

            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            user.phoneNumbers = phoneNumbers;
            user.userType = PhoneBook;
            
            [items addObject:user];
        }
    }
    CFRelease(allPeople);
    CFRelease(source);
    
    NSMutableArray *usersMut = self.users.mutableCopy;
    [usersMut addObjectsFromArray:items];
    
    self.users = usersMut; 
    
    NSLog(@"");
}

@end
