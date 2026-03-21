/*
 * Filename: backend_pdf.m
 * Project: Appine (App in Emacs)
 * Description: Emacs dynamic module to embed native macOS views 
 *              (WebKit, PDFKit, Quick Look, etc.) directly inside Emacs windows.
 * Author: Huang Chao <huangchao.cpp@gmail.com>
 * Copyright (C) 2026, Huang Chao, all rights reserved.
 * URL: https://github.com/chaoswork/appine
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#import "appine_backend.h"
#import <PDFKit/PDFKit.h>

@interface AppinePdfBackend : NSObject <AppineBackend>
@property (nonatomic, strong) PDFView *pdfView;
@property (nonatomic, copy) NSString *path;
@end

@implementation AppinePdfBackend

- (AppineBackendKind)kind {
    return AppineBackendKindPDF;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = [path copy];
        _pdfView = [[PDFView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [_pdfView setAutoScales:YES];
        [_pdfView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        
        if (_path && _path.length > 0) {
            NSURL *url = [NSURL fileURLWithPath:_path];
            if (url) {
                PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
                if (doc) {
                    [_pdfView setDocument:doc];
                }
            }
        }
    }
    return self;
}

- (NSView *)view {
    return self.pdfView;
}

- (NSString *)title {
    return [self.path lastPathComponent] ?: @"PDF";
}

@end

// C API export
id<AppineBackend> appine_create_pdf_backend(NSString *path) {
    return [[AppinePdfBackend alloc] initWithPath:path];
}
