//
//  ALTPreferencesViewController.m
//  AltDeploy
//
//  Created by PixelOmer on 10.01.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import "ALTPreferencesViewController.h"
#import <SAMKeychain/SAMKeychain.h>
#import "ALTMainViewController.h"

@implementation ALTPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"E, d MMM yyyy HH:mm:ss"];
    _tableView.usesStaticContents = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor multiplier:1.0].active =
    [_tableView.centerYAnchor constraintEqualToAnchor:_scrollView.centerYAnchor].active =
    [_tableView.centerXAnchor constraintEqualToAnchor:_scrollView.centerXAnchor].active =
    [_tableView.heightAnchor constraintEqualToAnchor:_scrollView.heightAnchor multiplier:1.0].active = YES;
    [self refreshAccounts];
    // Do view setup here.
}

- (void)refreshAccounts {
	accounts = [SAMKeychain accountsForService:NSBundle.mainBundle.bundleIdentifier];
    [_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return accounts.count;
}

- (id _Nullable)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([tableColumn.identifier isEqualToString:@"appleIDColumn"]) {
		// Apple ID
		return accounts[row][kSAMKeychainAccountKey];
	}
	else {
		// Last modified
		return [dateFormatter stringFromDate:accounts[row][kSAMKeychainLastModifiedKey]];
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn {
	return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	BOOL enableButtons = (_tableView.selectedRow != -1);
	_modifyButton.enabled = enableButtons;
	_removeButton.enabled = enableButtons;
	_setAsDefaultButton.enabled = enableButtons;
}

@end
