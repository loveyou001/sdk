//
//  DelegateMEGATransferListener.m
//
//  Created by Javier Navarro on 08/10/14.
//  Copyright (c) 2014 MEGA. All rights reserved.
//

#import "DelegateMEGATransferListener.h"
#import "MEGATransfer+init.h"
#import "MEGAError+init.h"
#import "MEGASdk+init.h"

using namespace mega;

DelegateMEGATransferListener::DelegateMEGATransferListener(MEGASdk *megaSDK, id<MEGATransferDelegate>listener, bool singleListener) {
    this->megaSDK = megaSDK;
    this->listener = listener;
    this->singleListener = singleListener;
}

id<MEGATransferDelegate>DelegateMEGATransferListener::getUserListener() {
    return listener;
}

void DelegateMEGATransferListener::onTransferStart(MegaApi *api, MegaTransfer *transfer) {
    if (listener != nil) {
        MegaTransfer *tempTransfer = transfer->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onTransferStart:this->megaSDK transfer:[[MEGATransfer alloc] initWithMegaTransfer:tempTransfer cMemoryOwn:YES]];
        });
    }
}

void DelegateMEGATransferListener::onTransferFinish(MegaApi *api, MegaTransfer *transfer, MegaError *e) {
    if (listener != nil) {
        MegaTransfer *tempTransfer = transfer->copy();
        MegaError *tempError = e->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onTransferFinish:this->megaSDK transfer:[[MEGATransfer alloc] initWithMegaTransfer:tempTransfer cMemoryOwn:YES] error:[[MEGAError alloc] initWithMegaError:tempError cMemoryOwn:YES]];
            if (singleListener) {
                [megaSDK freeTransferListener:this];
            }
        });
    }
}

void DelegateMEGATransferListener::onTransferUpdate(MegaApi *api, MegaTransfer *transfer) {
    if (listener != nil) {
        MegaTransfer *tempTransfer = transfer->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onTransferUpdate:this->megaSDK transfer:[[MEGATransfer alloc] initWithMegaTransfer:tempTransfer cMemoryOwn:YES]];
        });
    }
}

void DelegateMEGATransferListener::onTransferTemporaryError(MegaApi *api, MegaTransfer *transfer, MegaError *e) {
    if (listener != nil) {
        MegaTransfer *tempTransfer = transfer->copy();
        MegaError *tempError = e->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onTransferTemporaryError:this->megaSDK transfer:[[MEGATransfer alloc] initWithMegaTransfer:tempTransfer cMemoryOwn:YES] error:[[MEGAError alloc] initWithMegaError:tempError cMemoryOwn:YES]];
        });
    }
}
